import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/exceptions/integrity_compromised.dart';
import '../../api/exceptions/missing_content.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../codec/byte_array_converter.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../managers/client.dart';
import 'cached/cached_chunk.dart';
import 'cached/cached_revision.dart';
import 'chunk.dart';

part 'encrypted_revision.g.dart';

@internal
@JsonSerializable()
@msgPackBytes
class EncryptedRevision {
  late String uid;
  late Uint8List meta;
  bool deleted = false;
  List<Chunk> chunks = [];

  EncryptedRevision();

  static Future<EncryptedRevision> create({
    required Client client,
    required CollectionItemCryptoManager cryptoManager,
    required Uint8List additionalData,
    required EtebaseItemMetadata meta,
    required Uint8List content,
  }) async {
    final revision = EncryptedRevision();
    await revision.setMeta(client, cryptoManager, additionalData, meta);
    await revision.setContent(
      client,
      cryptoManager,
      additionalData: additionalData,
      content: content,
    );
    return revision;
  }

  factory EncryptedRevision.fromJson(Map<String, dynamic> json) =>
      _$EncryptedRevisionFromJson(json);

  factory EncryptedRevision.cacheLoad(
    Client client,
    Uint8List cachedData,
  ) {
    final cached = client.converter.decode<CachedRevision>(cachedData);
    return EncryptedRevision()
      ..uid = client.converter.base64Encode(cached.uid)
      ..meta = cached.meta
      ..deleted = cached.deleted
      ..chunks = cached.chunks
          .map(
            (chunk) => Chunk(
              client.converter.base64Encode(chunk.uid),
              chunk.data,
            ),
          )
          .toList();
  }

  Map<String, dynamic> toJson() => _$EncryptedRevisionToJson(this);

  Uint8List cacheSave(Client client, {required bool saveContent}) =>
      client.converter.encode(
        CachedRevision(
          uid: client.converter.base64Decode(uid),
          meta: meta,
          deleted: deleted,
          chunks: chunks
              .map(
                (chunk) => CachedChunk(
                  client.converter.base64Decode(chunk.uid),
                  saveContent ? chunk.data : null,
                ),
              )
              .toList(),
        ),
      );

  Future<bool> verify(
    Client client,
    CollectionItemCryptoManager cryptoManager,
    Uint8List additionalData,
  ) async {
    final mac = client.converter.base64Decode(uid);
    final adHash =
        await _calculateAdHash(client, cryptoManager, additionalData);
    try {
      return await cryptoManager.verify(meta, mac, adHash);
    } on SodiumException {
      throw IntegrityCompromised('mac verification failed');
    }
  }

  Future<void> setMeta(
    Client client,
    CollectionItemCryptoManager cryptoManager,
    Uint8List additionalData,
    EtebaseItemMetadata meta,
  ) async {
    final adHash =
        await _calculateAdHash(client, cryptoManager, additionalData);
    final encMeta = await cryptoManager.encryptDetached(
      client.crypto.bufferPadSmall(client.converter.encode(meta)),
      adHash,
    );
    this.meta = encMeta.nonceCipherText;
    uid = client.converter.base64Encode(encMeta.mac);
  }

  Future<TMeta> getMeta<TMeta extends EtebaseItemMetadata>(
    Client client,
    CollectionItemCryptoManager cryptoManager,
    Uint8List additionalData,
  ) async {
    final mac = client.converter.base64Decode(uid);
    final adHash =
        await _calculateAdHash(client, cryptoManager, additionalData);
    return client.converter.decode<TMeta>(
      client.crypto.bufferUnpadSmall(
        await cryptoManager.decryptDetached(meta, mac, adHash),
      ),
    );
  }

