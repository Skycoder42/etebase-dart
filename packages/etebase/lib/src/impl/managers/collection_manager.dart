import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/managers/etebase_collection_manager.dart';
import '../../api/managers/etebase_collection_member_manager.dart';
import '../../api/managers/etebase_item_manager.dart';
import '../../api/models/base/etebase_collection_list_response.dart';
import '../../api/models/etebase_collection.dart';
import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../crypto/account_crypto_manager.dart';
import '../encrypted_models/encrypted_collection.dart';
import '../online_managers/base_manager.dart';
import '../online_managers/collection_manager_online.dart';
import 'client.dart';
import 'collection.dart';

@internal
class CollectionManager implements EtebaseCollectionManager {
  final Client _client;
  final AccountCryptoManager _cryptoManager;
  final CollectionManagerOnline _online;

  CollectionManager(
    this._client,
    AuthTokenSource authTokenSource,
    this._cryptoManager,
  ) : _online = CollectionManagerOnline(
          client: _client,
          authTokenSource: authTokenSource,
        );

  @override
  Future<Collection> create(
    String collectionType,
    // TODO allow custom metadata objects
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
    final encryptedCollection = await _online.fetch(colUid, fetchOptions);
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
    final result = await _online.list(colTypes, fetchOptions);
    return result.mapAsync(
      (c) async => Collection(
        c,
        await c.getCryptoManager(_client, _cryptoManager),
      ),
    );
  }

  @override
  Future<void> upload(
    covariant Collection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]) async {
    final col = collection.encryptedCollection;
    if (col.lastEtag != null) {
      await _online.itemManager(col.uid).batch([col.item], null, fetchOptions);
    } else {
      await _online.create(col, fetchOptions);
    }
    col.markSaved();
  }

  @override
  Future<void> transaction(
    covariant Collection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]) async {
    final col = collection.encryptedCollection;
    if (col.lastEtag != null) {
      // TODO item transaction
    } else {
      await _online.create(col, fetchOptions);
    }
    col.markSaved();
  }

  @override
  Uint8List cacheSave(
    covariant Collection collection, {
    bool saveContent = false,
  }) =>
      collection.encryptedCollection
          .cacheSave(_client, saveContent: saveContent);

  @override
  Future<EtebaseCollection> cacheLoad(Uint8List cached) async {
    final encryptedCollection = EncryptedCollection.cacheLoad(_client, cached);
    return Collection(
      encryptedCollection,
      await encryptedCollection.getCryptoManager(_client, _cryptoManager),
    );
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
}
