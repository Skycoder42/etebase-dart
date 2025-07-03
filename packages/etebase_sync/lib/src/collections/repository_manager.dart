import 'dart:async';
import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../api/exceptions/cache_miss.dart';
import '../api/exceptions/collection_type_mismatch.dart';
import '../api/exceptions/read_only.dart';
import '../api/exceptions/unresolved_conflict.dart';
import '../api/models/conflict_origin.dart';
import '../api/models/etebase_target.dart';
import '../api/models/repository_metadata.dart';
import '../impl/etebase_sync_impl.dart';
import '../items/items.dart';
import '../storage/collection_store.dart';
import '../storage/save_result.dart';
import 'collection_background_sync.dart';
import 'collection_conflict_resolver.dart';

@internal
class RepositoryManager {
  final EtebaseSyncImpl _sync;
  final CollectionManager _collectionManager;
  final CollectionStore _store;
  final CollectionConflictResolver _conflictResolver;
  final CollectionBackgroundSync _backgroundSync;

  RepositoryManager(
    this._collectionManager,
    this._sync,
    this._store,
    this._conflictResolver,
    this._backgroundSync,
  );

  Future<Repository<TRecord>> openPrimary<TRecord extends ItemRecord>({
    bool sync = true,
  }) async {
    final collectionType = _sync.typeFor<TRecord>();
    if (sync) {
      await _backgroundSync.sync(collectionType);
    }

    final primaryCollections = <(Collection, RepositoryMetadata)>[];
    try {
      await for (final collection in _store.listCollections(collectionType)) {
        try {
          final meta = await collection.getMeta<RepositoryMetadata>();
          if (meta.primary) {
            primaryCollections.add((collection, meta));
          } else {
            collection.dispose();
          }
        } catch (_) {
          collection.dispose();
          rethrow;
        }
      }

      switch (primaryCollections) {
        case []:
          return await create<TRecord>(const RepositoryMetadata(primary: true));
        case [(final collection, _)]:
          return _sync.createRepo<TRecord>(collection);
        default:
          return await _resolvePrimaryConflict(
            collectionType,
            primaryCollections,
          );
      }
    } catch (_) {
      for (final (collection, _) in primaryCollections) {
        collection.dispose();
      }
      rethrow;
    }
  }

  Future<Map<String, RepositoryMetadata>> list<TRecord extends ItemRecord>({
    bool sync = true,
  }) async {
    final collectionType = _sync.typeFor<TRecord>();
    if (sync) {
      await _backgroundSync.sync(collectionType);
    }

    final result = <String, RepositoryMetadata>{};
    await for (final collection in _store.listCollections(collectionType)) {
      try {
        if (collection.isDeleted) {
          continue;
        }

        final meta = await collection.getMeta<RepositoryMetadata>();
        result[collection.uid] = meta;
      } finally {
        collection.dispose();
      }
    }
    return result;
  }

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

      if (_sync.config.waitForUpload) {
        await _backgroundSync.waitForSync(collection.uid);
      }

      return _sync.createRepo<TRecord>(collection);
    } catch (_) {
      collection.dispose();
      rethrow;
    }
  }

  Future<Repository<TRecord>> open<TRecord extends ItemRecord>(
    String colUid, {
    bool sync = true,
  }) async {
    if (sync) {
      await _backgroundSync.sync(_sync.typeFor<TRecord>());
    }

    final collection = await _getCol<TRecord>(colUid);
    try {
      return _sync.createRepo<TRecord>(collection);
    } catch (_) {
      collection.dispose();
      rethrow;
    }
  }

  Future<RepositoryMetadata> getMeta<TRecord extends ItemRecord>(
    String colUid, {
    bool sync = true,
  }) async {
    if (sync) {
      await _backgroundSync.sync(_sync.typeFor<TRecord>());
    }

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

      if (_sync.config.waitForUpload) {
        await _backgroundSync.waitForSync(collection.uid);
      }
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

      if (_sync.config.waitForUpload) {
        await _backgroundSync.waitForSync(collection.uid);
      }

      // TODO change type
    } on CacheMiss {
      return;
    } finally {
      collection?.dispose();
    }
  }

  Future<Collection> _getCol<TRecord extends ItemRecord>(String colUid) async {
    final collection = await _store.getItem(colUid);

    try {
      if (collection == null || collection.isDeleted) {
        throw CacheMiss(colUid); // TODO change exception
      }
      _validateType<TRecord>(collection);
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

  void _validateType<TRecord extends ItemRecord>(Collection instance) {
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

  Future<Repository<TRecord>>
  _resolvePrimaryConflict<TRecord extends ItemRecord>(
    String collectionType,
    List<(Collection, RepositoryMetadata)> primaryCollections,
  ) async {
    final conflictMap = {
      for (final (collection, meta) in primaryCollections) collection.uid: meta,
    };
    final actual = await _conflictResolver.resolveMultiplePrimaryCollections(
      collectionType,
      conflictMap,
    );
    Collection? primaryCol;
    for (final (collection, meta) in primaryCollections) {
      if (collection.uid == actual) {
        primaryCol = collection;
        continue;
      }

      final cacheEtag = collection.etag;
      await collection.setMeta(meta.copyWith(primary: false));
      final result = await _store.saveLocal(
        collection,
        expectedEtag: cacheEtag,
      );
      (await _handleSaveResult(collection, result)).dispose();
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

    return _sync.createRepo<TRecord>(primaryCol);
  }
}
