import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/models/etebase_collection_access_level.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../crypto/account_crypto_manager.dart';
import '../crypto/crypto_manager.dart';
import '../managers/client.dart';
import 'encrypted_collection_item.dart';

@internal
class EncryptedCollection {
  final Uint8List _collectionKey;
  final Uint8List _collectionType;
  final EncryptedCollectionItem _item;
  final EtebaseCollectionAccessLevel _accessLevel;
  final String? _stoken;

  EncryptedCollection(
    this._collectionKey,
    this._collectionType,
    this._item,
    this._accessLevel,
    this._stoken,
  );

  static Future<EncryptedCollection> create<TItem>(
    Client client,
    AccountCryptoManager parentCryptoManager,
    String collectionTypeName,
    EtebaseItemMetadata itemMetadata,
    Uint8List content,
  ) async {
    final collectionType =
        await parentCryptoManager.colTypeToUid(collectionTypeName);

    final collectionKey = client.crypto.secureRandom(CryptoManager.keySize);
    final collectionCm = parentCryptoManager.createCollectionCryptoManager(
      collectionKey,
    );

    return EncryptedCollection(
      await parentCryptoManager.encrypt(
        collectionKey.extractBytes(),
        collectionType,
      ),
      collectionType,
      _item,
      EtebaseCollectionAccessLevel.admin,
      null,
    );
  }
}
