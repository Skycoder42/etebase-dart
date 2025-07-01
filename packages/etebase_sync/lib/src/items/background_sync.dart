part of 'items.dart';

abstract base class BackgroundSync {
  final EtebaseSyncImpl _sync;
  final ItemManager _itemManager;
  final ItemStore _store;
  final Repository _repository;

  final _syncLock = Lock();
  final _syncedController = StreamController<SyncEvent>.broadcast(sync: true);

  late final StreamSubscription<void> _cacheSub;
  late final StreamSubscription<void> _remoteSub;

  var _downSyncActive = false;

  BackgroundSync(this._store, this._sync, this._itemManager, this._repository);

  factory BackgroundSync.forMode(
    ItemStore store,
    EtebaseSyncImpl sync,
    ItemManager itemManager,
    Repository repository,
    SyncMode syncMode,
  ) => switch (syncMode) {
    SyncModeManual() => _ManualBackgroundSync(
      store,
      sync,
      itemManager,
      repository,
    ),
    SyncModePeriodic(:final period, :final fireImmediately) =>
      _PeriodicBackgroundSync(
        store,
        sync,
        itemManager,
        repository,
        period: period,
        fireImmediately: fireImmediately,
      ),
    SyncModeLive() => _LiveBackgroundSync(store, sync, itemManager, repository),
  };

  Stream<SyncEvent> get syncEvents => _syncedController.stream;

  @mustCallSuper
  Future<void> init() async {
    _cacheSub = _store
        .stream()
        .asyncMap(_handleUpload)
        .whereNotNull()
        .listen(
          _syncedController.add,
          onError: _handleError,
          // TODO handle onDone
          cancelOnError: false,
        );

    _cacheSub = _streamRemote()
        .asyncExpand(_handleResponse)
        .listen(
          _syncedController.add,
          onError: _handleError,
          // TODO handle onDone
          cancelOnError: false,
        );
  }

  @mustCallSuper
  Future<void> dispose() async {
    await Future.wait([
      _remoteSub.cancel(),
      _cacheSub.cancel(),
      _syncedController.close(),
    ]);
  }

  Future<void> sync();

  Stream<ItemListResponse<Item>> _streamRemote();

  Future<SyncEvent?> _handleUpload(String uid) => _syncLock.synchronized(
    () => _sync.runOnline(() async {
      final item = await _store.getItem(uid, forUpload: true);
      if (item == null) {
        return null;
      }

      try {
        await _itemManager.transaction([item]);
        final remoteEtag = item.etag;
        final result = await _store.saveUploaded(item);
        final savedEtag = await _handleSaveResult(item, remoteEtag, result);
        return _createEvent(
          uid: uid,
          remoteEtag: remoteEtag,
          cacheEtag: savedEtag,
        );
      } on Conflict {
        final remoteItem = await _itemManager.fetch(item.uid);
        final remoteEtag = item.etag;
        final resolvedEtag = await _resolveConflict(
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
    SaveResult result,
  ) async => switch (result) {
    SaveOk(:final etag) => etag,
    SaveDeleted() => throw ItemDeleted(item.uid),
    SaveConflict(:final cacheItem) => await _resolveConflict(
      remote: item,
      cache: cacheItem,
      remoteEtag: remoteEtag,
      origin: ConflictOrigin.cache,
    ),
  };

  Future<String> _resolveConflict({
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
      final result = await _store.saveLocal(
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

  Stream<SyncEvent> _handleResponse(ItemListResponse<Item> response) async* {
    if (!_downSyncActive) {
      _downSyncActive = true;
      yield const SyncEvent.downloadStarted();
    }

    for (final item in response.data) {
      try {
        yield await _syncLock.synchronized(() async {
          final result = await _store.saveRemote(item);
          final savedEtag = await _handleSaveResult(item, item.etag, result);
          return SyncEvent.downloaded(item.uid, savedEtag);
        });

        // ignore: avoid_catches_without_on_clauses
      } catch (e, s) {
        // workaround, as one cannot yield multiple exceptions from an async*
        _handleError(e, s);
      }
    }

    await _store.saveStoken(response.stoken);

    if (response.isDone) {
      _downSyncActive = false;
      yield const SyncEvent.downloadFinished();
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

abstract base class _PullBasedBackgroundSync extends BackgroundSync {
  _PullBasedBackgroundSync(
    super._cache,
    super._sync,
    super._itemManager,
    super._repository,
  );

  Stream<ItemListResponse<Item>> _fetchUpdates(String? stoken) {
    ItemListResponse<Item>? response;
    return _sync.streamOnline<ItemListResponse<Item>>(
      () async* {
        do {
          response = await _itemManager.list(
            ItemFetchOptions(
              stoken: response?.stoken ?? stoken,
              withCollection: false,
            ),
          );
          yield response!;
        } while (!response!.isDone);
      },
      whenOffline: () => Stream.value(
        ItemListResponse(
          data: const [],
          stoken: response?.stoken ?? stoken,
          isDone: true,
        ),
      ),
    );
  }
}

final class _ManualBackgroundSync extends _PullBasedBackgroundSync {
  final _controller = StreamController<String?>();

  _ManualBackgroundSync(
    super._cache,
    super._sync,
    super._itemManager,
    super._repository,
  );

  @override
  Future<void> dispose() async =>
      await Future.wait([super.dispose(), _controller.close()]);

  @override
  Future<void> sync() async {
    if (!_downSyncActive) {
      _controller.add(_store.getStoken());
    }

    await syncEvents.whereType<SyncDownloadFinishedEvent>().first;
  }

  @override
  Stream<ItemListResponse<Item>> _streamRemote() =>
      _controller.stream.asyncExpand(_fetchUpdates);
}

final class _PeriodicBackgroundSync extends _PullBasedBackgroundSync {
  final Duration period;
  final bool fireImmediately;

  final _controller = StreamController<String?>();

  _PeriodicBackgroundSync(
    super._cache,
    super._sync,
    super._itemManager,
    super._repository, {
    required this.period,
    required this.fireImmediately,
  });

  @override
  Future<void> dispose() async =>
      await Future.wait([super.dispose(), _controller.close()]);

  @override
  Future<void> sync() async {
    if (!_downSyncActive) {
      _controller.add(_store.getStoken());
    }

    await syncEvents.whereType<SyncDownloadFinishedEvent>().first;
  }

  @override
  Stream<ItemListResponse<Item>> _streamRemote() => MergeStream([
    // periodic sync
    Stream<String?>.periodic(period, (_) => _store.getStoken()),
    if (fireImmediately)
      // initial sync, as periodic only emits after the first period expired
      Stream.value(_store.getStoken()),
    // manual sync
    _controller.stream,
  ]).asyncExpand(_fetchUpdates);
}

final class _LiveBackgroundSync extends BackgroundSync {
  Completer<bool>? _syncBlocker;

  _LiveBackgroundSync(
    super._cache,
    super._sync,
    super._itemManager,
    super._repository,
  );

  @override
  Future<void> dispose() async {
    if (_syncBlocker case final Completer<bool> completer
        when !completer.isCompleted) {
      completer.complete(false);
    }

    await super.dispose();
  }

  @override
  Future<void> sync() async {
    if (_syncBlocker case final Completer<bool> syncBlocker) {
      _syncBlocker = null;
      if (!syncBlocker.isCompleted) {
        syncBlocker.complete(true);
      }
    } else if (!_downSyncActive) {
      return;
    }

    if (_sync.isOnline) {
      await syncEvents.whereType<SyncDownloadFinishedEvent>().first;
    }
  }

  @override
  Stream<ItemListResponse<Item>> _streamRemote() async* {
    while ((await _syncBlocker?.future) ?? true) {
      await _sync.waitForOnline();

      yield* _sync
          .streamOnline(() async* {
            final stoken = _store.getStoken();
            yield* _itemManager.subscribeChanges(
              ItemFetchOptions(stoken: stoken, withCollection: false),
            );
          })
          // Blocks the automatic resumption of syncs until manually unblocked
          .doOnError((_, _) => _syncBlocker ??= Completer());
    }
  }
}
