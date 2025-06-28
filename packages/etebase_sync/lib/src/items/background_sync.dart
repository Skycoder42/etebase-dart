part of 'items.dart';

abstract base class BackgroundSync {
  final EtebaseSyncImpl _sync;
  final ItemManager _itemManager;
  final CacheView<Item> _cache;

  late final StreamSubscription<bool> _cacheSub;

  BackgroundSync(this._cache, this._sync, this._itemManager);

  Future<void> sync();

  Future<void> init() async {
    // TODO result/error handling
    _cacheSub = _cache.stream().asyncMap(_handleUpload).listen(null);
  }

  Future<void> dispose();

  Future<bool> _handleUpload(Item item) async =>
      await _sync.runOnline(() async {
        try {
          await _itemManager.transaction([item]);

          final result = await _cache.saveUploaded(item);
          switch (result) {
            case SaveOk():
              return true;
            case SaveDeleted():
              throw ItemDeleted(item.uid);
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
        } on Conflict {}
      });
}

abstract base class ManualBackgroundSync extends BackgroundSync {}

abstract base class PeriodicBackgroundSync extends BackgroundSync {}

abstract base class LiveBackgroundSync extends BackgroundSync {}
