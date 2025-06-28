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
        .where((i) => i.$2.localEtag != i.remoteEtag)
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

  Future<SyncEvent?> _handleUpload(ItemInfo itemInfo) => _syncLock.synchronized(
    () => _sync.runOnline(() async {
      final item = _itemManager.cacheLoad(itemInfo.data);
      try {
        await _itemManager.transaction([item]);

        final result = await _cache.saveUploaded(item);
        switch (result) {
          case SaveOk(:final etag):
            return SyncEvent.uploaded(item.uid, etag);
          case SaveDeleted():
            throw ItemDeleted(item.uid);
          case SaveConflict(:final cacheItem):
            await _repository._resolveConflict2(
              primary: item,
              conflict: cacheItem,
              cacheEtag: cacheItem.etag,
              origin: ConflictOrigin.cache,
            );
            return null;
        }
      } on Conflict {
        final remoteItem = await _itemManager.fetch(item.uid);
        await _repository._resolveConflict2(
          primary: remoteItem,
          conflict: item,
          cacheEtag: item.etag,
          origin: ConflictOrigin.server,
        );
        return null;
      } finally {
        // disposing items multiple times is save, so dispose even
        // if already disposed by conflict handling
        item.dispose();
      }
    }, whenOffline: () => SyncEvent.offline(itemInfo)),
  );

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
