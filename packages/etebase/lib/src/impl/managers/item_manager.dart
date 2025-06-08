import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/exceptions/api_missuse.dart';
import '../../api/exceptions/conflict.dart';
import '../../api/managers/etebase_item_manager.dart';
import '../../api/models/etebase_item.dart';
import '../../api/models/fetch_options.dart';
import '../../api/models/item_metadata.dart';
import '../../api/models/list_response.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../crypto/minimal_collection_crypto_manager.dart';
import '../encrypted_models/chunk.dart';
import '../encrypted_models/encrypted_collection_item.dart';
import '../online_managers/collection_item_manager_online.dart';
import 'client.dart';
import 'item.dart';

@internal
class ItemManager implements EtebaseItemManager {
  @visibleForTesting
  final Client client;
  @visibleForTesting
  final MinimalCollectionCryptoManager cryptoManager;
  @visibleForTesting
  final CollectionItemManagerOnline online;
  @visibleForTesting
  final String colUid;

  ItemManager(this.client, this.cryptoManager, this.online, this.colUid);

  @override
  void dispose() {
    cryptoManager.dispose();
  }

  @override
  Future<Item> create<TMeta extends ItemMetadata>(
    TMeta meta,
    Uint8List content,
  ) async {
    final (encryptedItem, cm) = await client.createEncryptedCollectionItem(
      cryptoManager,
      meta,
      content,
    );
    return _createItem(encryptedItem, cm);
  }

  @override
  Future<Item> fetch(String itemUid, [ItemFetchOptions? fetchOptions]) async {
    final encryptedItem = await online.fetch(itemUid, fetchOptions);
    return _createItem(encryptedItem);
  }

  @override
  Future<ItemListResponse<Item>> list([ItemFetchOptions? fetchOptions]) async {
    final result = await online.list(fetchOptions);
    return result.map(_createItem);
  }

  @override
  Future<IteratorListResponse<Item>> itemRevisions(
    covariant Item item, [
    RevisionFetchOptions? fetchOptions,
  ]) async {
    final revisions = await online.itemRevisions(item.encrypted, fetchOptions);
    return revisions.map(_createItem);
  }

  @override
  Future<ItemListResponse<Item>> fetchUpdates(
    List<EtebaseItem> items, [
    ItemFetchOptions? fetchOptions,
  ]) async {
    final response = await online.fetchUpdates(
      _prepareForUpload(items.cast()),
      fetchOptions,
    );
    return response.map(_createItem);
  }

  @override
  Future<ItemListResponse<Item>> fetchMulti(
    List<String> items, [
    ItemFetchOptions? fetchOptions,
  ]) async {
    final result = await online.fetchMulti(items, fetchOptions);
    return result.map(_createItem);
  }

  @override
  Future<void> batch(
    List<EtebaseItem> items, {
    List<EtebaseItem>? deps,
    ItemFetchOptions? options,
  }) async {
    await online.batch(
      _prepareForUpload(items.cast()),
      deps != null ? _prepareForUpload(deps.cast()) : null,
      options,
    );
    for (final item in items.cast<Item>()) {
      item.encrypted.markSaved();
    }
  }

  @override
  Future<void> transaction(
    List<EtebaseItem> items, {
    List<EtebaseItem>? deps,
    ItemFetchOptions? options,
  }) async {
    await online.transaction(
      _prepareForUpload(items.cast()),
      deps != null ? _prepareForUpload(deps.cast()) : null,
      options,
    );
    for (final item in items.cast<Item>()) {
      item.encrypted.markSaved();
    }
  }

  @override
  Future<void> uploadContent(
    covariant Item item, {
    ContentProgressCallback? onProgress,
  }) async {
    final [encrypted] = _prepareForUpload([item]);
    final chunks = encrypted.pendingChunks.toList();

    var current = 0;
    onProgress?.call(current, chunks.length);
    for (final chunk in chunks) {
      await _uploadIgnoringConflicts(encrypted, chunk);
      onProgress?.call(++current, chunks.length);
    }
  }

  @override
  Future<void> downloadContent(
    covariant Item item, {
    ContentProgressCallback? onProgress,
  }) async {
    final [encrypted] = _prepareForUpload([item]);
    final chunks = encrypted.missingChunks.toList();

    var current = 0;
    onProgress?.call(current, chunks.length);
    for (final chunk in chunks) {
      await _download(encrypted, chunk);
      onProgress?.call(++current, chunks.length);
    }
  }

  @override
  Uint8List cacheSave(covariant Item item, {bool saveContent = true}) =>
      item.encrypted.cacheSave(client, saveContent: saveContent);

  @override
  Item cacheLoad(Uint8List cached) =>
      _createItem(client.cacheLoadEncryptedCollectionItem(cached));

  @override
  Stream<ItemListResponse<Item>> subscribeChanges([
    ItemFetchOptions? options,
  ]) => online
      .subscribeChanges(options)
      // ignore: discarded_futures
      .asyncMap((res) => res.map(_createItem));

  Item _createItem(
    EncryptedCollectionItem encrypted, [
    CollectionItemCryptoManager? cm,
  ]) => Item(
    client,
    cm ?? encrypted.getCryptoManager(client, cryptoManager),
    encrypted,
    colUid,
  );

  List<EncryptedCollectionItem> _prepareForUpload(Iterable<Item> items) => [
    for (final item in items)
      if (item.colUid != colUid)
        throw ApiMissuse(
          'Uploading an item belonging to collection ${item.colUid} '
          'to another collection ($colUid) is not allowed!',
        )
      else
        item.encrypted,
  ];

  Future<void> _uploadIgnoringConflicts(
    EncryptedCollectionItem item,
    Chunk chunk,
  ) async {
    try {
      await online.chunkUpload(item, chunk, null);
    } on Conflict {
      // ignore
    }
  }

  Future<void> _download(EncryptedCollectionItem item, Chunk chunk) async {
    final data = await online.chunkDownload(item, chunk.uid, null);
    item.updateChunk(chunk.copyWith(data: data));
  }
}
