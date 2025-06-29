part of 'items.dart';

abstract base class BackgroundSync {
  final EtebaseSyncImpl _sync;
  final ItemManager _itemManager;
  final CacheView<Item> _cache;
  final Repository _repository;

  final _syncLock = Lock();
  final _syncedController = StreamController<SyncEvent>.broadcast(sync: true);

  late final StreamSubscription<SyncEvent> _cacheSub;

  BackgroundSync(this._cache, this._sync, this._itemManager, this._repository);

  Stream<SyncEvent> get syncEvents => _syncedController.stream;

  Future<void> sync();

  Future<void> init() async {
    _cacheSub = _cache
        .stream()
        .asyncMap(_handleUpload)
        .whereNotNull()
        .listen(
          _syncedController.add,
          onError: _handleError,
          // TODO handle onDone
          cancelOnError: false,
        );
  }

  Future<void> dispose() async {
    await _cacheSub.cancel();
    await _syncedController.close();
  }

  Future<SyncEvent?> _handleUpload(String uid) => _syncLock.synchronized(
    () => _sync.runOnline(() async {
      final item = await _cache.getForUpload(uid);
      if (item == null) {
        return null;
      }

      try {
        await _itemManager.transaction([item]);
        final remoteEtag = item.etag;
        final result = await _cache.saveUploaded(item);
        final savedEtag = await _handleSaveResult(item, remoteEtag, result);
        return _createEvent(
          uid: uid,
          remoteEtag: remoteEtag,
          cacheEtag: savedEtag,
        );
      } on Conflict {
        final remoteItem = await _itemManager.fetch(item.uid);
        final remoteEtag = item.etag;
        final resolvedEtag = await _resolveUploadConflict(
          remote: remoteItem,
          cache: item,
          remoteEtag: remoteEtag,
          origin: ConflictOrigin.server,
        );
        return _createEvent(
          uid: uid,
          remoteEtag: remoteEtag,
          cacheEtag: resolvedEtag,
        );
      } finally {
        // disposing items multiple times is save, so dispose even
        // if already disposed by conflict handling
        item.dispose();
      }
    }, whenOffline: () => SyncEvent.offline(uid)),
  );

  Future<String> _handleSaveResult(
    Item item,
    String remoteEtag,
    SaveResult<Item> result,
  ) async => switch (result) {
    SaveOk(:final etag) => etag,
    SaveDeleted() => throw ItemDeleted(item.uid),
    SaveConflict(:final cacheItem) => await _resolveUploadConflict(
      remote: item,
      cache: cacheItem,
      remoteEtag: remoteEtag,
      origin: ConflictOrigin.cache,
    ),
  };

  Future<String> _resolveUploadConflict({
    required Item remote,
    required Item cache,
    required String remoteEtag,
    required ConflictOrigin origin,
  }) async {
    final remoteRecord = await _repository._createRecord(
      remote,
      forceState: _RecordState.conflictResolving,
    );
    final cacheRecord = await _repository._createRecord(
      remote,
      forceState: _RecordState.locked,
    );
    try {
      await remoteRecord.resolveConflict(cacheRecord, origin);
      final result = await _cache.saveLocal(
        remoteRecord._item,
        expectedEtag: cacheRecord._cacheEtag,
        remoteEtag: remoteEtag,
      );
      return await _handleSaveResult(remoteRecord._item, remoteEtag, result);
    } finally {
      remoteRecord.dispose();
      cacheRecord.dispose();
    }
  }

  /// Only creates an event, if [remoteEtag] and [cacheEtag] are identical.
  ///
  /// This is because if they are identical, the remote version has been saved
  /// to the cache as is (and thus will not trigger another upload). So, the
  /// sync for that item is done and we can emit an event.
  ///
  /// If the etags are different however, this means that the item was modified
  /// before being saved to the cache and thus another upload for that modified
  /// version will be triggered. Only after that modified version was uploaded
  /// we are done. Thus, no event for this upload.
  SyncEvent? _createEvent({
    required String uid,
    required String remoteEtag,
    required String cacheEtag,
  }) {
    if (cacheEtag == remoteEtag) {
      return SyncEvent.uploaded(uid, cacheEtag);
    } else {
      return null;
    }
  }

  void _handleError(Object error, StackTrace stackTrace) {
    if (_syncedController.hasListener) {
      _syncedController.addError(error, stackTrace);
    } else {
      Zone.current.handleUncaughtError(error, stackTrace);
    }
  }
}

abstract base class ManualBackgroundSync extends BackgroundSync {}

abstract base class PeriodicBackgroundSync extends BackgroundSync {}

abstract base class LiveBackgroundSync extends BackgroundSync {}
