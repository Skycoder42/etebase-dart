part of 'items.dart';

class Repository<TRecord extends ItemRecord> {
  final EtebaseSyncImpl _sync;
  final Collection _collection;
  final RepositoryAdapter<TRecord> _adapter;
  final ItemManager _itemManager;
  final CacheView<Item> _cacheView;
  final BackgroundSync _backgroundSync;

  Repository(
    this._sync,
    this._collection,
    this._adapter,
    this._itemManager,
    this._cacheView,
    this._backgroundSync,
  );

  String get uid => _collection.uid;

  bool get isReadOnly =>
      _collection.accessLevel == CollectionAccessLevel.readOnly;

  Future<List<String>> list({bool sync = false}) async {
    if (sync) {
      await _backgroundSync.sync();
    }

    return _cacheView.listItems().toList();
  }

  Future<Map<String, ItemMetadata>> listMeta({bool sync = false}) async {
    if (sync) {
      await _backgroundSync.sync();
    }

    return {
      for (final uid in _cacheView.listItems())
        uid: ?(await (await _cacheView.getItem(uid))?.getMeta()),
    };
  }

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

  void _checkWritable() {
    if (isReadOnly) {
      throw ReadOnly(_collection.uid, EtebaseTarget.collection);
    }
  }

  Future<TRecord> _createRecord(
    Item item, {
    bool created = false,
    _RecordState? forceState,
  }) async {
    try {
      if (item.isDeleted) {
        throw ItemDeleted(item.uid);
      }

      final record = _adapter.createRecord(this, item);
      await record.init(created: created);
      if (forceState != null) {
        record._state = forceState;
      }
      return record;
    } catch (_) {
      item.dispose();
      rethrow;
    }
  }

  Future<void> _refresh(TRecord record, bool sync) async {
    if (sync) {
      await _backgroundSync.sync();
    }

    final recordState = record._state;
    try {
      record._state = _RecordState.locked;

      // load from cache
      final cacheItem = await _cacheView.getItem(record.uid);
      if (cacheItem == null) {
        throw ItemDeleted(record.uid);
      }

      // update record if necessary
      if (cacheItem.etag != record.etag) {
        await record._updateItem(cacheItem, cacheItem.etag);
      } else {
        cacheItem.dispose();
      }
    } finally {
      record._state = recordState;
    }
  }

  Future<void> _persist(TRecord record) async {
    final recordState = record._state;
    try {
      record._state = _RecordState.locked;
      await _saveToCache(record);

      if (_sync.config.waitForUpload) {
        await _backgroundSync.syncEvents.firstWhere((e) => e.uid == record.uid);
      }
    } finally {
      record._state = recordState;
    }
  }

  Future<String> _saveToCache(TRecord record) async {
    // If etag has not changed, item was not modified -> no need to save
    if (record._item.etag == record._cacheEtag) {
      return record._item.etag;
    }

    final result = await _cacheView.saveLocal(
      record._item,
      expectedEtag: record._cacheEtag,
    );
    switch (result) {
      case SaveOk(:final etag):
        record._cacheEtag = etag;
        return etag;
      case SaveDeleted():
        throw ItemDeleted(record.uid);
      case SaveConflict(:final cacheItem):
        // if cacheItem was deleted, _createRecord will throw, so no need to
        // handle this here
        await _resolveCacheConflict(record, cacheItem, cacheItem.etag);
        return await _saveToCache(record);
    }
  }

  /// After resolution, the [target] will be updated to instead reference
  /// [canonicalItem] with a last known cache etag of [cacheEtag]. As part of
  /// the resolution, [canonicalItem] may be updated with changes from [target].
  Future<void> _resolveCacheConflict(
    TRecord target,
    Item canonicalItem,
    String cacheEtag,
  ) async {
    final canonical = await _createRecord(
      canonicalItem,
      forceState: _RecordState.conflictResolving,
    );

    try {
      await canonical.resolveConflict(target, ConflictOrigin.cache);
    } catch (_) {
      canonical.dispose();
      rethrow;
    }

    await target._updateItem(canonicalItem, cacheEtag);
  }
}
