import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/managers/etebase_collection_manager.dart';
import '../../api/models/fetch_options.dart';
import '../../api/models/item_metadata.dart';
import '../../api/models/list_response.dart';
import '../crypto/account_crypto_manager.dart';
import '../online_managers/collection_item_manager_online.dart';
import '../online_managers/collection_manager_online.dart';
import '../online_managers/collection_member_manager_online.dart';
import 'client.dart';
import 'collection_impl.dart';
import 'collection_member_manager.dart';
import 'item_manager.dart';

@internal
class CollectionManager implements EtebaseCollectionManager {
  final Client _client;
  final AccountCryptoManager _cryptoManager;
  final CollectionManagerOnline _online;

  CollectionManager(this._client, this._cryptoManager, this._online);

  @override
  Future<CollectionImpl> create<TMeta extends ItemMetadata>(
    String collectionType,
    TMeta meta,
    Uint8List content,
  ) async {
    final (encryptedCollection, cm) = await _client.createEncryptedCollection(
      _cryptoManager,
      collectionType,
      meta,
      content,
    );
    return CollectionImpl(_client, cm, encryptedCollection);
  }

  @override
  Future<CollectionImpl> fetch(
    String colUid, [
    FetchOptions? fetchOptions,
  ]) async {
    final encryptedCollection = await _online.fetch(colUid, fetchOptions);
    return CollectionImpl(
      _client,
      encryptedCollection.getCryptoManager(_client, _cryptoManager),
      encryptedCollection,
    );
  }

  @override
  Future<CollectionListResponse<CollectionImpl>> list(
    String collectionType, [
    FetchOptions? fetchOptions,
  ]) => listMulti([collectionType], fetchOptions);

  @override
  Future<CollectionListResponse<CollectionImpl>> listMulti(
    List<String> collectionTypes, [
    FetchOptions? fetchOptions,
  ]) async {
    final colTypes = [
      for (final collectionType in collectionTypes)
        _cryptoManager.colTypeToUid(collectionType),
    ];
    final result = await _online.list(colTypes, fetchOptions);
    return result.map(
      (encrypted) => CollectionImpl(
        _client,
        encrypted.getCryptoManager(_client, _cryptoManager),
        encrypted,
      ),
    );
  }

  @override
  Future<void> upload(
    covariant CollectionImpl collection, [
    FetchOptions? fetchOptions,
  ]) async {
    final col = collection.encrypted;
    if (col.lastEtag != null) {
      await _online
          .itemManager(col.uid)
          .batch([col.item], null, fetchOptions?.asItemOptions());
    } else {
      await _online.create(col, fetchOptions);
    }
    col.markSaved();
  }

  @override
  Future<void> transaction(
    covariant CollectionImpl collection, [
    FetchOptions? fetchOptions,
  ]) async {
    final col = collection.encrypted;
    if (col.lastEtag != null) {
      await _online
          .itemManager(col.uid)
          .transaction([col.item], null, fetchOptions?.asItemOptions());
    } else {
      await _online.create(col, fetchOptions);
    }
    col.markSaved();
  }

  @override
  Uint8List cacheSave(
    covariant CollectionImpl collection, {
    bool saveContent = true,
  }) => collection.encrypted.cacheSave(_client, saveContent: saveContent);

  @override
  CollectionImpl cacheLoad(Uint8List cached) {
    final encryptedCollection = _client.cacheLoadEncryptedCollection(cached);
    return CollectionImpl(
      _client,
      encryptedCollection.getCryptoManager(_client, _cryptoManager),
      encryptedCollection,
    );
  }

  @override
  ItemManager getItemManager(covariant CollectionImpl col) => ItemManager(
    _client,
    col.encrypted.getCryptoManager(_client, _cryptoManager),
    CollectionItemManagerOnline(
      client: _client,
      authTokenSource: _online.authTokenSource,
      colUid: col.uid,
    ),
    col.uid,
  );

  @override
  CollectionMemberManager getMemberManager(covariant CollectionImpl col) =>
      CollectionMemberManager(
        CollectionMemberManagerOnline(
          client: _client,
          authTokenSource: _online.authTokenSource,
          colUid: col.uid,
        ),
      );
}
