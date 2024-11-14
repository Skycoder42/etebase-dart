import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/exceptions/api_missuse.dart';
import '../../api/exceptions/conflict.dart';
import '../../api/managers/etebase_item_manager.dart';
import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../crypto/minimal_collection_crypto_manager.dart';
import '../encrypted_models/chunk.dart';
import '../encrypted_models/encrypted_collection_item.dart';
import '../models/collection_item_list_response.dart';
import '../models/iterator_list_response.dart';
import '../online_managers/collection_item_manager_online.dart';
import 'client.dart';
import 'item.dart';

@internal
class ItemManager implements EtebaseItemManager {
  final Client _client;
  final MinimalCollectionCryptoManager _cryptoManager;
  final CollectionItemManagerOnline _online;
  final String _colUid;

  ItemManager(this._client, this._cryptoManager, this._online, this._colUid);

  @override
  Future<void> dispose() async {
    await _cryptoManager.dispose();
  }

  @override
  Future<Item> create<TMeta extends EtebaseItemMetadata>(
    TMeta meta,
    Uint8List content,
  ) async {
    final (encryptedItem, cm) = await EncryptedCollectionItem.create(
      _client,
      _cryptoManager,
      meta,
      content,
    );
    return _createItem(encryptedItem, cm);
  }

  @override
  Future<Item> fetch(
    String itemUid, [
    EtebaseItemFetchOptions? fetchOptions,
  ]) async {
    final encryptedItem = await _online.fetch(itemUid, fetchOptions);
    return _createItem(encryptedItem);
  }

  @override
  Future<CollectionItemListResponse<Item>> list([
    EtebaseItemFetchOptions? fetchOptions,
  ]) async {
    final result = await _online.list(fetchOptions);
    return result.mapAsync(_createItem);
  }

  @override
  Future<IteratorListResponse<Item>> itemRevisions(
    covariant Item item, [
    EtebaseRevisionFetchOptions? fetchOptions,
  ]) async {
    final revisions = await _online.itemRevisions(item.encrypted, fetchOptions);
    return revisions.mapAsync(_createItem);
  }

  @override
  Future<CollectionItemListResponse<Item>> fetchUpdates(
    covariant List<Item> items, [
    EtebaseItemFetchOptions? fetchOptions,
  ]) async {
    final response = await _online.fetchUpdates(
      _prepareForUpload(items),
      fetchOptions,
    );
    return response.mapAsync(_createItem);
  }

  @override
  Future<CollectionItemListResponse<Item>> fetchMulti(
    List<String> items, [
    EtebaseItemFetchOptions? fetchOptions,
  ]) async {
    final result = await _online.fetchMulti(items, fetchOptions);
    return result.mapAsync(_createItem);
  }

  @override
  Future<void> batch(
    covariant List<Item> items, {
    covariant List<Item>? deps,
    EtebaseItemFetchOptions? options,
  }) async {
    await _online.batch(
      _prepareForUpload(items),
      deps != null ? _prepareForUpload(deps) : null,
      options,
    );
    for (final item in items) {
      item.encrypted.markSaved();
    }
  }

  @override
  Future<void> transaction(
    covariant List<Item> items, {
    covariant List<Item>? deps,
    EtebaseItemFetchOptions? options,
  }) async {
    await _online.transaction(
      _prepareForUpload(items),
      deps != null ? _prepareForUpload(deps) : null,
      options,
    );
    for (final item in items) {
      item.encrypted.markSaved();
    }
  }

  @override
  Future<void> uploadContent(covariant Item item) async {
    final [encrypted] = _prepareForUpload([item]);
    await Future.wait([
      for (final chunk in encrypted.pendingChunks)
        _uploadIgnoringConflicts(encrypted, chunk),
    ]);
  }

  @override
  Future<void> downloadContent(covariant Item item) async {
    final [encrypted] = _prepareForUpload([item]);
    await Future.wait([
      for (final chunk in encrypted.missingChunks) _download(encrypted, chunk),
    ]);
  }

  @override
  Stream<CollectionItemListResponse<Item>> subscribeChanges([
    EtebaseItemFetchOptions? options,
  ]) =>
      _online
          .subscribeChanges(options)
          // ignore: discarded_futures
          .asyncMap((res) => res.mapAsync(_createItem));

  @override
  Uint8List cacheSave(covariant Item item, {bool saveContent = true}) =>
      item.encrypted.cacheSave(_client, saveContent: saveContent);

  @override
  Future<Item> cacheLoad(Uint8List cached) =>
      _createItem(EncryptedCollectionItem.cacheLoad(_client, cached));

  Future<Item> _createItem(
    EncryptedCollectionItem encrypted, [
    CollectionItemCryptoManager? cm,
  ]) async =>
      Item(
        _client,
        cm ?? await encrypted.getCryptoManager(_client, _cryptoManager),
        encrypted,
        _colUid,
      );

  List<EncryptedCollectionItem> _prepareForUpload(Iterable<Item> items) => [
        for (final item in items)
          if (item.colUid != _colUid)
            throw ApiMissuse(
              'Uploading an item belonging to collection ${item.colUid} '
              'to another collection ($_colUid) is not allowed!',
            )
          else
            item.encrypted,
      ];

  Future<void> _uploadIgnoringConflicts(
    EncryptedCollectionItem item,
    Chunk chunk,
  ) async {
    try {
      await _online.chunkUpload(item, chunk, null);
    } on Conflict {
      // ignore
    }
  }

  Future<void> _download(
    EncryptedCollectionItem item,
    Chunk chunk,
  ) async {
    final data = await _online.chunkDownload(item, chunk.uid, null);
    item.updateChunk(chunk.copyWith(data: data));
  }
}
