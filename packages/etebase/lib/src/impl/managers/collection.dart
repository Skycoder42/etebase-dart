import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/models/etebase_collection.dart';
import '../../api/models/etebase_collection_access_level.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../crypto/collection_crypto_manager.dart';
import '../encrypted_models/encrypted_collection.dart';
import 'client.dart';

@internal
class Collection implements EtebaseCollection {
  final Client _client;
  final CollectionCryptoManager _cm;
  final EncryptedCollection encrypted;

  Collection(
    this._client,
    this._cm,
    this.encrypted,
  );

  @override
  String get uid => encrypted.uid;

  @override
  String get etag => encrypted.etag;

  @override
  bool get isDeleted => encrypted.isDeleted;

  @override
  bool get isMissingContent => encrypted.isMissingContent;

  @override
  String? get stoken => encrypted.stoken;

  @override
  String get collectionType =>
      encrypted.getCollectionType(_client, _cm.accountCryptoManager);

  @override
  EtebaseCollectionAccessLevel get accessLevel => encrypted.accessLevel;

  @override
  Future<void> dispose() async => _cm.dispose();

  @override
  Future<bool> verify() => encrypted.verify(_client, _cm);

  @override
  Future<void> setMeta<TMeta extends EtebaseItemMetadata>(TMeta meta) =>
      encrypted.setMeta(_client, _cm, meta);

  @override
  Future<TMeta> getMeta<TMeta extends EtebaseItemMetadata>() =>
      encrypted.getMeta<TMeta>(_client, _cm);

  @override
  Future<void> setContent(Uint8List content) =>
      encrypted.setContent(_client, _cm, content);

  @override
  Future<Uint8List> getContent() => encrypted.getContent(_client, _cm);

  @override
  Future<void> delete({bool preserveContent = false}) =>
      encrypted.delete(_client, _cm, preserveContent: preserveContent);
}
