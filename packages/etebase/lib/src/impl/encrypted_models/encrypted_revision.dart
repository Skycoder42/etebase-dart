import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../api/exceptions/crypto_failure.dart';
import '../../api/exceptions/integrity_compromised.dart';
import '../../api/exceptions/missing_content.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../codec/byte_array_converter.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../managers/client.dart';
import 'cached/cached_chunk.dart';
import 'cached/cached_revision.dart';
import 'chunk.dart';
import 'chunker_sink.dart';

part 'encrypted_revision.g.dart';

@internal
@JsonSerializable()
@msgPackBytes
class EncryptedRevision {
  late String uid;
  late Uint8List meta;
  bool deleted = false;
  List<Chunk> chunks = [];

  @visibleForTesting
  EncryptedRevision();

  static Future<EncryptedRevision> create({
    required Client client,
    required CollectionItemCryptoManager cryptoManager,
    required Uint8List additionalData,
    required EtebaseItemMetadata meta,
    required Uint8List content,
  }) async {
    final revision = EncryptedRevision();
    await revision.setContent(
      client,
      cryptoManager,
      additionalData: additionalData,
      content: content,
      metaData: meta,
    );
    return revision;
  }

  factory EncryptedRevision.fromJson(Map<String, dynamic> json) =>
      _$EncryptedRevisionFromJson(json);

  factory EncryptedRevision.cacheLoad(Client client, Uint8List cachedData) {
    final cached = client.converter.decode<CachedRevision>(cachedData);
    return EncryptedRevision()
      ..uid = client.converter.base64Encode(cached.uid)
      ..meta = cached.meta
      ..deleted = cached.deleted
      ..chunks = cached.chunks
          .map(
            (chunk) =>
                Chunk(client.converter.base64Encode(chunk.uid), chunk.data),
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

  Future<void> verify(
    Client client,
    CollectionItemCryptoManager cryptoManager,
    Uint8List additionalData,
  ) async {
    final mac = client.converter.base64Decode(uid);
    final adHash = await _calculateAdHash(
      client,
      cryptoManager,
      additionalData,
    );
    try {
      await cryptoManager.verify(meta, mac, adHash);
    } on CryptoFailure {
      throw IntegrityCompromised('mac verification failed');
    }
  }

  Future<void> setMeta(
    Client client,
    CollectionItemCryptoManager cryptoManager,
    Uint8List additionalData,
    EtebaseItemMetadata meta,
  ) async {
    final adHash = await _calculateAdHash(
      client,
      cryptoManager,
      additionalData,
    );
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
    final adHash = await _calculateAdHash(
      client,
      cryptoManager,
      additionalData,
    );
    return client.converter.decode<TMeta>(
      client.crypto.bufferUnpadSmall(
        await cryptoManager.decryptDetached(meta, mac, adHash),
      ),
    );
  }

  Future<void> setContentStream(
    Client client,
    CollectionItemCryptoManager cryptoManager, {
    required Uint8List additionalData,
    required Stream<List<int>> content,
    @visibleForTesting EtebaseItemMetadata? metaData,
  }) async {
    final meta =
        metaData ?? await getMeta(client, cryptoManager, additionalData);

    late final chunker = cryptoManager.getChunker();

    Future<Chunk> createChunk(Uint8List data) async {
      final hash = client.converter.base64Encode(
        await cryptoManager.calculateMac(data),
      );
      return Chunk(hash, data);
    }

    var chunks = await content.chunked(chunker).asyncMap(createChunk).toList();

    // Shuffle the items and save the ordering if we have more than one
    if (chunks.isNotEmpty) {
      var indices = client.crypto.shuffle(chunks);

      // Filter duplicates and construct the indices list.
      final uniqueChunksMap = <String, Chunk>{}; // uses LinkedHashMap

      for (final chunk in chunks) {
        uniqueChunksMap.putIfAbsent(chunk.uid, () => chunk);
      }
      final uniqueKeys = uniqueChunksMap.keys.toList(growable: false);

      indices = indices
          .map((i) {
            final Chunk(:uid) = chunks[i];
            return uniqueKeys.indexOf(uid);
          })
          .toList(growable: false);

      chunks = uniqueChunksMap.values.toList();

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

  Future<void> setContent(
    Client client,
    CollectionItemCryptoManager cryptoManager, {
    required Uint8List additionalData,
    required Uint8List content,
    @visibleForTesting EtebaseItemMetadata? metaData,
  }) async => await setContentStream(
    client,
    cryptoManager,
    additionalData: additionalData,
    content: Stream.value(content),
    metaData: metaData,
  );

  Stream<Uint8List> getContentStream(
    Client client,
    CollectionItemCryptoManager cryptoManager,
  ) async* {
    var indices = const [0];
    final decryptedChunks = await Stream.fromIterable(chunks).asyncMap((
      chunk,
    ) async {
      final Chunk(:uid, :data) = chunk;
      if (data == null) {
        throw MissingContent(
          'Missing content for item. '
          'Please download it using downloadContent',
        );
      }

      final buf = await client.crypto.bufferUnpad(
        await cryptoManager.decrypt(data),
      );
      final hash = await cryptoManager.calculateMac(buf);

      if (!const ListEquality<int>().equals(
        hash,
        client.converter.base64Decode(uid),
      )) {
        throw IntegrityCompromised(
          "The content's mac is different to the expected mac ($uid)",
        );
      }
      return buf;
    }).toList();

    // If we have more than one chunk we have the mapping header in the last
    // chunk
    if (chunks.length > 1) {
      final [List<dynamic> rawIndices, ..._] =
          client.converter.decodeRaw(decryptedChunks.removeLast())
              as List<dynamic>;
      indices = rawIndices.cast();
    }

    // We need to unshuffle the chunks
    if (indices.length > 1) {
      for (final index in indices) {
        yield decryptedChunks[index];
      }
    } else if (decryptedChunks.isNotEmpty) {
      yield decryptedChunks[0];
    }
  }

  Future<Uint8List> getContent(
    Client client,
    CollectionItemCryptoManager cryptoManager,
  ) async {
    final contentBuilder = BytesBuilder(copy: false);
    await getContentStream(client, cryptoManager).forEach(contentBuilder.add);
    return contentBuilder.takeBytes();
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
    ..chunks = [...chunks];

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
