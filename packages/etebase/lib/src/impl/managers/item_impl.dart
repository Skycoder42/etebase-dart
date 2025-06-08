import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/models/item.dart';
import '../../api/models/item_metadata.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../encrypted_models/encrypted_collection_item.dart';
import 'client.dart';

@internal
class ItemImpl implements Item {
  final Client _client;
  final CollectionItemCryptoManager _cm;
  final EncryptedCollectionItem encrypted;
  final String colUid;

  ItemImpl(this._client, this._cm, this.encrypted, this.colUid);

  @override
  String get uid => encrypted.uid;

  @override
  String get etag => encrypted.etag;

  @override
  bool get isDeleted => encrypted.isDeleted;

  @override
  bool get isMissingContent => encrypted.isMissingContent;

  @override
  void dispose() => _cm.dispose();

  @override
  Future<void> verify() => encrypted.verify(_client, _cm);

  @override
  Future<void> setMeta<TMeta extends ItemMetadata>(TMeta meta) =>
      encrypted.setMeta(_client, _cm, meta);

  @override
  Future<TMeta> getMeta<TMeta extends ItemMetadata>() =>
      encrypted.getMeta<TMeta>(_client, _cm);

  @override
  Future<void> setContent(Uint8List content) =>
      encrypted.setContent(_client, _cm, content);

  @override
  Future<void> setContentStream(Stream<List<int>> content) =>
      encrypted.setContentStream(_client, _cm, content);

  @override
  Future<Uint8List> getContent() => encrypted.getContent(_client, _cm);

  @override
  Stream<Uint8List> getContentStream() =>
      encrypted.getContentStream(_client, _cm);

  @override
  Future<void> delete({bool preserveContent = false}) =>
      encrypted.delete(_client, _cm, preserveContent: preserveContent);
}
