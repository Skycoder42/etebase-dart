import 'package:etebase/etebase.dart';
import 'package:msgpack_codec/msgpack_codec.dart';

import '../api/exceptions/cache_miss.dart';
import '../api/exceptions/collection_deleted.dart';
import '../api/models/conflict_origin.dart';
import '../api/repository_adapter.dart';
import 'etebase_sync_impl.dart';
import 'sync_cache_impl.dart';
import 'util/dispose_scope.dart';

class Repository<T extends Object> {
  final EtebaseSyncImpl _sync;
  final SyncCacheImpl _cache;

  final Collection _collection;
  final ItemManager _itemManager;
  final RepositoryAdapter<T> _adapter;

  Repository(
    this._sync,
    this._cache,
    this._collection,
    this._itemManager,
    this._adapter,
  );

  void dispose() {
    _itemManager.dispose();
    _collection.dispose();
  }

  Future<String> create(T value) => DisposeScope.scoped(() async {
    final meta = _updateMeta(null, value);
    final content = msgPack.encode(_adapter.toMsgPack(value));
    var item = DisposeScope.attach(await _itemManager.create(meta, content));
    item = await _saveItem(item);
    return item.uid;
  });

  Future<void> update(String uid, T value) => DisposeScope.scoped(() async {
    final item = await _loadItem(uid, fromCache: true);
    final oldMeta = await item.getMeta();
    final newMeta = _updateMeta(oldMeta, value);
    final content = msgPack.encode(_adapter.toMsgPack(value));
    await item.setMeta(newMeta);
    await item.setContent(content);
    await _saveItem(item);
  });

  ItemMetadata _updateMeta(ItemMetadata? meta, T value) {
    final baseMeta =
        _adapter.updateMeta(meta, value) ?? meta ?? const ItemMetadata();
    return baseMeta.copyWith(
      itemType: baseMeta.itemType ?? _collection.collectionType,
      mtime: DateTime.now(),
    );
  }

  Future<Item> _loadItem(String itemUid, {bool fromCache = false}) async {
    final cachedItem = DisposeScope.attach(
      await _cache.itemGet(_itemManager, _collection.uid, itemUid),
    );
    Item? item;
    if (fromCache) {
      item = cachedItem;
    } else {
      item = await _sync.runOnline<Item?>(() async {
        Item? remoteItem;

        // try update first
        if (cachedItem != null) {
          final update = await _itemManager.fetchUpdates([cachedItem]);
          if (update.data.isEmpty && update.isDone) {
            return cachedItem;
          } else if (update.data.length == 1 && update.isDone) {
            remoteItem = DisposeScope.attach(update.data.single);
          } else {
            update.data.forEach(DisposeScope.attach);
            // TODO log warning/error, but continue
          }
        }

        // otherwise try fetch
        if (remoteItem == null) {
          remoteItem = DisposeScope.attach(await _itemManager.fetch(itemUid));
          if (cachedItem case Item(
            etag: final String etag,
          ) when etag == remoteItem!.etag) {
            return cachedItem;
          }
        }

        // if updated, refresh cache
        try {
          await _cache.itemSet(_itemManager, _collection.uid, remoteItem!);
          return remoteItem;
        } on Conflict {
          return await _resolveConflict(
            local: cachedItem,
            remote: remoteItem!,
            origin: ConflictOrigin.cache,
          );
        }
      });
    }

    if (item == null) {
      throw CacheMiss('Item with uid "$itemUid"');
    } else if (item.isDeleted) {
      // TODO throw item deleted
      throw CollectionDeleted(itemUid);
    }

    return item;
  }

  Future<Item> _saveItem(Item item, {bool transaction = true}) async {
    await _cache.itemSet(
      _itemManager,
      _collection.uid,
      item,
      SetMode.preUpload,
    );

    return await _sync.runOnline(() async {
      try {
        if (transaction) {
          await _itemManager.transaction([item]);
        } else {
          await _itemManager.batch([item]);
        }
        await _cache.itemSet(
          _itemManager,
          _collection.uid,
          item,
          SetMode.postUpload,
        );
        return item;
      } on Conflict {
        final remote = DisposeScope.attach(await _itemManager.fetch(item.uid));

        return await _resolveConflict(
          local: item,
          remote: remote,
          origin: ConflictOrigin.server,
        );
      }
    }, whenOffline: () => item);
  }

  Future<Collection> _resolveConflict({
    required Item? local,
    required Item remote,
    required ConflictOrigin origin,
  }) => throw UnimplementedError();
}
