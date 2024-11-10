import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/managers/etebase_collection_manager.dart';
import '../../api/managers/etebase_collection_member_manager.dart';
import '../../api/managers/etebase_item_manager.dart';
import '../../api/models/etebase_collection.dart';
import '../../api/models/etebase_collection_list_response.dart';
import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../crypto/account_crypto_manager.dart';
import '../encrypted_models/encrypted_collection.dart';
import 'client.dart';
import 'collection.dart';

@internal
class CollectionManager implements EtebaseCollectionManager {
  final Client _client;
  final AccountCryptoManager _cryptoManager;

  CollectionManager(this._client, this._cryptoManager);

  @override
  Future<Collection> create(
    String collectionType,
    EtebaseItemMetadata meta,
    Uint8List content,
  ) async {
    final (encryptedCollection, cm) = await EncryptedCollection.create(
      _client,
      _cryptoManager,
      collectionType,
      meta,
      content,
    );
    return Collection(encryptedCollection, cm);
  }

  @override
  Future<EtebaseCollection> fetch(
    String colUid, [
    EtebaseFetchOptions? fetchOptions,
  ]) async {
    final encryptedCollection =
        await _client.api.collection.fetch(colUid, fetchOptions);
    return Collection(
      encryptedCollection,
      await encryptedCollection.getCryptoManager(_client, _cryptoManager),
    );
  }

  @override
  Future<EtebaseCollectionListResponse<EtebaseCollection>> list(
    String collectionType, [
    EtebaseFetchOptions? fetchOptions,
  ]) =>
      listMulti([collectionType], fetchOptions);

  @override
  Future<EtebaseCollectionListResponse<EtebaseCollection>> listMulti(
    List<String> collectionTypes, [
    EtebaseFetchOptions? fetchOptions,
  ]) async {
    final colTypes = [
      for (final collectionType in collectionTypes)
        await _cryptoManager.colTypeToUid(collectionType),
    ];
    final result = await _client.api.collection.list(colTypes, fetchOptions);
    return result.mapAsync(
      (c) async => Collection(
        c,
        await c.getCryptoManager(_client, _cryptoManager),
      ),
    );
  }

  @override
  Future<EtebaseCollection> cacheLoad(Uint8List cached) async {
    final encryptedCollection = EncryptedCollection.cacheLoad(_client, cached);
    return Collection(
      encryptedCollection,
      await encryptedCollection.getCryptoManager(_client, _cryptoManager),
    );
  }

  @override
  Uint8List cacheSave(covariant Collection collection) =>
      collection.encryptedCollection.cacheSave(_client, saveContent: false);

  @override
  Uint8List cacheSaveWithContent(EtebaseCollection collection) {
    // TODO: implement cacheSaveWithContent
    throw UnimplementedError();
  }

  @override
  EtebaseCollection createRaw(
    String collectionType,
    Uint8List meta,
    Uint8List content,
  ) {
    // TODO: implement createRaw
    throw UnimplementedError();
  }

  @override
  EtebaseItemManager getItemManager(EtebaseCollection col) {
    // TODO: implement getItemManager
    throw UnimplementedError();
  }

  @override
  EtebaseCollectionMemberManager getMemberManager(EtebaseCollection col) {
    // TODO: implement getMemberManager
    throw UnimplementedError();
  }

  @override
  Future<void> transaction(
    EtebaseCollection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]) {
    // TODO: implement transaction
    throw UnimplementedError();
  }

  @override
  Future<void> upload(
    EtebaseCollection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]) {
    // TODO: implement upload
    throw UnimplementedError();
  }
}
