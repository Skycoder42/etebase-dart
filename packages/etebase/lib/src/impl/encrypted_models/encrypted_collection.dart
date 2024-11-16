import 'dart:async';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/models/etebase_collection_access_level.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../codec/msg_pack_converters.dart';
import '../crypto/account_crypto_manager.dart';
import '../crypto/box_crypto_manager.dart';
import '../crypto/collection_crypto_manager.dart';
import '../crypto/crypto_arena.dart';
import '../crypto/crypto_manager.dart';
import '../crypto/crypto_service.dart';
import '../crypto/minimal_collection_crypto_manager.dart';
import '../managers/client.dart';
import '../models/signed_invitation.dart';
import '../models/signed_invitation_content.dart';
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
  late EncryptedCollectionItem item;
  EtebaseCollectionAccessLevel accessLevel = EtebaseCollectionAccessLevel.admin;
  String? stoken;

  String get uid => item.uid;

  String get etag => item.etag;

  String? get lastEtag => item.lastEtag;

  int get version => item.version;

  bool get isDeleted => item.isDeleted;

  bool get isMissingContent => item.isMissingContent;

  EncryptedCollection();

  static Future<(EncryptedCollection, CollectionCryptoManager)> create(
    Client client,
    AccountCryptoManager parentCm,
    String collectionTypeName,
    EtebaseItemMetadata meta,
    Uint8List content,
  ) async {
    final arena = CryptoArena();
    try {
      final col = EncryptedCollection()
        .._collectionType = await parentCm.colTypeToUid(collectionTypeName);

      col._collectionKey = parentCm.encryptKey(
        arena(client.crypto.secureRandom(CryptoManager.keySize)),
        col._collectionType,
      );

      final cm = arena(col.getCryptoManager(client, parentCm));
      final (item, itemCm) = await EncryptedCollectionItem.create(
        client,
        cm,
        meta,
        content,
      );
      arena(itemCm);
      col.item = item;
      return (col, arena.detach(cm));
    } finally {
      await arena.dispose();
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
    ] = client.converter.decodeRaw(cachedData) as List;
    return EncryptedCollection()
      .._collectionKey = collectionKey
      .._collectionType = collectionType
      ..item = EncryptedCollectionItem.cacheLoad(client, item)
      ..accessLevel = accessLevel
      ..stoken = stoken;
  }

  Map<String, dynamic> toJson() => _$EncryptedCollectionToJson(this);

  Uint8List cacheSave(Client client, {required bool saveContent}) =>
      client.converter.encode([
        _cacheFormatVersion,
        _collectionKey,
        accessLevel,
        stoken,
        item.cacheSave(client, saveContent: saveContent),
        _collectionType,
      ]);

  void markSaved() => item.markSaved();

  Future<bool> verify(
    Client client,
    MinimalCollectionCryptoManager cm,
  ) =>
      item.withCm(client, cm, (cm) => item.verify(client, cm));

  Future<void> setMeta(
    Client client,
    MinimalCollectionCryptoManager cm,
    EtebaseItemMetadata meta,
  ) =>
      item.withCm(client, cm, (cm) => item.setMeta(client, cm, meta));

  Future<TMeta> getMeta<TMeta extends EtebaseItemMetadata>(
    Client client,
    MinimalCollectionCryptoManager cm,
  ) =>
      item.withCm(client, cm, (cm) => item.getMeta<TMeta>(client, cm));

  Future<void> setContent(
    Client client,
    MinimalCollectionCryptoManager cm,
    Uint8List content,
  ) =>
      item.withCm(client, cm, (cm) => item.setContent(client, cm, content));

  Future<Uint8List> getContent(
    Client client,
    MinimalCollectionCryptoManager cm,
  ) =>
      item.withCm(client, cm, (cm) => item.getContent(client, cm));

  Future<void> delete(
    Client client,
    MinimalCollectionCryptoManager cm, {
    required bool preserveContent,
  }) =>
      item.withCm(
        client,
        cm,
        (cm) => item.delete(client, cm, preserveContent: preserveContent),
      );

  Future<String> getCollectionType(
    Client client,
    AccountCryptoManager parentCm,
  ) async =>
      parentCm.colTypeFromUid(_collectionType);

  Future<SignedInvitationWrite> createInvitation(
    Client client,
    AccountCryptoManager parentCm,
    BoxCryptoManager identityCm,
    String username,
    Uint8List pubkey,
    EtebaseCollectionAccessLevel accessLevel,
  ) async {
    final encryptionKey = _getCollectionKey(client, parentCm);
    try {
      final uid = client.crypto.randomBytes(_invitationUidSize);
      final collectionType = await getCollectionType(client, parentCm);
      final signedEncryptionKey =
          await encryptionKey.runUnlockedAsync((encryptionKeyBytes) async {
        final rawContent = client.crypto.bufferPadSmall(
          client.converter.encode(
            SignedInvitationContent(
              encryptionKey: encryptionKeyBytes,
              collectionType: collectionType,
            ),
          ),
        );
        return identityCm.encrypt(message: rawContent, pubKey: pubkey);
      });
      return SignedInvitationWrite(
        uid: client.converter.base64Encode(uid),
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

  CollectionCryptoManager getCryptoManager(
    Client client,
    AccountCryptoManager parentCm, {
    int? version,
  }) =>
      client.crypto.createCollectionCryptoManager(
        parentCm,
        _getCollectionKey(client, parentCm),
        version: version ?? CryptoService.currentVersion,
      );

  SecureKey _getCollectionKey(
    Client client,
    AccountCryptoManager parentCm,
  ) =>
      parentCm.decryptKey(
        _collectionKey,
        _collectionType,
        CryptoManager.keySize,
      );
}
