import 'dart:async';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/models/etebase_item_metadata.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../crypto/crypto_service.dart';
import '../crypto/minimal_collection_crypto_manager.dart';
import '../managers/client.dart';
import '../rest/converters/msg_pack_converters.dart';
import 'chunk.dart';
import 'encrypted_revision.dart';

part 'encrypted_collection_item.g.dart';

@internal
@JsonSerializable()
@msgPackBytes
class EncryptedCollectionItem {
  static const _cacheFormatVersion = 1;

  late String uid;
  int version = CryptoService.currentVersion;
  @JsonKey(
    name: 'encryptionKey',
    includeFromJson: true,
    includeToJson: true,
    includeIfNull: false,
  )
  Uint8List? _encryptionKey; //  TODO make secure key
  @JsonKey(name: 'content', includeFromJson: true, includeToJson: true)
  late EncryptedRevision<CollectionItemCryptoManager> _content;
  String? lastEtag;

  bool get isDeleted => _content.deleted;

  String get etag => _content.uid;

  bool get isMissingContent => _missingChunks.isNotEmpty;

  EncryptedCollectionItem();

  static Future<EncryptedCollectionItem> create(
    Client client,
    MinimalCollectionCryptoManager parentCm,
    EtebaseItemMetadata meta,
    Uint8List content,
  ) async {
    final item = EncryptedCollectionItem()..uid = client.crypto.genUidBase64();
    return item.withCm(
      client,
      parentCm,
      (cm) async => item
        .._content = await EncryptedRevision.create(
          client: client,
          cryptoManager: cm,
          additionalData: item._getAdditionalMacData(),
          meta: meta,
          content: content,
        ),
    );
  }

  factory EncryptedCollectionItem.fromJson(Map<String, dynamic> json) =>
      _$EncryptedCollectionItemFromJson(json);

  factory EncryptedCollectionItem.cacheLoad(
    Client client,
    Uint8List cachedData,
  ) {
    final [
      _,
      Uint8List uid,
      int version,
      Uint8List? encryptionKey,
      Uint8List? lastEtag,
      Uint8List content,
    ] = client.coder.decodeRaw(cachedData) as List;
    return EncryptedCollectionItem()
      ..uid = client.coder.base64Encode(uid)
      ..version = version
      .._encryptionKey = encryptionKey
      ..lastEtag = lastEtag != null ? client.coder.base64Encode(lastEtag) : null
      .._content = EncryptedRevision.cacheLoad(
        client,
        content,
      );
  }

  Map<String, dynamic> toJson() => _$EncryptedCollectionItemToJson(this);

  Uint8List cacheSave(Client client, {required bool saveContent}) =>
      client.coder.encode([
        _cacheFormatVersion,
        client.coder.base64Decode(uid),
        version,
        _encryptionKey,
        if (lastEtag case final String etag)
          client.coder.base64Decode(etag)
        else
          null,
        _content.cacheSave(client, saveContent: saveContent),
      ]);

  void markSaved() => lastEtag = _content.uid;

  Future<bool> verify(
    Client client,
    CollectionItemCryptoManager cm,
  ) =>
      _content.verify(client, cm, _getAdditionalMacData());

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

  Future<EtebaseItemMetadata> getMeta(
    Client client,
    CollectionItemCryptoManager cm,
  ) async {
    await verify(client, cm);
    return _content.getMeta(client, cm, _getAdditionalMacData());
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
    return _content.getContent(client, cm);
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
    final cm = await _getCryptoManager(client, parentCm);
    try {
      return await callback(cm);
    } finally {
      await cm.dispose();
    }
  }

  Iterable<Chunk> get _pendingChunks => _content.chunks;

  Iterable<Chunk> get _missingChunks =>
      _content.chunks.where((c) => c.data == null);

  bool _isLocallyChanged() => lastEtag != _content.uid;

  Future<void> _cloneOrUpdateRevision(
    FutureOr<void> Function(
      EncryptedRevision<CollectionItemCryptoManager> rev,
    ) callback,
  ) async {
    final rev = _isLocallyChanged() ? _content : _content.clone();
    await callback(rev);
    _content = rev;
  }

  Uint8List _getAdditionalMacData() => uid.toCharArray().unsignedView();

  Future<SecureKey> _getEncryptionKey(
    Client client,
    MinimalCollectionCryptoManager parentCm,
  ) async {
    if (_encryptionKey case final Uint8List key) {
      return client.crypto.secureCopy(key);
    }
    return parentCm.deriveSubkey(_getAdditionalMacData());
  }

  Future<CollectionItemCryptoManager> _getCryptoManager(
    Client client,
    MinimalCollectionCryptoManager parentCm,
  ) async =>
      client.crypto.createCollectionItemCryptoManager(
        await _getEncryptionKey(client, parentCm),
        version: version,
      );

  Future<MinimalCollectionCryptoManager> _getHierarchicalCryptoManager(
    Client client,
    MinimalCollectionCryptoManager parentCm,
  ) async =>
      client.crypto.createMinimalCollectionCryptoManager(
        await _getEncryptionKey(client, parentCm),
        version: version,
      );
}
