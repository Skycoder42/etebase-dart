part of 'items.dart';

class Repository<TRecord extends ItemRecord>
    with DisposeScope
    implements ScopeDisposable {
  final RepositoryManager _repoManager;
  final OnlineWrapper _online;
  final Collection _collection;
  final ItemRecordFactory<TRecord> _factory;
  final ItemManager _itemManager;
  final ItemStore _store;
  final SyncConfig _config;
  final ItemsLogger _logger;

  late final ItemBackgroundSync _backgroundSync;

  bool _destroyed = false;
  bool _removed = false;

  @visibleForTesting
  Repository.forTesting(
    this._repoManager,
    this._online,
    this._collection,
    this._factory,
    this._itemManager,
    this._store,
    this._config,
    this._backgroundSync,
    this._logger,
  );

  @internal
  Repository.internal(
    this._repoManager,
    this._online,
    this._collection,
    this._factory,
    this._itemManager,
    this._store,
    this._config,
    this._logger, {
    bool isRemoved = false,
  }) : _removed = isRemoved {
    if (_removed) {
      return;
    }

    _backgroundSync = ItemBackgroundSync.forMode(
      _online,
      _store,
      _itemManager,
      this,
      _collection.uid,
      _logger,
      _config.syncMode,
    );
  }

  String get uid => _collection.uid;

  bool get isReadOnly =>
      _collection.accessLevel == CollectionAccessLevel.readOnly ||
      _destroyed ||
      _removed;

  Stream<SyncEvent> get syncEvents => (_destroyed || _removed)
      ? Stream.error(
          _destroyed
              ? ItemDeleted(uid, EtebaseTarget.collection)
              : AccessRevoked(uid),
          StackTrace.current,
        )
      : _backgroundSync.syncEvents;

  Future<void> init() async {
    _repoManager.attach(this);
    if (!_removed) {
      await _backgroundSync.init();
    }
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    if (!_removed) {
      await _backgroundSync.dispose();
    }
    _itemManager.dispose();
    _collection.dispose();
    _repoManager.detach(this);
  }

  Future<void> sync() async {
    _checkCanSync();
    await _backgroundSync.sync();
  }

  Stream<String> list({bool sync = false}) async* {
    _checkAlive();
    if (sync) {
      await this.sync();
    }

    yield* _store.listUids();
  }

  Future<Map<String, ItemMetadata>> listMeta({bool sync = false}) async {
    _checkAlive();
    if (sync) {
      await this.sync();
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

    _logger.create();
    final item = await _itemManager.create(
      ItemMetadata(itemType: _collection.collectionType),
      Uint8List(0),
    );
    return await _createRecord(item, created: true);
  }

  Future<TRecord> open(String uid, {bool sync = false}) async {
    _checkAlive();
    if (sync) {
      await this.sync();
    }

    final item = await _store.getItem(uid);
    if (item == null) {
      throw CacheMiss(EtebaseTarget.item, uid, didSync: sync);
    }
    return await _createRecord(item);
  }

  Future<void> forceDelete(String uid) async {
    _checkCanSync();
    final item = await _itemManager.fetch(
      uid,
      const ItemFetchOptions(prefetch: PrefetchOption.medium),
    );
    try {
      if (item.isDeleted) {
        return;
      }

      await item.delete();
      await _itemManager.batch([item]);
    } finally {
      item.dispose();
    }
  }

  @internal
  Future<void> destroy() async {
    _destroyed = true;
    for (final record in findDisposables<ItemRecord>()) {
      record._state = RecordState.destroyed;
    }
    await dispose();
  }

  @internal
  Future<void> markRemoved() async {
    if (_removed || _destroyed) {
      return;
    }

    _removed = true;
    for (final record in findDisposables<ItemRecord>()) {
      record._state = RecordState.removed;
    }
    await _backgroundSync.dispose();
  }

  void _checkAlive() {
    if (_destroyed) {
      throw ItemDeleted(uid, EtebaseTarget.collection);
    }
  }

  void _checkCanSync() {
    _checkAlive();
    if (_removed) {
      throw AccessRevoked(uid);
    }
  }

  void _checkWritable() {
    _checkCanSync();
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
      } else if (_removed) {
        record._state = RecordState.removed;
      }
      return record;
    } catch (_) {
      item.dispose();
      rethrow;
    }
  }

  Future<bool> _refresh(TRecord record, bool sync) async {
    _checkAlive();
    if (sync) {
      await this.sync();
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
        return true;
      } else {
        cacheItem.dispose();
        return false;
      }
    } finally {
      _restoreRecordState(record, recordState);
    }
  }

  Future<void> _persist(TRecord record) async {
    _checkWritable();
    final recordState = record._state;
    try {
      record._state = RecordState.locked;
      _logger.persist(record.uid);
      await _saveToCache(record);

      if (_config.waitForUpload) {
        await _backgroundSync.waitForSync(record.uid);
      }
    } finally {
      _restoreRecordState(record, recordState);
    }
  }

  void _restoreRecordState(TRecord record, RecordState state) {
    if (_destroyed) {
      record._state = RecordState.destroyed;
    } else if (_removed) {
      record._state = RecordState.destroyed;
    } else {
      record._state = state;
    }
  }

  Future<String> _saveToCache(TRecord record) async {
    // If etag has not changed, item was not modified -> no need to save
    if (record._item.etag == record._cacheEtag) {
      _logger.saved(
        record.uid,
        SaveAction.unchanged,
        cacheEtag: record._item.etag,
      );
      return record._item.etag;
    }

    final result = await _store.saveLocal(
      record._item,
      expectedEtag: record._cacheEtag,
    );
    switch (result) {
      case SaveOk(:final etag, :final action):
        _logger.saved(record.uid, action, cacheEtag: etag);
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
  ///
  /// If [canonicalItem] is deleted ([Item.isDeleted]), an [ItemDeleted]
  /// exception will be thrown instead.
  Future<void> _resolveCacheConflict(
    TRecord target,
    Item canonicalItem,
    String cacheEtag,
  ) async {
    _logger.conflict(
      target.uid,
      cacheEtag: cacheEtag,
      itemEtag: target._item.etag,
    );
    final canonical = await _createRecord(
      canonicalItem,
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
