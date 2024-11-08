import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/models/etebase_collection.dart';
import '../../api/models/etebase_collection_access_level.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../crypto/collection_crypto_manager.dart';
import '../encrypted_models/encrypted_collection.dart';

@internal
class Collection implements EtebaseCollection {
  final EncryptedCollection encryptedCollection;
  final CollectionCryptoManager collectionCryptoManager;

  @override
  Uint8List content;

  @override
  EtebaseItemMetadata meta;

  @override
  Uint8List metaRaw;

  Collection(this.encryptedCollection, this.collectionCryptoManager);

  @override
  // TODO: implement accessLevel
  EtebaseCollectionAccessLevel get accessLevel => throw UnimplementedError();

  @override
  EtebaseCollection clone() {
    // TODO: implement clone
    throw UnimplementedError();
  }

  @override
  // TODO: implement collectionType
  String get collectionType => throw UnimplementedError();

  @override
  void delete() {
    // TODO: implement delete
  }

  @override
  // TODO: implement etag
  String get etag => throw UnimplementedError();

  @override
  // TODO: implement isDeleted
  bool get isDeleted => throw UnimplementedError();

  @override
  // TODO: implement stoken
  String? get stoken => throw UnimplementedError();

  @override
  // TODO: implement uid
  String get uid => throw UnimplementedError();

  @override
  bool verify() {
    // TODO: implement verify
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() async {
    await collectionCryptoManager.dispose();
  }
}
