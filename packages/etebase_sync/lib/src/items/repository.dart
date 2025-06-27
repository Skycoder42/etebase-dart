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

  Future<void> _refresh(TRecord record, bool? download) async {
    final withDownload =
        download ??
        switch (_sync.config.syncMode) {
          SyncMode.explicit => false,
          SyncMode.implicit => true,
          SyncMode.automatic => throw UnimplementedError(),
        };

    final recordState = record._state;
    try {
      record._state = _RecordState.locked;

      // load from cache
      final cacheItem = await _cacheView.getItem(record.uid);
      if (cacheItem == null) {
        throw ItemDeleted(record.uid);
      }

      // fetch latest version if enabled
      if (withDownload && await _download(record, cacheItem)) {
        return;
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

  Future<bool> _download(TRecord record, Item cacheItem) async {
    // TODO always dispose cacheItem
    final remoteItem = await _sync.runOnline(() async {
      final result = await _itemManager.fetchUpdates([cacheItem]);
      return switch (result) {
        ItemListResponse(data: [], isDone: true) => null,
        ItemListResponse(data: [final update], isDone: true) => update,
        _ => await _itemManager.fetch(record.uid),
      };
    });

    if (remoteItem == null) {
      return false;
    }

    final result = await _cacheView.saveRemote(remoteItem);
    switch (result) {
      case SaveOk(:final etag):
        await _updateRecordTo(record, etag, [cacheItem, remoteItem]);
      case SaveDeleted():
        throw ItemDeleted(record.uid);
      case SaveConflict(:final cacheItem):
        final cacheRecord = await _createRecord(
          cacheItem,
          forceState: _RecordState.locked,
        );
        final remoteRecord = await _createRecord(
          remoteItem,
          forceState: _RecordState.conflictResolving,
        );

        try {
          await remoteRecord.resolveConflict(cacheRecord, ConflictOrigin.cache);
          await record._updateItem(remoteItem, cacheItem.etag);
          await _persist(record, true);
        } catch (_) {
          remoteRecord.dispose();
          rethrow;
        } finally {
          cacheRecord.dispose();
        }
    }

    return true;
  }

  Future<void> _updateRecordTo(
    TRecord record,
    String etag,
    List<Item> items,
  ) async {
    if (record.etag == etag) {
      _disposeAll(items);
      record._cacheEtag = etag;
      return;
    }

    final matching = items.where((i) => i.etag == etag).firstOrNull;
    if (matching != null) {
      _disposeAll(items.where((i) => i != matching));
      await record._updateItem(matching, etag);
      return;
    }

    final cacheItem = await _cacheView.getItem(record.uid);
    if (cacheItem == null) {
      throw ItemDeleted(record.uid);
    }
    await record._updateItem(cacheItem, cacheItem.etag);
  }

  void _disposeAll(Iterable<Item> items) {
    for (final item in items) {
      item.dispose();
    }
  }

  Future<void> _persist(TRecord record, bool? upload) async {
    // If etag has not changed, item was not modified -> no need to save
    if (record._item.etag == record._cacheEtag) {
      return;
    }

    final withUpload =
        upload ??
        switch (_sync.config.syncMode) {
          SyncMode.explicit => false,
          SyncMode.implicit || SyncMode.automatic => true,
        };

    final recordState = record._state;
    try {
      record._state = _RecordState.locked;

      // Persist the modifications of record to the cache
      if (!await _saveToCache(record, withUpload)) {
        return;
      }

      // try upload
      if (withUpload) {
        await _upload(record);
      }
    } finally {
      record._state = recordState;
    }
  }

  Future<bool> _saveToCache(TRecord record, bool upload) async {
    final result = await _cacheView.saveLocal(record._item, record._cacheEtag);
    switch (result) {
      case SaveOk(:final etag):
        record._cacheEtag = etag;
        return true;
      case SaveDeleted():
        throw ItemDeleted(record.uid);
      case SaveConflict(:final cacheItem):
        // if cacheItem was deleted, _createRecord will throw, so no need to
        // handle this here
        await _resolveConflict(
          record,
          cacheItem,
          cacheItem.etag,
          ConflictOrigin.cache,
        );
        await _persist(record, upload);
        return false;
    }
  }

  Future<bool> _upload(TRecord record) async {
    final cacheEtag = record._cacheEtag;
    if (cacheEtag == null) {
      throw StateError(
        'Cannot upload a created record without caching it first',
      );
    }

    return await _sync.runOnline<bool>(() async {
      try {
        await _itemManager.transaction([record._item]);

        final result = await _cacheView.saveUploaded(record._item);
        switch (result) {
          case SaveOk():
            return true;
          case SaveDeleted():
            throw ItemDeleted(record.uid);
          case SaveConflict(:final cacheItem):
            final cacheRecord = await _createRecord(
              cacheItem,
              forceState: _RecordState.locked,
            );
            final currentState = record._state;
            try {
              record
                .._cacheEtag = cacheItem.etag
                .._state = _RecordState.conflictResolving;
              await record.resolveConflict(cacheRecord, ConflictOrigin.cache);
            } finally {
              record._state = currentState;
              cacheRecord.dispose();
            }

            // TODO PERSIST AS DOWNLOAD
            return false;
        }
      } on Conflict {
        final remoteItem = await _itemManager.fetch(record._item.uid);
        await _resolveConflict(
          record,
          remoteItem,
          cacheEtag,
          ConflictOrigin.server,
        );
        await _persist(record, true);
        return false;
      }
    }, whenOffline: () => false);
  }

  /// After resolution, the [target] will be updated to instead reference
  /// [canonicalItem] with a last known cache etag of [cacheEtag]. As part of
  /// the resolution, [canonicalItem] may be updated with changes from [target].
  Future<void> _resolveConflict(
    TRecord target,
    Item canonicalItem,
    String cacheEtag,
    ConflictOrigin origin,
  ) async {
    final canonical = await _createRecord(
      canonicalItem,
      forceState: _RecordState.conflictResolving,
    );

    try {
      await canonical.resolveConflict(target, origin);
    } catch (_) {
      canonical.dispose();
      rethrow;
    }

    await target._updateItem(canonicalItem, cacheEtag);
  }
}
