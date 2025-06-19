import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import '../api/exceptions/cache_miss.dart';
import '../api/exceptions/item_deleted.dart';
import '../api/models/conflict_origin.dart';
import '../api/models/conflict_resolution.dart';
import 'etebase_sync_impl.dart';
import 'sync_cache_impl.dart';
import 'util/dispose_scope.dart';

abstract interface class SyncTarget<
  TInstance extends Item,
  TMeta extends ItemMetadata
> {
  @protected
  Future<TInstance?> internalCacheGet(String container, String uid);

  @protected
  Future<void> internalCacheSet(TInstance instance, SetMode setMode);

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

  void internalValidate(TInstance instance, String container);
}

class SyncEngine<TInstance extends Item, TMeta extends ItemMetadata> {
  final EtebaseSyncImpl _sync;
  final SyncTarget<TInstance, TMeta> _target;

  SyncEngine(this._sync, this._target);

  Future<TInstance> load(
    String container,
    String uid, {
    bool fromCache = false,
  }) async {
    final cached = DisposeScope.attach(
      await _target.internalCacheGet(container, uid),
    );
    TInstance? instance;
    if (fromCache) {
      instance = cached;
    } else {
      instance = await _sync.runOnline<TInstance?>(() async {
        final remote = DisposeScope.attach(
          await _target.internalFetch(uid, cached),
        );

        if (cached case TInstance(
          etag: final String etag,
        ) when etag == remote.etag) {
          return cached;
        }

        try {
          await _target.internalCacheSet(remote, SetMode.fromRemote);
          return remote;
        } on Conflict {
          return await resolveConflict(
            local: cached,
            remote: remote,
            origin: ConflictOrigin.cache,
          );
        }
      }, whenOffline: () => cached);
    }

    if (instance == null) {
      throw CacheMiss(uid);
    } else if (instance.isDeleted) {
      throw ItemDeleted(uid);
    }

    _target.internalValidate(instance, container);

    return instance;
  }

  Future<TInstance> save(TInstance instance, {bool transaction = true}) async {
    await _target.internalCacheSet(instance, SetMode.preUpload);

    return await _sync.runOnline(() async {
      try {
        await _target.internalUpload(instance, transaction: transaction);
        await _target.internalCacheSet(instance, SetMode.postUpload);
        return instance;
      } on Conflict {
        final remote = DisposeScope.attach(
          await _target.internalFetch(instance.uid, instance),
        );

        return await resolveConflict(
          local: instance,
          remote: remote,
          origin: ConflictOrigin.server,
        );
      }
    }, whenOffline: () => instance);
  }

  Future<TInstance> resolveConflict({
    required TInstance? local,
    required TInstance remote,
    required ConflictOrigin origin,
  }) async {
    if (local == null) {
      await _target.internalCacheSet(remote, SetMode.postUpload);
      return remote;
    }

    final resolution = await _target.internalResolveConflict(
      uid: remote.uid,
      local: local,
      remote: remote,
      origin: origin,
    );

    switch (resolution) {
      case ConflictResolutionLocal(value: null):
        return await save(local, transaction: false);
      case ConflictResolutionLocal(:final TInstance value):
        return await save(value, transaction: false);
      case ConflictResolutionRemote(value: null):
        await _target.internalCacheSet(remote, SetMode.postUpload);
        return remote;
      case ConflictResolution(:final TInstance value):
        return await save(value);
    }
  }
}
