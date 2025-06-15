import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../api/conflict_resolution/conflict_resolver.dart';
import '../api/exceptions/cache_miss.dart';
import '../api/exceptions/collection_deleted.dart';
import '../api/exceptions/collection_type_mismatch.dart';
import '../api/exceptions/unresolved_conflict.dart';
import '../api/models/conflict_origin.dart';
import '../api/models/repository_conflict_resolution.dart';
import '../api/models/repository_metadata.dart';
import '../api/repository.dart';
import '../api/repository_manager.dart';
import 'etebase_sync_impl.dart';
import 'sync_cache_impl.dart';
import 'util/dispose_scope.dart';

@internal
class RepositoryManagerImpl implements RepositoryManager {
  final EtebaseSyncImpl _sync;
  final SyncCacheImpl _cache;
  final ConflictResolver _conflictResolver;
  final CollectionManager _collectionManager;

  @visibleForTesting
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
    await _updateCache(type);

    final colUids = _cache.collectionList(type).toList();
    switch (colUids) {
      case []:
        return await create<T>(meta: const RepositoryMetadata(primary: true));
      case [final colUid]:
        var collection = await _loadCollection(type, colUid, fromCache: true);
        final meta = await collection.getMeta<RepositoryMetadata>();
        if (!meta.primary) {
          await collection.setMeta(meta.copyWith(primary: true));
          collection = await _saveCollection(collection);
        }
        return await _sync.createRepo<T>(DisposeScope.detachLater(collection));
      default:
        break;
    }

    final primaryCollections = <(Collection, RepositoryMetadata)>[];
    for (final colUid in colUids) {
      final collection = await _loadCollection(type, colUid, fromCache: true);
      final meta = await collection.getMeta<RepositoryMetadata>();
      if (meta.primary) {
        primaryCollections.add((collection, meta));
      }
    }

