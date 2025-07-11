part of 'items.dart';

class Repository<TRecord extends ItemRecord> {
  final OnlineWrapper _online;
  final Collection _collection;
  final ItemRecordFactory<TRecord> _factory;
  final ItemManager _itemManager;
  final ItemStore _store;
  final LateRef<SyncConfig> _config;

  late final ItemBackgroundSync _backgroundSync;

  @visibleForTesting
  Repository.forTesting(
    this._online,
    this._collection,
    this._factory,
    this._itemManager,
    this._store,
    this._config,
    this._backgroundSync,
  );

  @internal
  Repository.internal(
    this._online,
    this._collection,
    this._factory,
    this._itemManager,
    this._store,
    this._config,
  ) {
    // TODO recreate background sync when config changes
    _backgroundSync = ItemBackgroundSync.forMode(
      _online,
      _store,
      _itemManager,
      this,
      _collection.uid,
      // TODO fix this
      SyncLogger(Logger('etebase_sync.repository.${_collection.uid}'), 'item'),
      _config.current.syncMode,
    );
  }

  String get uid => _collection.uid;

  bool get isReadOnly =>
      _collection.accessLevel == CollectionAccessLevel.readOnly;

  Future<void> init() async {
    await _backgroundSync.init();
  }

  Future<void> dispose() async {
    await _backgroundSync.dispose();
    _itemManager.dispose();
    _collection.dispose();
  }

  Future<void> sync() async => await _backgroundSync.sync();

  Stream<String> list({bool sync = false}) async* {
    if (sync) {
      await _backgroundSync.sync();
    }

    yield* _store.listUids();
  }

  Future<Map<String, ItemMetadata>> listMeta({bool sync = false}) async {
    if (sync) {
      await _backgroundSync.sync();
    }

    final entryStream = _store
        .listUids()
        .asyncMap(_store.getItem)
        .whereNotNull()
        .asyncMap((item) async {
          final uid = item.uid;
          final meta = item.isDeleted ? null : await item.getMeta();
          item.dispose();
          return meta != null ? (uid, meta) : null;
        })
        .whereNotNull();

    return {await for (final (uid, meta) in entryStream) uid: meta};
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
    final item = await _store.getItem(uid);
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
    bool allowDeleted = false,
    RecordState? forceState,
  }) async {
    try {
      if (!allowDeleted && item.isDeleted) {
        throw ItemDeleted(item.uid);
      }

      final record = _factory(this, item);
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
      record._state = RecordState.locked;

      // load from cache
      final cacheItem = await _store.getItem(record.uid);
      if (cacheItem == null || cacheItem.isDeleted) {
        cacheItem?.dispose();
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
      record._state = RecordState.locked;
      await _saveToCache(record);

      if (_config.current.waitForUpload) {
        await _backgroundSync.waitForSync(record.uid);
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

    final result = await _store.saveLocal(
      record._item,
      expectedEtag: record._cacheEtag,
    );
    switch (result) {
      case SaveOk(:final etag):
        record._cacheEtag = etag;
        return etag;
      case SaveConflict(:final cacheItem):
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
      allowDeleted: true,
      forceState: RecordState.conflictResolving,
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
