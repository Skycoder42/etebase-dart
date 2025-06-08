import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/exceptions/api_missuse.dart';
import '../../api/exceptions/conflict.dart';
import '../../api/managers/item_manager.dart';
import '../../api/models/fetch_options.dart';
import '../../api/models/item.dart';
import '../../api/models/item_metadata.dart';
import '../../api/models/list_response.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../crypto/minimal_collection_crypto_manager.dart';
import '../encrypted_models/chunk.dart';
import '../encrypted_models/encrypted_collection_item.dart';
import '../online_managers/collection_item_manager_online.dart';
import 'client_impl.dart';
import 'item_impl.dart';

@internal
class ItemManagerImpl implements ItemManager {
  @visibleForTesting
  final ClientImpl client;
  @visibleForTesting
  final MinimalCollectionCryptoManager cryptoManager;
  @visibleForTesting
  final CollectionItemManagerOnline online;
  @visibleForTesting
  final String colUid;

  ItemManagerImpl(this.client, this.cryptoManager, this.online, this.colUid);

  @override
  void dispose() {
    cryptoManager.dispose();
  }

  @override
  Future<ItemImpl> create<TMeta extends ItemMetadata>(
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
  Future<ItemImpl> fetch(
    String itemUid, [
    ItemFetchOptions? fetchOptions,
  ]) async {
    final encryptedItem = await online.fetch(itemUid, fetchOptions);
    return _createItem(encryptedItem);
  }

  @override
  Future<ItemListResponse<ItemImpl>> list([
    ItemFetchOptions? fetchOptions,
  ]) async {
    final result = await online.list(fetchOptions);
    return result.map(_createItem);
  }

  @override
  Future<IteratorListResponse<ItemImpl>> itemRevisions(
    covariant ItemImpl item, [
    RevisionFetchOptions? fetchOptions,
  ]) async {
    final revisions = await online.itemRevisions(item.encrypted, fetchOptions);
    return revisions.map(_createItem);
  }

  @override
  Future<ItemListResponse<ItemImpl>> fetchUpdates(
    List<Item> items, [
    ItemFetchOptions? fetchOptions,
  ]) async {
    final response = await online.fetchUpdates(
      _prepareForUpload(items.cast()),
      fetchOptions,
    );
    return response.map(_createItem);
  }

  @override
  Future<ItemListResponse<ItemImpl>> fetchMulti(
    List<String> items, [
    ItemFetchOptions? fetchOptions,
  ]) async {
    final result = await online.fetchMulti(items, fetchOptions);
    return result.map(_createItem);
  }

  @override
  Future<void> batch(
    List<Item> items, {
    List<Item>? deps,
    ItemFetchOptions? options,
  }) async {
    await online.batch(
      _prepareForUpload(items.cast()),
      deps != null ? _prepareForUpload(deps.cast()) : null,
      options,
    );
    for (final item in items.cast<ItemImpl>()) {
      item.encrypted.markSaved();
    }
  }

  @override
  Future<void> transaction(
    List<Item> items, {
    List<Item>? deps,
    ItemFetchOptions? options,
  }) async {
    await online.transaction(
      _prepareForUpload(items.cast()),
      deps != null ? _prepareForUpload(deps.cast()) : null,
      options,
    );
    for (final item in items.cast<ItemImpl>()) {
      item.encrypted.markSaved();
    }
  }

  @override
  Future<void> uploadContent(
    covariant ItemImpl item, {
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
    covariant ItemImpl item, {
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
  Uint8List cacheSave(covariant ItemImpl item, {bool saveContent = true}) =>
      item.encrypted.cacheSave(client, saveContent: saveContent);

  @override
  ItemImpl cacheLoad(Uint8List cached) =>
      _createItem(client.cacheLoadEncryptedCollectionItem(cached));

  @override
  Stream<ItemListResponse<ItemImpl>> subscribeChanges([
    ItemFetchOptions? options,
  ]) => online
      .subscribeChanges(options)
      // ignore: discarded_futures
      .asyncMap((res) => res.map(_createItem));

  ItemImpl _createItem(
    EncryptedCollectionItem encrypted, [
    CollectionItemCryptoManager? cm,
  ]) => ItemImpl(
    client,
    cm ?? encrypted.getCryptoManager(client, cryptoManager),
    encrypted,
    colUid,
  );

  List<EncryptedCollectionItem> _prepareForUpload(Iterable<ItemImpl> items) => [
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
