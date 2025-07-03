import 'dart:async';
import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../api/conflict_resolution/conflict_resolver.dart';
import '../api/exceptions/cache_miss.dart';
import '../api/exceptions/collection_type_mismatch.dart';
import '../api/exceptions/read_only.dart';
import '../api/exceptions/unresolved_conflict.dart';
import '../api/models/conflict_origin.dart';
import '../api/models/conflict_resolution.dart';
import '../api/models/etebase_target.dart';
import '../api/models/repository_metadata.dart';
import '../impl/etebase_sync_impl.dart';
import '../items/items.dart';
import '../storage/collection_store.dart';
import '../storage/save_result.dart';
import 'collection_conflict_resolver.dart';

@internal
class RepositoryManager {
  final EtebaseSyncImpl _sync;
  final CollectionManager _collectionManager;
  final CollectionStore _store;
  final CollectionConflictResolver _conflictResolver;

  RepositoryManager(
    this._collectionManager,
    this._sync,
    this._store,
    this._conflictResolver,
  );

  @override
  Future<Repository<TRecord>>
  openPrimary<TRecord extends ItemRecord>() => DisposeScope.scoped(() async {
    final type = _sync.typeFor<TRecord>();
    final cache = await _cache.collectionCache(_collectionManager, type);
    await _syncEngine.updateCache(cache);

    final colUids = cache.listItems().toList();
    switch (colUids) {
      case []:
        return await create<TRecord>(const RepositoryMetadata(primary: true));
      case [final colUid]:
        var collection = await _syncEngine.load(cache, colUid, fromCache: true);
        final meta = await collection.getMeta<RepositoryMetadata>();
        if (!meta.primary) {
          await collection.setMeta(meta.copyWith(primary: true));
          collection = await _syncEngine.save(cache, collection);
        }
        return _sync.createRepo<TRecord>(DisposeScope.detachLater(collection));
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
        return await create<TRecord>(const RepositoryMetadata(primary: true));
      case [(final collection, _)]:
        return _sync.createRepo<TRecord>(DisposeScope.detachLater(collection));
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
            EtebaseTarget.collection,
            'Conflict resolved selected collection with uid "$actual" '
            'as primary collection, but it was not found!',
            origin: ConflictOrigin.cache,
            uid: actual,
          );
        }

        return _sync.createRepo<TRecord>(DisposeScope.detachLater(primaryCol));
    }
  });

  @override
  Future<Map<String, RepositoryMetadata>> list<TRecord extends ItemRecord>() =>
      DisposeScope.scoped(() async {
        final type = _sync.typeFor<TRecord>();
        // TODO await sync

        final result = <String, RepositoryMetadata>{};
        for (final colUid in cache.listItems()) {
          final collection = DisposeScope.attach(
            await _syncEngine.loadIfExists(cache, colUid, fromCache: true),
          );
          if (collection == null) {
            continue;
          }

          await internalValidate(collection, type);
          final meta = await collection.getMeta<RepositoryMetadata>();
          result[colUid] = meta;
        }
        return result;
      });

  Future<Repository<TRecord>> create<TRecord extends ItemRecord>([
    RepositoryMetadata? meta,
  ]) async {
    var collection = await _collectionManager.create(
      _sync.typeFor<TRecord>(),
      meta ?? const RepositoryMetadata(),
      Uint8List(0),
    );
    try {
      final result = await _store.saveLocal(collection, expectedEtag: null);
      collection = await _handleSaveResult(collection, result);
      // TODO wait for sync
      return _sync.createRepo<TRecord>(collection);
    } catch (_) {
      collection.dispose();
      rethrow;
    }
  }

  Future<Repository<TRecord>> open<TRecord extends ItemRecord>(
    String colUid,
  ) async {
    final collection = await _getCol<TRecord>(colUid);
    try {
      return _sync.createRepo<TRecord>(collection);
    } catch (_) {
      collection.dispose();
      rethrow;
    }
  }

  Future<RepositoryMetadata> getMeta<TRecord extends ItemRecord>(
    String colUid,
  ) async {
    final collection = await _getCol<TRecord>(colUid);
    try {
      return await collection.getMeta<RepositoryMetadata>();
    } finally {
      collection.dispose();
    }
  }

  Future<void> updateMeta<TRecord extends ItemRecord>(
    String colUid,
    RepositoryMetadata meta,
  ) async {
    final collection = await _getCol<TRecord>(colUid);

    try {
      _checkWritable(collection);
      await collection.setMeta(meta);
      // TODO wait for sync
    } finally {
      collection.dispose();
    }
  }

  Future<void> delete<TRecord extends ItemRecord>(String colUid) async {
    Collection? collection;
    try {
      collection = await _getCol<TRecord>(colUid);
      _checkWritable(collection);
      await collection.delete();
      // TODO wait for sync
    } on CacheMiss {
      // TODO change type
      return;
    } finally {
      collection?.dispose();
    }
  }

  Future<Collection> _getCol<TRecord extends ItemRecord>(String colUid) async {
    // TODO sync first
    final collection = await _store.getItem(colUid);

    try {
      if (collection == null || collection.isDeleted) {
        throw CacheMiss(colUid); // TODO change exception
      }
      _validate<TRecord>(collection);
      return collection;
    } catch (_) {
      collection?.dispose();
      rethrow;
    }
  }

  void _checkWritable(Collection collection) {
    if (collection.accessLevel == CollectionAccessLevel.readOnly) {
      throw ReadOnly(collection.uid, EtebaseTarget.collection);
    }
  }

  void _validate<TRecord extends ItemRecord>(Collection instance) {
    final expectedType = _sync.typeFor<TRecord>();
    if (instance.collectionType != expectedType) {
      final actType = instance.collectionType;
      throw CollectionTypeMismatch(
        colUid: instance.uid,
        expectedCollectionType: expectedType,
        actualCollectionType: actType,
      );
    }
  }

  Future<Collection> _handleSaveResult(
    Collection collection,
    SaveResult<Collection> result,
  ) async {
    switch (result) {
      case SaveOk():
        return collection;
      case SaveConflict<Collection>(:final cacheItem):
        try {
          return await _resolveConflict(cacheItem, collection, cacheItem.etag);
        } catch (_) {
          cacheItem.dispose();
          rethrow;
        } finally {
          collection.dispose();
        }
    }
  }

  Future<Collection> _resolveConflict(
    Collection target,
    Collection conflicted,
    String expectedEtag,
  ) async {
    await _conflictResolver.resolveConflict(
      target,
      conflicted,
      ConflictOrigin.cache,
    );
    final result = await _store.saveLocal(target, expectedEtag: expectedEtag);
    return await _handleSaveResult(target, result);
  }
}
