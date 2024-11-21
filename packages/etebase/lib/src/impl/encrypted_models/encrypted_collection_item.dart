import 'dart:async';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/exceptions/api_missuse.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../codec/msg_pack_converters.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../crypto/crypto_utils.dart';
import '../crypto/minimal_collection_crypto_manager.dart';
import '../managers/client.dart';
import 'cached/cached_collection_item.dart';
import 'chunk.dart';
import 'encrypted_revision.dart';

part 'encrypted_collection_item.g.dart';

@internal
@JsonSerializable()
@msgPackBytes
class EncryptedCollectionItem {
  late String uid;
  int version = CryptoUtils.currentVersion;
  @JsonKey(
    name: 'encryptionKey',
    includeFromJson: true,
    includeToJson: true,
    includeIfNull: false,
  )
  Uint8List? _encryptionKey; //  TODO make secure key
  late EncryptedRevision<CollectionItemCryptoManager> content;
  @JsonKey(name: 'etag', includeFromJson: false, includeToJson: true)
  String? _etag;

  bool get isDeleted => content.deleted;

  String get etag => content.uid;

  String? get lastEtag => _etag;

  bool get isMissingContent => missingChunks.isNotEmpty;

  Iterable<Chunk> get pendingChunks => content.chunks;

  Iterable<Chunk> get missingChunks =>
      content.chunks.where((c) => c.data == null);

  bool get _isLocallyChanged => _etag != content.uid;

  EncryptedCollectionItem();

  static Future<(EncryptedCollectionItem, CollectionItemCryptoManager)> create(
    Client client,
    MinimalCollectionCryptoManager parentCm,
    EtebaseItemMetadata meta,
    Uint8List content,
  ) async {
    final item = EncryptedCollectionItem()
      ..uid = client.converter.base64Encode(client.crypto.randomBytes(24));
    final cm = item.getCryptoManager(client, parentCm);
    try {
      item.content = await EncryptedRevision.create(
        client: client,
        cryptoManager: cm,
        additionalData: item._getAdditionalMacData(),
        meta: meta,
        content: content,
      );
      return (item, cm);
    } catch (_) {
      cm.dispose();
      rethrow;
    }
  }

  factory EncryptedCollectionItem.fromJson(Map<String, dynamic> json) =>
      _$EncryptedCollectionItemFromJson(json)..markSaved();

  factory EncryptedCollectionItem.cacheLoad(
    Client client,
    Uint8List cachedData,
  ) {
    final cached = client.converter.decode<CachedCollectionItem>(cachedData);
    return EncryptedCollectionItem()
      ..uid = client.converter.base64Encode(cached.uid)
      ..version = cached.version
      .._encryptionKey = cached.encryptionKey
      .._etag = switch (cached.etag) {
        final Uint8List etag => client.converter.base64Encode(etag),
        _ => null,
      }
      ..content = EncryptedRevision.cacheLoad(
        client,
        cached.revision,
      );
  }

  Map<String, dynamic> toJson() => _$EncryptedCollectionItemToJson(this);

  Uint8List cacheSave(Client client, {required bool saveContent}) =>
      client.converter.encode(
        CachedCollectionItem(
          uid: client.converter.base64Decode(uid),
          version: version,
          encryptionKey: _encryptionKey,
          etag: switch (_etag) {
            final String etag => client.converter.base64Decode(etag),
            _ => null,
          },
          revision: content.cacheSave(client, saveContent: saveContent),
        ),
      );

  EncryptedCollectionItem cloneWithRevision(
    EncryptedRevision revision,
  ) =>
      EncryptedCollectionItem()
        ..uid = uid
        .._encryptionKey = _encryptionKey
        ..version = version
        ..content = revision
        ..markSaved();

  void markSaved() => _etag = content.uid;

  void updateChunk(Chunk chunk) {
    final index = content.chunks.indexWhere((c) => c.uid == chunk.uid);
    if (index == -1) {
      throw ApiMissuse('Tried to update a chunk on an unrelated item');
    }
    content.chunks[index] = chunk;
  }

  Future<bool> verify(
    Client client,
    CollectionItemCryptoManager cm,
  ) =>
      content.verify(client, cm, _getAdditionalMacData());

  Future<void> setMeta(
    Client client,
    CollectionItemCryptoManager cm,
    EtebaseItemMetadata meta,
  ) =>
      _cloneOrUpdateRevision(
        (rev) => rev.setMeta(
          client,
          cm,
          _getAdditionalMacData(),
          meta,
        ),
      );

  Future<TMeta> getMeta<TMeta extends EtebaseItemMetadata>(
    Client client,
    CollectionItemCryptoManager cm,
  ) async {
    await verify(client, cm);
    return content.getMeta<TMeta>(client, cm, _getAdditionalMacData());
  }

  Future<void> setContent(
    Client client,
    CollectionItemCryptoManager cm,
    Uint8List content,
  ) =>
      _cloneOrUpdateRevision(
        (rev) => rev.setContent(
          client,
          cm,
          additionalData: _getAdditionalMacData(),
          content: content,
        ),
      );

  Future<Uint8List> getContent(
    Client client,
    CollectionItemCryptoManager cm,
  ) async {
    await verify(client, cm);
    return content.getContent(client, cm);
  }

  Future<void> delete(
    Client client,
    CollectionItemCryptoManager cm, {
    required bool preserveContent,
  }) =>
      _cloneOrUpdateRevision(
        (rev) => rev.delete(
          client,
          cm,
          _getAdditionalMacData(),
          preserveContent: preserveContent,
        ),
      );

  Future<T> withCm<T>(
    Client client,
    MinimalCollectionCryptoManager parentCm,
    FutureOr<T> Function(CollectionItemCryptoManager cm) callback,
  ) async {
    final cm = getCryptoManager(client, parentCm);
    try {
      return await callback(cm);
    } finally {
      cm.dispose();
    }
  }

  Future<void> _cloneOrUpdateRevision(
    FutureOr<void> Function(EncryptedRevision rev) callback,
  ) async {
    final rev = _isLocallyChanged ? content : content.clone();
    await callback(rev);
    content = rev;
  }

  Uint8List _getAdditionalMacData() => uid.toCharArray().unsignedView();

  SecureKey _getEncryptionKey(
    Client client,
    MinimalCollectionCryptoManager parentCm,
  ) {
    if (_encryptionKey case final Uint8List key) {
      return client.crypto.secureCopy(key);
    }
    return parentCm.deriveSubkey(_getAdditionalMacData());
  }

  CollectionItemCryptoManager getCryptoManager(
    Client client,
    MinimalCollectionCryptoManager parentCm,
  ) =>
      client.crypto.createCollectionItemCryptoManager(
        _getEncryptionKey(client, parentCm),
        version: version,
      );
}
