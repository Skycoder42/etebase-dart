import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/managers/etebase_collection_manager.dart';
import '../../api/models/etebase_collection.dart';
import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../../api/models/etebase_list_response.dart';
import '../crypto/account_crypto_manager.dart';
import '../encrypted_models/encrypted_collection.dart';
import '../online_managers/collection_item_manager_online.dart';
import '../online_managers/collection_manager_online.dart';
import '../online_managers/collection_member_manager_online.dart';
import 'client.dart';
import 'collection.dart';
import 'collection_member_manager.dart';
import 'item_manager.dart';

@internal
class CollectionManager implements EtebaseCollectionManager {
  final Client _client;
  final AccountCryptoManager _cryptoManager;
  final CollectionManagerOnline _online;

  CollectionManager(
    this._client,
    this._cryptoManager,
    this._online,
  );

  @override
  Future<Collection> create<TMeta extends EtebaseItemMetadata>(
    String collectionType,
    TMeta meta,
    Uint8List content,
  ) async {
    final (encryptedCollection, cm) = await EncryptedCollection.create(
      _client,
      _cryptoManager,
      collectionType,
      meta,
      content,
    );
    return Collection(_client, cm, encryptedCollection);
  }

  @override
  Future<EtebaseCollection> fetch(
    String colUid, [
    EtebaseFetchOptions? fetchOptions,
  ]) async {
    final encryptedCollection = await _online.fetch(colUid, fetchOptions);
    return Collection(
      _client,
      encryptedCollection.getCryptoManager(_client, _cryptoManager),
      encryptedCollection,
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
        _cryptoManager.colTypeToUid(collectionType),
    ];
    final result = await _online.list(colTypes, fetchOptions);
    return result.map(
      (encrypted) => Collection(
        _client,
        encrypted.getCryptoManager(_client, _cryptoManager),
        encrypted,
      ),
    );
  }

  @override
  Future<void> upload(
    covariant Collection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]) async {
    final col = collection.encrypted;
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
    final col = collection.encrypted;
    if (col.lastEtag != null) {
      await _online
          .itemManager(col.uid)
          .transaction([col.item], null, fetchOptions);
    } else {
      await _online.create(col, fetchOptions);
    }
    col.markSaved();
  }

  @override
  Uint8List cacheSave(
    covariant Collection collection, {
    bool saveContent = true,
  }) =>
      collection.encrypted.cacheSave(_client, saveContent: saveContent);

  @override
  EtebaseCollection cacheLoad(Uint8List cached) {
    final encryptedCollection = EncryptedCollection.cacheLoad(_client, cached);
    return Collection(
      _client,
      encryptedCollection.getCryptoManager(_client, _cryptoManager),
      encryptedCollection,
    );
  }

  @override
  ItemManager getItemManager(covariant Collection col) => ItemManager(
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
  CollectionMemberManager getMemberManager(covariant Collection col) =>
      CollectionMemberManager(
        CollectionMemberManagerOnline(
          client: _client,
          authTokenSource: _online.authTokenSource,
          colUid: col.uid,
        ),
      );
}
