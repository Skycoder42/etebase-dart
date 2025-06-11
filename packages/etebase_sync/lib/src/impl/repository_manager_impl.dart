import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../api/exceptions/cache_miss.dart';
import '../api/exceptions/collection_type_mismatch.dart';
import '../api/models/repository_metadata.dart';
import '../api/repository.dart';
import '../api/repository_manager.dart';
import 'etebase_sync_impl.dart';
import 'sync_cache_impl.dart';
import 'util/streamed_response.dart';

@internal
class RepositoryManagerImpl implements RepositoryManager {
  final EtebaseSyncImpl _sync;

  final CollectionManager _collectionManager;
  final SyncCacheImpl _cache;

  @visibleForTesting
  RepositoryManagerImpl(this._sync, this._collectionManager, this._cache);

  @override
  Future<void> dispose() async {
    await _cache.dispose();
  }

  @override
  Future<Repository<T>> openPrimary<T extends Object>() async {
    final type = _sync.typeFor<T>();
    await _updateCache(type);

    final colIds = _cache.collectionList(type).toList();
    switch (colIds) {
      case []:
        return await create<T>(meta: const RepositoryMetadata(primary: true));
      case [final colUid]:
        final collection = await _loadCollection(colUid, fromCache: true);
        final meta = await collection.getMeta<RepositoryMetadata>();
        if (!meta.primary) {
          await collection.setMeta(meta.copyWith(primary: true));
          await _saveCollection(collection);
        }
        return await _sync.createRepo<T>(collection);
      default:
        break;
    }

    // TODO find primary or fail
    throw UnimplementedError();
  }

  Future<Map<String, RepositoryMetadata>> list<T extends Object>() async {
    final type = _sync.typeFor<T>();
    await _updateCache(type);

    final result = <String, RepositoryMetadata>{};
    for (final colUid in _cache.collectionList(type)) {
      final collection = await _cache.collectionGet(colUid);
      if (collection == null || collection.isDeleted) {
        continue;
      }

      final meta = await collection.getMeta<RepositoryMetadata>();
      result[colUid] = meta;
    }
    return result;
  }

  @override
  Future<Repository<T>> openById<T extends Object>(String colUid) async {
    final type = _sync.typeFor<T>();

    final collection = await _loadCollection(colUid, collectionType: type);

    return await _sync.createRepo<T>(collection);
  }

  @override
  Future<Repository<T>> create<T extends Object>({
    RepositoryMetadata? meta,
  }) async {
    final collection = await _collectionManager.create(
      _sync.typeFor<T>(),
      meta ?? const RepositoryMetadata(),
      Uint8List(0),
    );

    await _saveCollection(collection);

    return await _sync.createRepo<T>(collection);
  }

  Future<void> updateMeta(
    String colUid,
    RepositoryMetadata Function(RepositoryMetadata meta) update,
  ) async {
    final collection = await _loadCollection(colUid);

    final oldMeta = await collection.getMeta<RepositoryMetadata>();
    final newMeta = update(oldMeta);
    await collection.setMeta(newMeta);

    await _saveCollection(collection);
  }

  Future<void> delete(String colUid) async {
    final collection = await _loadCollection(colUid);

    await collection.delete();

    await _saveCollection(collection);
  }

  Future<void> _updateCache(String collectionType) async =>
      await _sync.runOnline(() async {
        var stoken = await _cache.loadStokenFor(collectionType);
        final colStream = streamedResponse(
          (token) async => await _collectionManager.list(
            collectionType,
            FetchOptions(stoken: token),
          ),
          stoken,
          (token) => stoken = token,
        );

        await for (final collection in colStream) {
          await _cache.collectionSet(collection);
        }

        await _cache.saveStokenFor(collectionType, stoken);
      });

  Future<Collection> _loadCollection(
    String colUid, {
    String? collectionType,
    bool fromCache = false,
  }) async {
    final cachedCol = await _cache.collectionGet(colUid);
    Collection? collection;
    if (fromCache) {
      collection = cachedCol;
    } else {
      collection = await _sync.runOnline<Collection?>(() async {
        final remoteCol = await _collectionManager.fetch(colUid);

        if (cachedCol case Collection(
          etag: final String etag,
        ) when etag == remoteCol.etag) {
          return cachedCol;
        }

        await _cache.collectionSet(remoteCol);
        return remoteCol;
      }, whenOffline: () => cachedCol);
    }

    if (collection == null) {
      throw CacheMiss('Collection with uid "$colUid"');
    } else if (collectionType != null &&
        collection.collectionType != collectionType) {
      throw CollectionTypeMismatch(
        colUid: colUid,
        expectedCollectionType: collectionType,
        actualCollectionType: collection.collectionType,
      );
    } else if (collection.isDeleted) {
      throw UnimplementedError('TODO real error');
    }

    return collection;
  }

  Future<void> _saveCollection(Collection collection) async {
    await _cache.collectionSet(collection, needsUpload: true);
    await _sync.runOnline(() async {
      await _collectionManager.transaction(collection);
      await _cache.collectionSet(collection);
    });
  }
}
