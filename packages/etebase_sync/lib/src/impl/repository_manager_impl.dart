import 'dart:async';
import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../api/conflict_resolution/conflict_resolver.dart';
import '../api/exceptions/collection_type_mismatch.dart';
import '../api/exceptions/unresolved_conflict.dart';
import '../api/models/conflict_origin.dart';
import '../api/models/conflict_resolution.dart';
import '../api/models/repository_metadata.dart';
import '../api/repository.dart';
import '../api/repository_manager.dart';
import 'caching/cache_manager.dart';
import 'etebase_sync_impl.dart';
import 'sync_engine.dart';
import 'util/dispose_scope.dart';

@internal
class RepositoryManagerImpl
    implements
        RepositoryManager,
        SyncTarget<Collection, RepositoryMetadata, FetchOptions> {
  final EtebaseSyncImpl _sync;
  final CacheManager _cache;
  final ConflictResolver _conflictResolver;
  final CollectionManager _collectionManager;

  late final _syncEngine = SyncEngine<Collection, RepositoryMetadata>(
    _sync,
    this,
  );

  RepositoryManagerImpl(
    this._sync,
    this._cache,
    this._conflictResolver,
    this._collectionManager,
  );

  @override
  Future<Repository<T>>
  openPrimary<T extends Object>() => DisposeScope.scoped(() async {
    final type = _sync.typeFor<T>();
    final cache = await _cache.collectionCache(_collectionManager, type);
    await _syncEngine.updateCache(cache);

    final colUids = cache.listItems().toList();
    switch (colUids) {
      case []:
        return await create<T>(const RepositoryMetadata(primary: true));
      case [final colUid]:
        var collection = await _syncEngine.load(cache, colUid, fromCache: true);
        final meta = await collection.getMeta<RepositoryMetadata>();
        if (!meta.primary) {
          await collection.setMeta(meta.copyWith(primary: true));
          collection = await _syncEngine.save(cache, collection);
        }
        return await _sync.createRepo<T>(DisposeScope.detachLater(collection));
      default:
        break;
    }

    final primaryCollections = <(Collection, RepositoryMetadata)>[];
    for (final colUid in colUids) {
      final collection = await _syncEngine.load(cache, colUid, fromCache: true);
      final meta = await collection.getMeta<RepositoryMetadata>();
      if (meta.primary) {
        primaryCollections.add((collection, meta));
      }
    }

    switch (primaryCollections) {
      case []:
        return await create<T>(const RepositoryMetadata(primary: true));
      case [(final collection, _)]:
        return await _sync.createRepo<T>(DisposeScope.detachLater(collection));
      default:
        final conflictMap = {
          for (final (collection, meta) in primaryCollections)
            collection.uid: meta,
        };
        final actual = await _conflictResolver
            .resolveMultiplePrimaryCollections(type, conflictMap);
        Collection? primaryCol;
        for (final (collection, meta) in primaryCollections) {
          if (collection.uid == actual) {
            primaryCol = collection;
            continue;
          }

          await collection.setMeta(meta.copyWith(primary: false));
          await _syncEngine.save(cache, collection);
        }

        if (primaryCol == null) {
          throw UnresolvedConflict(
            ConflictTarget.collection,
            'Conflict resolved selected collection with uid "$actual" '
            'as primary collection, but it was not found!',
            origin: ConflictOrigin.cache,
            uid: actual,
          );
        }

        return await _sync.createRepo<T>(DisposeScope.detachLater(primaryCol));
    }
  });

  @override
  Future<Map<String, RepositoryMetadata>> list<T extends Object>() =>
      DisposeScope.scoped(() async {
        final type = _sync.typeFor<T>();
        final cache = await _cache.collectionCache(_collectionManager, type);
        await _syncEngine.updateCache(cache);

        final result = <String, RepositoryMetadata>{};
        for (final colUid in cache.listItems()) {
          final collection = DisposeScope.attach(await cache.getItem(colUid));
          if (collection == null || collection.isDeleted) {
            continue;
          }

          await internalValidate(collection, type);
          final meta = await collection.getMeta<RepositoryMetadata>();
          result[colUid] = meta;
        }
        return result;
      });

  @override
  Future<Repository<T>> create<T extends Object>([RepositoryMetadata? meta]) =>
      DisposeScope.scoped(() async {
        final type = _sync.typeFor<T>();
        final cache = await _cache.collectionCache(_collectionManager, type);
        var collection = DisposeScope.attach(
          await _collectionManager.create(
            _sync.typeFor<T>(),
            meta ?? const RepositoryMetadata(),
            Uint8List(0),
          ),
        );
        collection = await _syncEngine.save(cache, collection);
        return await _sync.createRepo<T>(DisposeScope.detachLater(collection));
      });

  @override
  Future<Repository<T>> open<T extends Object>(String colUid) =>
      DisposeScope.scoped(() async {
        final type = _sync.typeFor<T>();
        final cache = await _cache.collectionCache(_collectionManager, type);
        final collection = await _syncEngine.load(cache, colUid);
        return await _sync.createRepo<T>(DisposeScope.detachLater(collection));
      });

  @override
  Future<RepositoryMetadata> getMeta<T extends Object>(String colUid) =>
      DisposeScope.scoped(() async {
        final type = _sync.typeFor<T>();
        final cache = await _cache.collectionCache(_collectionManager, type);
        final collection = await _syncEngine.load(cache, colUid);
        return await collection.getMeta();
      });

  @override
  Future<void> updateMeta<T extends Object>(
    String colUid,
    RepositoryMetadata meta,
  ) => DisposeScope.scoped(() async {
    final type = _sync.typeFor<T>();
    final cache = await _cache.collectionCache(_collectionManager, type);
    final collection = await _syncEngine.load(cache, colUid);
    await collection.setMeta(meta);
    await _syncEngine.save(cache, collection);
  });

  @override
  Future<void> delete<T extends Object>(String colUid) =>
      DisposeScope.scoped(() async {
        final type = _sync.typeFor<T>();
        final cache = await _cache.collectionCache(_collectionManager, type);
        final collection = await _syncEngine.load(cache, colUid);
        await collection.delete();
        await _syncEngine.save(cache, collection);
      });

  @override
  @protected
  FetchOptions internalCreateFetchOptions(String? stoken) =>
      FetchOptions(stoken: stoken);

  @override
  @protected
  Future<ListResponse<Collection>> internalList(
    String container,
    FetchOptions options,
  ) async => await _collectionManager.list(container, options);

  @override
  @protected
  Future<Collection> internalFetch(String uid, [Collection? _]) async =>
      await _collectionManager.fetch(uid);

  @override
  @protected
  Future<void> internalUpload(
    Collection instance, {
    bool transaction = true,
  }) async {
    if (transaction) {
      await _collectionManager.transaction(instance);
    } else {
      await _collectionManager.upload(instance);
    }
  }

  @override
  @protected
  FutureOr<ConflictResolution<Collection>> internalResolveConflict({
    required String uid,
    required Collection local,
    required Collection remote,
    required ConflictOrigin origin,
  }) async {
    final resolution = await _conflictResolver.resolveRepositoryConflict(
      colUid: remote.uid,
      localMeta: await local.getMeta<RepositoryMetadata>(),
      remoteMeta: await remote.getMeta<RepositoryMetadata>(),
      deletedLocally: local.isDeleted,
      deletedRemotely: remote.isDeleted,
      origin: origin,
    );

    return resolution.map(
      local: (value) async {
        await local.setMeta(value);
        return local;
      },
      remote: (value) async {
        await remote.setMeta(value);
        return remote;
      },
    );
  }

  @override
  @protected
  Future<void> internalValidate(Collection instance, String container) =>
      Future.sync(() {
        if (instance.collectionType != container) {
          final actType = instance.collectionType;
          throw CollectionTypeMismatch(
            colUid: instance.uid,
            expectedCollectionType: container,
            actualCollectionType: actType,
          );
        }
      });
}
