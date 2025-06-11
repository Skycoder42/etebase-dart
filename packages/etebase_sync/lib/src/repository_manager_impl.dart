import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'api/exceptions/cache_miss.dart';
import 'api/exceptions/collection_type_mismatch.dart';
import 'api/models/repository_metadata.dart';
import 'api/repository.dart';
import 'api/repository_manager.dart';
import 'impl/etebase_sync_impl.dart';
import 'impl/sync_cache_impl.dart';

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
  Future<Repository<T>> openPrimary<T extends Object>() =>
      throw UnimplementedError();

  @override
  Future<Repository<T>> openById<T extends Object>(String colUid) async {
    final type = _sync.typeFor<T>();

    final cachedCol = await _cache.collectionGet(_collectionManager, colUid);
    final selectedCol = await _sync.runOnline<Collection?>(() async {
      final remoteCol = await _collectionManager.fetch(colUid);

      if (cachedCol case Collection(
        etag: final String etag,
      ) when etag == remoteCol.etag) {
        return cachedCol;
      }

      await _cache.collectionSet(_collectionManager, remoteCol);
      return remoteCol;
    }, cachedCol);

    if (selectedCol == null) {
      throw CacheMiss('Collection with uid "$colUid"');
    } else if (selectedCol.collectionType != type) {
      throw CollectionTypeMismatch(
        colUid: colUid,
        expectedCollectionType: type,
        actualCollectionType: selectedCol.collectionType,
      );
    }

    return await _sync.createRepo<T>(selectedCol);
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
    await _cache.collectionSet(_collectionManager, collection);

    await _sync.runOnline(() async {
      await _collectionManager.transaction(collection);
      await _cache.collectionSet(_collectionManager, collection);
    }); // TODO mark upload needed -> whenOffline

    return await _sync.createRepo<T>(collection);
  }
}
