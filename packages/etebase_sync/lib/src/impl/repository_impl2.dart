import 'dart:typed_data';

import 'package:etebase/etebase.dart';

import '../api/exceptions/read_only.dart';
import '../api/item_record.dart';
import '../api/models/conflict_origin.dart';
import '../api/models/etebase_target.dart';
import '../api/repository.dart';
import '../api/repository_adapter.dart';
import 'caching/cache_view.dart';
import 'etebase_sync_impl.dart';

class RepositoryImpl<TRecord extends ItemRecord>
    implements Repository<TRecord> {
  final EtebaseSyncImpl _sync;
  final Collection _collection;
  final RepositoryAdapter<TRecord> _adapter;
  final ItemManager _itemManager;
  final CacheView<Item> _cacheView;

  RepositoryImpl(
    this._sync,
    this._collection,
    this._adapter,
    this._itemManager,
    this._cacheView,
  );

  String get uid => _collection.uid;

  bool get isReadOnly =>
      _collection.accessLevel == CollectionAccessLevel.readOnly;

  @override
  Future<TRecord> create() async {
    _checkWritable();

    final item = await _itemManager.create(
      ItemMetadata(itemType: _collection.collectionType),
      Uint8List(0),
    );
    return await _createRecord(item, created: true);
  }

  @override
  Future<TRecord?> open(String uid) async {
    final item = await _cacheView.getItem(uid);
    if (item == null || item.isDeleted) {
      item?.dispose();
      return null;
    }
    return await _createRecord(item);
  }

  Future<Item> persist(TRecord record, {bool transaction = true}) async {
    _checkWritable(record);

    /// TODOs:
    /// 1. check if the cached value has been modified -> if yes resolve
    /// 2. persist the canonical version in the cache
    /// 3. Upload to remote
    /// 4. If conflict -> resolve and go to 1.
    /// 5. Persist resolution in cache (with conflict checks)

    // Check if updated at all
    if (record.item.etag == record.lastEtag) {
      return record.item;
    }

    // Persist the modifications of record to the cache
    final result = await _cacheView.saveLocal(record.item, record.lastEtag);
    if (result case SaveConflict(:final cacheItem)) {
      await _resolveConflict(record, cacheItem, ConflictOrigin.cache);
      return await persist(record, transaction: transaction);
    }

    // try upload
    await _sync.runOnline(() async {
      try {
        if (transaction) {
          await _itemManager.transaction([record.item]);
        } else {
          await _itemManager.batch([record.item]);
        }
      } on Conflict {
        final remoteRecord = await _createRecord(remoteItem, readOnly: true)
          ..lastEtag = record.lastEtag;

        // TODO swap items?
        final remoteItem = await _itemManager.fetch(record.item.uid);
        await _resolveConflict(record, remoteItem, ConflictOrigin.server);
        return await persist(record, transaction: transaction);
      }
    });

    return record.item;
  }

  Future<TRecord> _createRecord(
    Item item, {
    bool created = false,
    bool readOnly = false,
  }) async {
    try {
      final record = _adapter.createRecord(this, item, readOnly: readOnly);
      await record.init(created: created);
      return record;
    } catch (_) {
      item.dispose();
      rethrow;
    }
  }

  void _checkWritable([TRecord? record]) {
    if (isReadOnly) {
      throw ReadOnly(_collection.uid, EtebaseTarget.collection);
    }

    if (record?.inConflictResolution ?? false) {
      throw StateError(
        'Cannot persist an item that is part of an active conflict resolution',
      );
    }
  }

  Future<void> _resolveConflict(
    TRecord original,
    Item other,
    ConflictOrigin origin,
  ) async {
    final otherRecord = await _createRecord(other, readOnly: true);
    try {
      // TODO use parts?
      original.inConflictResolution = true;
      // ignore: invalid_use_of_visible_for_overriding_member for internal
      await original.resolveConflict(otherRecord, origin);
      original.lastEtag = otherRecord.lastEtag; // TODO ???
    } finally {
      original.inConflictResolution = false;
      otherRecord.dispose();
    }
  }
}
