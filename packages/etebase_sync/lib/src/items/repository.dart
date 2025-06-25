part of 'items.dart';

class Repository<TRecord extends ItemRecord> {
  final EtebaseSyncImpl _sync;
  final Collection _collection;
  final RepositoryAdapter<TRecord> _adapter;
  final ItemManager _itemManager;
  final CacheView<Item> _cacheView;

  Repository(
    this._sync,
    this._collection,
    this._adapter,
    this._itemManager,
    this._cacheView,
  );

  String get uid => _collection.uid;

  bool get isReadOnly =>
      _collection.accessLevel == CollectionAccessLevel.readOnly;

  Future<TRecord> create() async {
    _checkWritable();

    final item = await _itemManager.create(
      ItemMetadata(itemType: _collection.collectionType),
      Uint8List(0),
    );
    return await _createRecord(item, created: true);
  }

  Future<TRecord?> open(String uid) async {
    final item = await _cacheView.getItem(uid);
    if (item == null || item.isDeleted) {
      item?.dispose();
      return null;
    }
    return await _createRecord(item);
  }

  Future<void> persist(TRecord record) async {
    _checkWritable(record);

    /// TODOs:
    /// 1. check if the cached value has been modified -> if yes resolve
    /// 2. persist the canonical version in the cache
    /// 3. Upload to remote
    /// 4. If conflict -> resolve and go to 1.
    /// 5. Persist resolution in cache (with conflict checks)

    // If etag has not changed, item was not modified -> no need to save
    if (record._item.etag == record._cacheEtag) {
      return;
    }

    // Persist the modifications of record to the cache
    final result = await _cacheView.saveLocal(record._item, record._cacheEtag);
    switch (result) {
      case SaveOk(:final etag):
        record._cacheEtag = etag;
      case SaveConflict(:final cacheItem):
        await _resolveConflict(
          record,
          cacheItem,
          cacheItem.etag,
          ConflictOrigin.cache,
        );
        return await persist(record);
    }

    // try upload
    await _sync.runOnline(() async {
      try {
        await _itemManager.transaction([record._item]);

        // TODO use result
        await _cacheView.saveUploaded(record._item, record._cacheEtag);
      } on Conflict {
        final remoteItem = await _itemManager.fetch(record._item.uid);
        await _resolveConflict(
          record,
          remoteItem,
          record._cacheEtag,
          ConflictOrigin.server,
        );
        return await persist(record);
      }
    });
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

    if (record?._inConflictResolution ?? false) {
      throw StateError(
        'Cannot persist an item that is part of an active conflict resolution',
      );
    }
  }

  Future<void> _resolveConflict(
    TRecord target,
    Item canonicalItem,
    String cacheEtag,
    ConflictOrigin origin,
  ) async {
    final canonical = await _createRecord(canonicalItem)
      .._inConflictResolution = true;

    try {
      target._readOnly = true;
      await canonical.resolveConflict(target, origin);
    } catch (_) {
      canonical.dispose();
      rethrow;
    } finally {
      target._readOnly = false;
    }

    await target._updateItem(canonicalItem, cacheEtag);
  }
}
