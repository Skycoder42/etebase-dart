import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:msgpack_codec/msgpack_codec.dart';
import 'package:rxdart/rxdart.dart';

import '../api/conflict_resolution/conflict_resolver.dart';
import '../api/exceptions/already_subscribed.dart';
import '../api/exceptions/device_offline.dart';
import '../api/exceptions/item_deleted.dart';
import '../api/exceptions/read_only.dart';
import '../api/models/conflict_origin.dart';
import '../api/models/conflict_resolution.dart';
import '../api/models/value_or_deleted.dart';
import '../api/repository_adapter.dart';
import 'caching/cache_view.dart';
import 'etebase_sync_impl.dart';
import 'sync_engine.dart';
import 'util/dispose_scope.dart';

class RepositoryImpl<T extends Object>
    implements SyncTarget<Item, ItemMetadata, ItemFetchOptions> {
  final EtebaseSyncImpl _sync;
  final ConflictResolver _conflictResolver;
  final SyncEngine _syncEngine;
  final CacheView<Item> _cache;

  final Collection _collection;
  final ItemManager _itemManager;
  final RepositoryAdapter<T> _adapter;

  bool _syncActive = false;

  RepositoryImpl(
    this._sync,
    this._conflictResolver,
    this._syncEngine,
    this._cache,
    this._collection,
    this._itemManager,
    this._adapter,
  );

  void dispose() {
    _itemManager.dispose();
    _collection.dispose();
  }

  Stream<String> listUids() => DisposeScope.scopedStream(() async* {
    await _updateCache();
    yield* Stream.fromIterable(_cache.listItems());
  });

  Future<Map<String, ItemMetadata>> listMeta() => DisposeScope.scoped(() async {
    await _updateCache();
    final result = <String, ItemMetadata>{};
    for (final uid in _cache.listItems()) {
      final item = await _syncEngine.loadIfExists(_cache, uid, fromCache: true);
      if (item == null) {
        continue;
      }
      final meta = await item.getMeta();
      result[uid] = meta;
    }
    return result;
  });

  Stream<T> listValues() => DisposeScope.scopedStream(() async* {
    await _updateCache();
    for (final uid in _cache.listItems()) {
      final item = await _syncEngine.loadIfExists(_cache, uid, fromCache: true);
      if (item == null) {
        continue;
      }
      yield await _getContent(item);
    }
  });

  Future<String> create(T value) => DisposeScope.scoped(() async {
    _checkWritable();
    final meta = _updateMeta(null, value);
    final content = msgPack.encode(_adapter.toMsgPack(value));
    var item = DisposeScope.attach(await _itemManager.create(meta, content));
    item = await _syncEngine.save(_cache, item);
    return item.uid;
  });

  Future<T?> get(String uid) => DisposeScope.scoped(() async {
    final item = await _syncEngine.loadIfExists(
      _cache,
      uid,
      fromCache: _syncActive,
    );
    if (item == null) {
      return null;
    }
    return await _getContent(item);
  });

  Future<ItemMetadata?> getMeta(String uid) => DisposeScope.scoped(() async {
    final item = await _syncEngine.loadIfExists(
      _cache,
      uid,
      fromCache: _syncActive,
    );
    if (item == null) {
      return null;
    }
    return await item.getMeta();
  });

  Future<void> update(String uid, T value) => DisposeScope.scoped(() async {
    _checkWritable();
    final item = await _syncEngine.load(_cache, uid, fromCache: true);
    await _setContent(item, value);
    await _updateItemMeta(item, value);
    await _syncEngine.save(_cache, item);
  });

  Future<void> delete(String uid) => DisposeScope.scoped(() async {
    _checkWritable();
    final item = await _syncEngine.loadIfExists(_cache, uid, fromCache: true);
    if (item == null) {
      return;
    }
    await item.delete();
    await _updateItemMeta(item, null);
    await _syncEngine.save(_cache, item);
  });

  Stream<String> subscribeChanges() {
    if (_syncActive) {
      throw AlreadySubscribed();
    }

    return _sync.streamOnline(
      () {
        final stoken = _cache.getStoken();
        _syncActive = true;
        return _itemManager
            .subscribeChanges(
              ItemFetchOptions(withCollection: false, stoken: stoken),
            )
            .doOnDone(() => _syncActive = false)
            .doOnCancel(() => _syncActive = false)
            .asyncMap(_processFrame)
            .expand((uids) => uids);
      },
      whenOffline: () => Stream.error(
        DeviceOffline('Subscribing to changes'),
        StackTrace.current,
      ),
    );
  }

  @override
  ItemFetchOptions internalCreateFetchOptions(String? stoken) =>
      ItemFetchOptions(stoken: stoken, withCollection: false);

  @override
  Future<ListResponse<Item>> internalList(
    String _,
    ItemFetchOptions options,
  ) async => await _itemManager.list(options);

  @override
  Future<Item> internalFetch(String uid, [Item? instance]) async {
    // when fetching from an instance, try to fetch the updates first
    // this might speed up things, as the response may return "no updates"
    if (instance != null) {
      final update = await _itemManager.fetchUpdates([instance]);
      if (update.data.isEmpty && update.isDone) {
        return instance;
      } else if (update.data.length == 1 && update.isDone) {
        return update.data.single;
      } else {
        update.data.forEach(DisposeScope.attach);
        // TODO log warning/error, but continue
      }
    }

    return await _itemManager.fetch(uid);
  }

  @override
  Future<void> internalUpload(Item instance, {bool transaction = true}) async {
    if (transaction) {
      await _itemManager.transaction([instance]);
    } else {
      await _itemManager.batch([instance]);
    }
  }

  @override
  FutureOr<ConflictResolution<Item>> internalResolveConflict({
    required String uid,
    required Item local,
    required Item remote,
    required ConflictOrigin origin,
  }) async {
    final resolution = await _conflictResolver.resolveItemConflict(
      itemUid: uid,
      local: await _getVoD(local),
      remote: await _getVoD(remote),
      origin: origin,
    );

    return resolution.map(
      local: (value) async => await _setVoD(local, value),
      remote: (value) async => await _setVoD(remote, value),
    );
  }

  @override
  Future<void> internalValidate(Item instance, String container) async {
    if (instance.isMissingContent) {
      await _itemManager.downloadContent(instance);
    }
  }

  void _checkWritable() {
    if (_collection.accessLevel == CollectionAccessLevel.readOnly) {
      throw ReadOnly(_collection.uid, _collection.accessLevel);
    }
  }

  Future<void> _updateCache() async {
    if (_syncActive) {
      return;
    }

    await _syncEngine.updateCache(_cache);
  }

  ItemMetadata _updateMeta(ItemMetadata? meta, T? value) {
    final baseMeta =
        _adapter.updateMeta(meta, value) ?? meta ?? const ItemMetadata();
    return baseMeta.copyWith(
      itemType: baseMeta.itemType ?? _collection.collectionType,
      mtime: DateTime.now(),
    );
  }

  Future<void> _updateItemMeta(Item item, T? value) async {
    final oldMeta = await item.getMeta();
    final newMeta = _updateMeta(oldMeta, value);
    await item.setMeta(newMeta);
  }

  Future<T> _getContent(Item item) async {
    final content = await item.getContent();
    return _adapter.fromMsgPack(msgPack.decode(content));
  }

  Future<void> _setContent(Item item, T value) async {
    final content = msgPack.encode(_adapter.toMsgPack(value));
    await item.setContent(content);
  }

  Future<ValueOrDeleted<T>> _getVoD(Item item) async =>
      item.isDeleted ? Deleted<T>() : Value(await _getContent(item));

  Future<Item> _setVoD(Item item, ValueOrDeleted<T> vod) async {
    switch (vod) {
      case Value() when item.isDeleted:
        throw ItemDeleted(item.uid);
      case Value(:final value):
        await _setContent(item, value);
        await _updateItemMeta(item, value);
      case Deleted() when !item.isDeleted:
        await item.delete();
        await _updateItemMeta(item, null);
    }
    return item;
  }

  Future<List<String>> _processFrame(ItemListResponse<Item> frame) =>
      DisposeScope.scoped(() async {
        final (_, uids) = await _syncEngine.updateFromFrame(_cache, frame);
        return uids;
      });
}
