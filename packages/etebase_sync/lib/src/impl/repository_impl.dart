import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:msgpack_codec/msgpack_codec.dart';

import '../api/conflict_resolution/conflict_resolver.dart';
import '../api/exceptions/item_deleted.dart';
import '../api/models/conflict_origin.dart';
import '../api/models/conflict_resolution.dart';
import '../api/models/value_or_deleted.dart';
import '../api/repository_adapter.dart';
import 'etebase_sync_impl.dart';
import 'sync_cache_impl.dart';
import 'sync_engine.dart';
import 'util/dispose_scope.dart';

// TODO automatically handle read only collections

class Repository<T extends Object>
    implements SyncTarget<Item, ItemMetadata, ItemFetchOptions> {
  final EtebaseSyncImpl _sync;
  final SyncCacheImpl _cache;
  final ConflictResolver _conflictResolver;
  final SyncEngine _syncEngine;

  final Collection _collection;
  final ItemManager _itemManager;
  final RepositoryAdapter<T> _adapter;

  Repository(
    this._sync,
    this._cache,
    this._conflictResolver,
    this._syncEngine,
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
    item = await _syncEngine.save(item);
    return item.uid;
  });

  Future<void> update(String uid, T value) => DisposeScope.scoped(() async {
    final item = await _syncEngine.load(_collection.uid, uid, fromCache: true);
    final oldMeta = await item.getMeta();
    final newMeta = _updateMeta(oldMeta, value);
    await item.setMeta(newMeta);
    await _setContent(item, value);
    await _syncEngine.save(item);
  });

  @override
  Future<String?> internalLoadStokenFor(String container) {
    // TODO: implement internalLoadStokenFor
    throw UnimplementedError();
  }

  @override
  Future<void> internalSaveStokenFor(String container, String? stoken) {
    // TODO: implement internalSaveStokenFor
    throw UnimplementedError();
  }

  @override
  Future<Item?> internalCacheGet(String container, String uid) async =>
      await _cache.itemGet(_itemManager, container, uid);

  @override
  Future<void> internalCacheSet(Item instance, SetMode setMode) async =>
      await _cache.itemSet(_itemManager, _collection.uid, instance, setMode);

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

  ItemMetadata _updateMeta(ItemMetadata? meta, T value) {
    final baseMeta =
        _adapter.updateMeta(meta, value) ?? meta ?? const ItemMetadata();
    return baseMeta.copyWith(
      itemType: baseMeta.itemType ?? _collection.collectionType,
      mtime: DateTime.now(),
    );
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
      case Deleted() when !item.isDeleted:
        await item.delete();
    }
    return item;
  }
}
