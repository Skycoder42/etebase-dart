import 'dart:async';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/models/etebase_collection_access_level.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../crypto/account_crypto_manager.dart';
import '../crypto/box_crypto_manager.dart';
import '../crypto/collection_crypto_manager.dart';
import '../crypto/crypto_manager.dart';
import '../crypto/crypto_service.dart';
import '../crypto/minimal_collection_crypto_manager.dart';
import '../managers/client.dart';
import '../models/signed_invitation.dart';
import '../models/signed_invitation_content.dart';
import '../rest/converters/msg_pack_converters.dart';
import 'encrypted_collection_item.dart';

part 'encrypted_collection.g.dart';

@internal
@JsonSerializable()
@msgPackBytes
class EncryptedCollection {
  static const _cacheFormatVersion = 1;
  static const _invitationUidSize = 32;

  @JsonKey(name: 'collectionKey', includeFromJson: true, includeToJson: true)
  late Uint8List _collectionKey;
  @JsonKey(name: 'collectionType', includeFromJson: true, includeToJson: true)
  late Uint8List _collectionType;
  @JsonKey(name: 'item', includeFromJson: true, includeToJson: true)
  late EncryptedCollectionItem _item;
  @JsonKey(name: 'accessLevel', includeFromJson: true, includeToJson: true)
  EtebaseCollectionAccessLevel _accessLevel =
      EtebaseCollectionAccessLevel.admin;
  @JsonKey(name: 'stoken', includeFromJson: true, includeToJson: true)
  String? _stoken;

  String get uid => _item.uid;

  String get etag => _item.etag;

  String? get lastEtag => _item.lastEtag;

  int get version => _item.version;

  bool get isDeleted => _item.isDeleted;

  EncryptedCollection();

  static Future<(EncryptedCollection, CollectionCryptoManager)> create(
    Client client,
    AccountCryptoManager parentCm,
    String collectionTypeName,
    EtebaseItemMetadata meta,
    Uint8List content,
  ) async {
    final col = EncryptedCollection()
      .._collectionType = await parentCm.colTypeToUid(collectionTypeName);

    final collectionKey = client.crypto.secureRandom(CryptoManager.keySize);
    try {
      col._collectionKey = await parentCm.encryptKey(
        collectionKey,
        col._collectionType,
      );
    } finally {
      collectionKey.dispose();
    }

    final cm = await col.getCryptoManager(client, parentCm);
    try {
      col._item = await EncryptedCollectionItem.create(
        client,
        cm,
        meta,
        content,
      );
      return (col, cm);
    } catch (_) {
      await cm.dispose();
      rethrow;
    }
  }

  factory EncryptedCollection.fromJson(Map<String, dynamic> json) =>
      _$EncryptedCollectionFromJson(json);

  factory EncryptedCollection.cacheLoad(Client client, Uint8List cachedData) {
    final [
      _,
      Uint8List collectionKey,
      EtebaseCollectionAccessLevel accessLevel,
      String? stoken,
      Uint8List item,
      Uint8List collectionType,
    ] = client.coder.decodeRaw(cachedData) as List;
    return EncryptedCollection()
      .._collectionKey = collectionKey
      .._collectionType = collectionType
      .._item = EncryptedCollectionItem.cacheLoad(client, item)
      .._accessLevel = accessLevel
      .._stoken = stoken;
  }

  Map<String, dynamic> toJson() => _$EncryptedCollectionToJson(this);

  Uint8List cacheSave(Client client, {required bool saveContent}) =>
      client.coder.encode([
        _cacheFormatVersion,
        _collectionKey,
        _accessLevel,
        _stoken,
        _item.cacheSave(client, saveContent: saveContent),
        _collectionType,
      ]);

  void markSaved() => _item.markSaved();

  Future<bool> verify(
    Client client,
    MinimalCollectionCryptoManager cm,
  ) =>
      _item.withCm(client, cm, (cm) => _item.verify(client, cm));

  Future<void> setMeta(
    Client client,
    MinimalCollectionCryptoManager cm,
    EtebaseItemMetadata meta,
  ) =>
      _item.withCm(client, cm, (cm) => _item.setMeta(client, cm, meta));

  Future<EtebaseItemMetadata> getMeta(
    Client client,
    MinimalCollectionCryptoManager cm,
  ) =>
      _item.withCm(client, cm, (cm) => _item.getMeta(client, cm));

  Future<void> setContent(
    Client client,
    MinimalCollectionCryptoManager cm,
    Uint8List content,
  ) =>
      _item.withCm(client, cm, (cm) => _item.setContent(client, cm, content));

  Future<Uint8List> getContent(
    Client client,
    MinimalCollectionCryptoManager cm,
  ) =>
      _item.withCm(client, cm, (cm) => _item.getContent(client, cm));

  Future<void> delete(
    Client client,
    MinimalCollectionCryptoManager cm, {
    required bool preserveContent,
  }) =>
      _item.withCm(
        client,
        cm,
        (cm) => _item.delete(client, cm, preserveContent: preserveContent),
      );

  Future<String> getCollectionType(
    Client client,
    AccountCryptoManager parentCm,
  ) async =>
      parentCm.colTypeFromUid(_collectionType);

  Future<SignedInvitation> createInvitation(
    Client client,
    AccountCryptoManager parentCm,
    BoxCryptoManager identityCm,
    String username,
    Uint8List pubkey,
    EtebaseCollectionAccessLevel accessLevel,
  ) async {
    final encryptionKey = await _getCollectionKey(client, parentCm);
    try {
      final uid = client.crypto.randomBytes(_invitationUidSize);
      final collectionType = await getCollectionType(client, parentCm);
      final signedEncryptionKey =
          await encryptionKey.runUnlockedAsync((encryptionKeyBytes) async {
        final rawContent = client.crypto.bufferPadSmall(
          client.coder.encode(
            SignedInvitationContent(
              encryptionKey: encryptionKeyBytes,
              collectionType: collectionType,
            ),
          ),
        );
        return identityCm.encrypt(message: rawContent, pubKey: pubkey);
      });
      return SignedInvitation(
        uid: client.coder.base64Encode(uid),
        version: CryptoService.currentVersion,
        username: username,
        collection: this.uid,
        accessLevel: accessLevel,
        signedEncryptionKey: signedEncryptionKey,
      );
    } finally {
      encryptionKey.dispose();
    }
  }

  Future<CollectionCryptoManager> getCryptoManager(
    Client client,
    AccountCryptoManager parentCm, {
    int? version,
  }) async =>
      client.crypto.createCollectionCryptoManager(
        parentCm,
        await _getCollectionKey(client, parentCm),
        version: version ?? CryptoService.currentVersion,
      );

  Future<SecureKey> _getCollectionKey(
    Client client,
    AccountCryptoManager parentCm,
  ) async =>
      parentCm.decryptKey(
        _collectionKey,
        _collectionType,
        CryptoManager.keySize,
      );
}