    switch (primaryCollections) {
      case []:
        return await create<T>(meta: const RepositoryMetadata(primary: true));
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
          await _saveCollection(collection);
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

  Future<Map<String, RepositoryMetadata>> list<T extends Object>() =>
      DisposeScope.scoped(() async {
        final type = _sync.typeFor<T>();
        await _updateCache(type);

        final result = <String, RepositoryMetadata>{};
        for (final colUid in _cache.collectionList(type)) {
          final collection = DisposeScope.attach(
            await _cache.collectionGet(type, colUid),
          );
          if (collection == null || collection.isDeleted) {
            continue;
          }

          _validateType(collection, type);
          final meta = await collection.getMeta<RepositoryMetadata>();
          result[colUid] = meta;
        }
        return result;
      });

  @override
  Future<Repository<T>> openById<T extends Object>(String colUid) =>
      DisposeScope.scoped(() async {
        final type = _sync.typeFor<T>();
        final collection = await _loadCollection(type, colUid);
        return await _sync.createRepo<T>(DisposeScope.detachLater(collection));
      });

  @override
  Future<Repository<T>> create<T extends Object>({RepositoryMetadata? meta}) =>
      DisposeScope.scoped(() async {
        var collection = DisposeScope.attach(
          await _collectionManager.create(
            _sync.typeFor<T>(),
            meta ?? const RepositoryMetadata(),
            Uint8List(0),
          ),
        );
        collection = await _saveCollection(collection);
        return await _sync.createRepo<T>(DisposeScope.detachLater(collection));
      });

  Future<RepositoryMetadata> getMeta<T extends Object>(String colUid) =>
      DisposeScope.scoped(() async {
        final collection = await _loadCollection(_sync.typeFor<T>(), colUid);
        return await collection.getMeta();
      });

  Future<void> updateMeta<T extends Object>(
    String colUid,
    RepositoryMetadata meta,
  ) => DisposeScope.scoped(() async {
    final collection = await _loadCollection(_sync.typeFor<T>(), colUid);
    await collection.setMeta(meta);
    await _saveCollection(collection);
  });

  Future<void> delete<T extends Object>(String colUid) =>
      DisposeScope.scoped(() async {
        final collection = await _loadCollection(_sync.typeFor<T>(), colUid);
        if (collection.isDeleted) {
          return;
        }
        await collection.delete();
        await _saveCollection(collection);
      });

  Future<void> _updateCache(String collectionType) async =>
      await _sync.runOnline(() async {
        var stoken = await _cache.loadStokenFor(collectionType);
        CollectionListResponse<Collection> response;
        do {
          response = await _collectionManager.list(
            collectionType,
            FetchOptions(stoken: stoken),
          );

          for (final collection in response.data) {
            _validateType(collection, collectionType);

            try {
              await _cache.collectionSet(collection);
            } on Conflict {
              final local = await _cache.collectionGet(
                collectionType,
                collection.uid,
              );
              await _resolveConflict(
                local: local,
                remote: collection,
                origin: ConflictOrigin.cache,
              );
            }
          }

          stoken = response.stoken;
          await _cache.saveStokenFor(collectionType, stoken);
        } while (!response.isDone);
      });

  Future<Collection> _loadCollection(
    String collectionType,
    String colUid, {
    bool fromCache = false,
  }) async {
    final cachedCol = DisposeScope.attach(
      await _cache.collectionGet(collectionType, colUid),
    );
    Collection? collection;
    if (fromCache) {
      collection = cachedCol;
    } else {
      collection = await _sync.runOnline<Collection?>(() async {
        final remoteCol = DisposeScope.attach(
          await _collectionManager.fetch(colUid),
        );

        if (cachedCol case Collection(
          etag: final String etag,
        ) when etag == remoteCol.etag) {
          return cachedCol;
        }

        try {
          await _cache.collectionSet(remoteCol);
          return remoteCol;
        } on Conflict {
          return await _resolveConflict(
            local: cachedCol,
            remote: remoteCol,
            origin: ConflictOrigin.cache,
          );
        }
      }, whenOffline: () => cachedCol);
    }

    if (collection == null) {
      throw CacheMiss('Collection with uid "$colUid"');
    } else if (collection.isDeleted) {
      throw CollectionDeleted(colUid);
    }

    _validateType(collection, collectionType);

    return collection;
  }

  Future<Collection> _saveCollection(
    Collection collection, {
    bool transaction = true,
  }) async {
    await _cache.collectionSet(collection, SetMode.preUpload);

    return await _sync.runOnline(() async {
      try {
        if (transaction) {
          await _collectionManager.transaction(collection);
        } else {
          await _collectionManager.upload(collection);
        }
        await _cache.collectionSet(collection, SetMode.postUpload);
        return collection;
      } on Conflict {
        final remote = DisposeScope.attach(
          await _collectionManager.fetch(collection.uid),
        );

        return await _resolveConflict(
          local: collection,
          remote: remote,
          origin: ConflictOrigin.server,
        );
      }
    }, whenOffline: () => collection);
  }

  Future<Collection> _resolveConflict({
    required Collection? local,
    required Collection remote,
    required ConflictOrigin origin,
  }) async {
    if (local == null) {
      await _cache.collectionSet(remote, SetMode.postUpload);
      return remote;
    }

    final resolution = await _conflictResolver.resolveRepositoryConflict(
      colUid: remote.uid,
      localMeta: await local.getMeta<RepositoryMetadata>(),
      remoteMeta: await remote.getMeta<RepositoryMetadata>(),
      deletedLocally: local.isDeleted,
      deletedRemotely: remote.isDeleted,
      origin: origin,
    );

    switch (resolution) {
      case RepositoryConflictResolutionLocal(:final meta):
        if (meta != null) {
          await local.setMeta(meta);
        }
        return await _saveCollection(local, transaction: false);
      case RepositoryConflictResolutionRemote(meta: null):
        await _cache.collectionSet(remote, SetMode.postUpload);
        return remote;
      case RepositoryConflictResolutionRemote(:final RepositoryMetadata meta):
        await remote.setMeta(meta);
        return await _saveCollection(remote);
    }
  }

  void _validateType(Collection collection, String collectionType) {
    if (collection.collectionType != collectionType) {
      final actType = collection.collectionType;
      throw CollectionTypeMismatch(
        colUid: collection.uid,
        expectedCollectionType: collectionType,
        actualCollectionType: actType,
      );
    }
  }
}