  Future<void> setContent(
    Client client,
    CollectionItemCryptoManager cryptoManager, {
    required Uint8List additionalData,
    required Uint8List content,
  }) async {
    final meta = await getMeta(client, cryptoManager, additionalData);

    var chunks = <Chunk>[];
    const minChunk = 1 << 14;
    const maxChunk = 1 << 16;
    var chunkStart = 0;

    // Only try chunking if our content is larger than the minimum chunk size
    if (content.length > minChunk) {
      final buzhash = cryptoManager.getChunker();
      const mask = (1 << 12) - 1;

      var pos = 0;
      while (pos < content.length) {
        buzhash.update(content[pos]);
        if (pos - chunkStart >= minChunk) {
          if ((pos - chunkStart >= maxChunk) || (buzhash.split(mask))) {
            final buf = content.sublist(chunkStart, pos);
            final hash = client.converter.base64Encode(
              await cryptoManager.calculateMac(buf),
            );
            chunks.add(Chunk(hash, buf));
            chunkStart = pos;
          }
        }
        pos++;
      }
    }

    if (chunkStart < content.length) {
      final buf = content.sublist(chunkStart);
      final hash = client.converter.base64Encode(
        await cryptoManager.calculateMac(buf),
      );
      chunks.add(Chunk(hash, buf));
    }

    // Shuffle the items and save the ordering if we have more than one
    if (chunks.isNotEmpty) {
      final indices = client.crypto.shuffle(chunks);

      // Filter duplicates and construct the indice list.
      final uidIndices = <String, int>{};
      chunks = chunks.whereIndexed((i, chunk) {
        final Chunk(:uid) = chunk;
        final previousIndex = uidIndices[uid];
        if (previousIndex != null) {
          indices[i] = previousIndex;
          return false;
        } else {
          uidIndices[uid] = i;
          return true;
        }
      }).toList();

      // If we have more than one chunk we need to encode the mapping header in
      // the last chunk
      if (indices.length > 1) {
        // We encode it in an array so we can extend it later on if needed
        final buf = client.converter.encodeRaw([indices]);
        final hash = client.converter.base64Encode(
          await cryptoManager.calculateMac(buf),
        );
        chunks.add(Chunk(hash, buf));
      }
    }

    // Encrypt all of the chunks
    this.chunks = await Stream.fromIterable(chunks)
        .asyncMap(
          (chunk) async => Chunk(
            chunk.uid,
            await cryptoManager.encrypt(
              await client.crypto.bufferPad(chunk.data!),
            ),
          ),
        )
        .toList();

    await setMeta(client, cryptoManager, additionalData, meta);
  }

  Future<Uint8List> getContent(
    Client client,
    CollectionItemCryptoManager cryptoManager,
  ) async {
    var indices = [0];
    final decryptedChunks =
        await Stream.fromIterable(chunks).asyncMap((chunk) async {
      final Chunk(:uid, :data) = chunk;
      if (data == null) {
        throw MissingContent(
          'Missing content for item. Please download it using downloadContent',
        );
      }

      final buf = await client.crypto.bufferUnpad(
        await cryptoManager.decrypt(data),
      );
      final hash = await cryptoManager.calculateMac(buf);

      if (!const ListEquality<int>()
          .equals(hash, client.converter.base64Decode(uid))) {
        throw IntegrityCompromised(
          "The content's mac is different to the expected mac ($uid)",
        );
      }
      return buf;
    }).toList();

    // If we have more than one chunk we have the mapping header in the last
    // chunk
    if (chunks.length > 1) {
      final lastChunk = client.converter.decodeRaw(decryptedChunks.removeLast())
          as List<List<int>>;
      indices = lastChunk[0];
    }

    // We need to unshuffle the chunks
    if (indices.length > 1) {
      final sortedChunksBuilder = BytesBuilder(copy: false);
      for (final index in indices) {
        sortedChunksBuilder.add(decryptedChunks[index]);
      }
      return sortedChunksBuilder.takeBytes();
    } else if (decryptedChunks.isNotEmpty) {
      return decryptedChunks[0];
    } else {
      return Uint8List(0);
    }
  }

  Future<void> delete(
    Client client,
    CollectionItemCryptoManager cryptoManager,
    Uint8List additionalData, {
    required bool preserveContent,
  }) async {
    final meta = await getMeta(client, cryptoManager, additionalData);

    if (!preserveContent) {
      chunks = [];
    }
    deleted = true;

    await setMeta(client, cryptoManager, additionalData, meta);
  }

  EncryptedRevision clone() => EncryptedRevision()
    ..uid = uid
    ..meta = meta
    ..deleted = deleted
    ..chunks = chunks;

  Future<Uint8List> _calculateAdHash(
    Client client,
    CollectionItemCryptoManager cryptoManager,
    Uint8List additionalData,
  ) async {
    final cryptoMac = cryptoManager.getCryptoMac()
      ..update(Uint8List.fromList([if (deleted) 1 else 0]))
      ..updateWithLenPrefix(additionalData);

    final chunksHash = cryptoManager.getCryptoMac(withKey: false);
    for (final Chunk(:uid) in chunks) {
      chunksHash.update(client.converter.base64Decode(uid));
    }
    cryptoMac.update(await chunksHash.finalize());

    return cryptoMac.finalize();
  }
}
