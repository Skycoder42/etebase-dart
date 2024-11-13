import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/models/etebase_item.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../encrypted_models/encrypted_collection_item.dart';
import 'client.dart';

@internal
class Item implements EtebaseItem {
  final Client _client;
  final CollectionItemCryptoManager _cm;
  final EncryptedCollectionItem encrypted;
  final String collectionUid;

  Item(
    this._client,
    this._cm,
    this.encrypted,
    this.collectionUid,
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
  Future<void> dispose() async => _cm.dispose();

  @override
  Future<bool> verify() => encrypted.verify(_client, _cm);

  @override
  Future<void> setMeta(EtebaseItemMetadata meta) =>
      encrypted.setMeta(_client, _cm, meta);

  @override
  Future<EtebaseItemMetadata> getMeta() => encrypted.getMeta(_client, _cm);

  @override
  Future<void> setContent(Uint8List content) =>
      encrypted.setContent(_client, _cm, content);

  @override
  Future<Uint8List> getContent() => encrypted.getContent(_client, _cm);

  @override
  Future<void> delete({bool preserveContent = false}) =>
      encrypted.delete(_client, _cm, preserveContent: preserveContent);
}
