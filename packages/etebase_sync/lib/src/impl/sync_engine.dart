import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import '../api/exceptions/cache_miss.dart';
import '../api/exceptions/item_deleted.dart';
import '../api/models/conflict_origin.dart';
import '../api/models/conflict_resolution.dart';
import 'caching/cache_view.dart';
import 'etebase_sync_impl.dart';
import 'util/dispose_scope.dart';

@internal
abstract interface class SyncTarget<
  TInstance extends Item,
  TMeta extends ItemMetadata,
  TFetchOptions /* extends FetchOptionsBase */
> {
  @protected
  TFetchOptions internalCreateFetchOptions(String? stoken);

  @protected
  Future<ListResponse<TInstance>> internalList(
    String container,
    TFetchOptions options,
  );

  @protected
  Future<TInstance> internalFetch(String uid, [TInstance? instance]);

  @protected
  Future<void> internalUpload(TInstance instance, {bool transaction = true});

  @protected
  FutureOr<ConflictResolution<TInstance>> internalResolveConflict({
    required String uid,
    required TInstance local,
    required TInstance remote,
    required ConflictOrigin origin,
  });

  Future<void> internalValidate(TInstance instance, String container);
}

@internal
class SyncEngine<TInstance extends Item, TMeta extends ItemMetadata> {
  final EtebaseSyncImpl _sync;
  final SyncTarget<TInstance, TMeta, dynamic> _target;

  SyncEngine(this._sync, this._target);

  Future<void> updateCache(CacheView<TInstance> cache) async =>
      await _sync.runOnline(() async {
        var stoken = cache.getStoken();
        ListResponse<TInstance> response;
        do {
          response = await _target.internalList(
            cache.container,
            _target.internalCreateFetchOptions(stoken),
          );

          stoken = await updateFromFrame(cache, response);
        } while (!response.isDone);
      });

  Future<String?> updateFromFrame(
    CacheView<TInstance> cache,
    ListResponse<TInstance> frame,
  ) async {
    frame.data.forEach(DisposeScope.attach);
    for (final instance in frame.data) {
      await _target.internalValidate(instance, cache.container);

      try {
        await cache.saveItem(instance, SaveMode.fromRemote);
      } on Conflict {
        final local = await cache.getItem(instance.uid);
        await resolveConflict(
          cache: cache,
          local: local,
          remote: instance,
          origin: ConflictOrigin.cache,
        );
      }
    }

    final stoken = switch (frame) {
      ItemListResponse(:final stoken) => stoken,
      CollectionListResponse(:final stoken) => stoken,
      IteratorListResponse(:final iterator) => iterator,
      _ => null,
    };
    await cache.saveStoken(stoken);
    return stoken;
  }

  Future<TInstance?> loadIfExists(
    CacheView<TInstance> cache,
    String uid, {
    bool fromCache = false,
    bool fetchAll = false,
    bool allowNull = true,
  }) async {
    if (fetchAll) {
      await updateCache(cache);
    }

    final cached = DisposeScope.attach(await cache.getItem(uid));
    TInstance? instance;
    if (fromCache || fetchAll) {
      instance = cached;
    } else {
      instance = await _sync.runOnline<TInstance?>(() async {
        final remote = DisposeScope.attach(
          await _target.internalFetch(uid, cached),
        );

        try {
          return await cache.saveItem(remote, SaveMode.fromRemote);
        } on Conflict {
          return await resolveConflict(
            cache: cache,
            local: cached,
            remote: remote,
            origin: ConflictOrigin.cache,
          );
        }
      }, whenOffline: () => cached);
    }

    if (allowNull && (instance == null || instance.isDeleted)) {
      return null;
    } else if (instance == null) {
      throw CacheMiss(uid);
    } else if (instance.isDeleted) {
      throw ItemDeleted(uid);
    }

    await _target.internalValidate(instance, cache.container);

    return instance;
  }

  Future<TInstance> load(
    CacheView<TInstance> cache,
    String uid, {
    bool fetchAll = false,
    bool fromCache = false,
  }) async => (await loadIfExists(
    cache,
    uid,
    fetchAll: fetchAll,
    fromCache: fromCache,
    allowNull: false,
  ))!;

  Future<TInstance> save(
    CacheView<TInstance> cache,
    TInstance instance, {
    bool transaction = true,
  }) async {
    await cache.saveItem(instance, SaveMode.preUpload);

    return await _sync.runOnline(() async {
      try {
        await _target.internalUpload(instance, transaction: transaction);
        return await cache.saveItem(instance, SaveMode.postUpload);
      } on Conflict {
        final remote = DisposeScope.attach(
          await _target.internalFetch(instance.uid, instance),
        );

        return await resolveConflict(
          cache: cache,
          local: instance,
          remote: remote,
          origin: ConflictOrigin.server,
        );
      }
    }, whenOffline: () => instance);
  }

  Future<TInstance> resolveConflict({
    required CacheView<TInstance> cache,
    required TInstance? local,
    required TInstance remote,
    required ConflictOrigin origin,
  }) async {
    if (local == null) {
      return await cache.saveItem(remote, SaveMode.postUpload);
    }

    final resolution = await _target.internalResolveConflict(
      uid: remote.uid,
      local: local,
      remote: remote,
      origin: origin,
    );

    switch (resolution) {
      case ConflictResolutionLocal(value: null):
        return await save(cache, local, transaction: false);
      case ConflictResolutionLocal(:final TInstance value):
        return await save(cache, value, transaction: false);
      case ConflictResolutionRemote(value: null):
        return await cache.saveItem(remote, SaveMode.postUpload);
      case ConflictResolution(:final TInstance value):
        return await save(cache, value);
    }
  }
}
