import 'dart:typed_data';

import 'package:etebase/etebase.dart';

import '../api/item_record.dart';
import '../api/models/conflict_origin.dart';
import '../api/repository.dart';
import '../api/repository_adapter.dart';
import 'caching/cache_view.dart';

class RepositoryImpl<TRecord extends ItemRecord>
    implements Repository<TRecord> {
  final Collection _collection;
  final RepositoryAdapter<TRecord> _adapter;
  final ItemManager _itemManager;
  final CacheView<Item> _cacheView;

  RepositoryImpl(
    this._collection,
    this._adapter,
    this._itemManager,
    this._cacheView,
  );

  @override
  Future<TRecord> create() async {
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

  Future<Item> persist(TRecord record) async {
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
      // TODO mark read only
      final cacheRecord = await _createRecord(cacheItem);
      try {
        // TODO use parts?
        // ignore: invalid_use_of_visible_for_overriding_member for internal
        await record.resolveConflict(cacheRecord, ConflictOrigin.cache);
        record.lastEtag = cacheRecord.lastEtag;
      } finally {
        cacheRecord.dispose();
      }

      return await persist(record);
    }

    return record.item;
  }

  Future<TRecord> _createRecord(Item item, {bool created = false}) async {
    final record = _adapter.createRecord(this, item);
    await record.init(created: created);
    return record;
  }
}
