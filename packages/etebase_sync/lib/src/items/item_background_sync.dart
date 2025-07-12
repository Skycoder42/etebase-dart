part of 'items.dart';

@internal
abstract base class ItemBackgroundSync
    extends BackgroundSync<Item, ItemListResponse<Item>, ItemStore> {
  final ItemManager _itemManager;
  final Repository _repository;
  final String _colUid;

  ItemBackgroundSync(
    super.online,
    super.store,
    this._itemManager,
    this._repository,
    this._colUid,
    super.logger,
  );

  factory ItemBackgroundSync.forMode(
    OnlineWrapper online,
    ItemStore store,
    ItemManager itemManager,
    Repository repository,
    String colUid,
    SyncLogger logger,
    SyncMode syncMode,
  ) => switch (syncMode) {
    SyncModeManual() => _ManualBackgroundSync(
      online,
      store,
      itemManager,
      repository,
      colUid,
      logger,
    ),
    SyncModePeriodic(:final period, :final fireImmediately) =>
      _PeriodicBackgroundSync(
        online,
        store,
        itemManager,
        repository,
        colUid,
        logger,
        period: period,
        fireImmediately: fireImmediately,
      ),
    SyncModeLive() => _LiveBackgroundSync(
      online,
      store,
      itemManager,
      repository,
      colUid,
      logger,
    ),
  };

  Future<void> sync();

  @override
  bool shouldSkip(Item item) => item.uid == _colUid;

  @override
  Future<void> updateStoken(ItemListResponse<Item> response) async =>
      await store.saveStoken(response.stoken);

  @override
  Future<void> upload(Item item) async =>
      await _itemManager.transaction([item]);

  @override
  Future<Item> download(String uid) async => await _itemManager.fetch(uid);

  @override
  Future<void> resolveConflict(
    Item target,
    Item conflicted,
    ConflictOrigin origin,
  ) async {
    final targetRecord = await _repository._createRecord(
      target,
      allowDeleted: true,
      forceState: RecordState.conflictResolving,
    );
    final conflictedRecord = await _repository._createRecord(
      conflicted,
      allowDeleted: true,
      forceState: RecordState.locked,
    );
    try {
      await targetRecord.resolveConflict(conflictedRecord, origin);
    } finally {
      // only detach, items are disposed by caller as needed
      targetRecord._detach();
      conflictedRecord._detach();
    }
  }
}

abstract base class _PullBasedBackgroundSync extends ItemBackgroundSync {
  _PullBasedBackgroundSync(
    super.online,
    super.store,
    super._itemManager,
    super._repository,
    super._colUid,
    super.logger,
  );

  Stream<ItemListResponse<Item>> _fetchUpdates(String? stoken) {
    ItemListResponse<Item>? response;
    return online.streamOnline<ItemListResponse<Item>>(
      () async* {
        do {
          logger.downloadFetching(stoken);
          response = await _itemManager.list(
            ItemFetchOptions(
              stoken: response?.stoken ?? stoken,
              withCollection: false,
            ),
          );
          yield response!;
        } while (!response!.isDone);
      },
      whenOffline: () {
        logger.downloadOffline();
        return ItemListResponse(
          data: const [],
          stoken: response?.stoken ?? stoken,
          isDone: true,
        );
      },
    );
  }
}

final class _ManualBackgroundSync extends _PullBasedBackgroundSync {
  final _controller = StreamController<String?>();

  _ManualBackgroundSync(
    super.online,
    super.store,
    super._itemManager,
    super._repository,
    super._colUid,
    super.logger,
  );

  @override
  Future<void> dispose() async =>
      await Future.wait([super.dispose(), _controller.close()]);

  @override
  Future<void> sync() async {
    if (!isDownSyncActive) {
      logger.downloadTriggered('Manual sync');
      _controller.add(await store.getStoken());
    }

    await syncEvents.whereType<SyncDownloadFinishedEvent>().first;
  }

  @override
  Stream<ItemListResponse<Item>> streamRemote() =>
      _controller.stream.asyncExpand(_fetchUpdates);
}

final class _PeriodicBackgroundSync extends _PullBasedBackgroundSync {
  final Duration period;
  final bool fireImmediately;

  final _controller = StreamController<String?>();

  _PeriodicBackgroundSync(
    super.online,
    super.store,
    super._itemManager,
    super._repository,
    super._colUid,
    super.logger, {
    required this.period,
    required this.fireImmediately,
  });

  @override
  Future<void> dispose() async =>
      await Future.wait([super.dispose(), _controller.close()]);

  @override
  Future<void> sync() async {
    if (!isDownSyncActive) {
      logger.downloadTriggered('Manual sync');
      _controller.add(await store.getStoken());
    }

    await syncEvents.whereType<SyncDownloadFinishedEvent>().first;
  }

  @override
  Stream<ItemListResponse<Item>> streamRemote() {
    if (fireImmediately) {
      logger.downloadTriggered('Periodic timer trigger');
    }

    return MergeStream([
      // periodic sync
      Stream<void>.periodic(period).asyncMap((_) {
        logger.downloadTriggered('Periodic timer trigger');
        return store.getStoken();
      }),
      if (fireImmediately)
        // initial sync, as periodic only emits after the first period expired
        Stream.fromFuture(store.getStoken()),
      // manual sync
      _controller.stream,
    ]).asyncExpand(_fetchUpdates);
  }
}

final class _LiveBackgroundSync extends ItemBackgroundSync {
  Completer<bool>? _syncBlocker;

  _LiveBackgroundSync(
    super.online,
    super.store,
    super._itemManager,
    super._repository,
    super._colUid,
    super.logger,
  );

  @override
  Future<void> dispose() async {
    final completer = _syncBlocker ??= Completer<bool>();
    if (!completer.isCompleted) {
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
    } else if (!isDownSyncActive) {
      return;
    }

    if (await online.isOnline) {
      await syncEvents.whereType<SyncDownloadFinishedEvent>().first;
    }
  }

  @override
  Stream<ItemListResponse<Item>> streamRemote() async* {
    while ((await _syncBlocker?.future) ?? true) {
      logger.downloadWaiting();
      await online.waitForOnline();

      logger.downloadTriggered('Live sync (re)start');
      yield* online
          .streamOnline(() async* {
            final stoken = await store.getStoken();
            logger.downloadSyncing(stoken);
            yield* _itemManager.subscribeChanges(
              ItemFetchOptions(stoken: stoken, withCollection: false),
            );
          })
          // Blocks the automatic resumption of syncs until manually unblocked
          .doOnError((_, _) => _syncBlocker ??= Completer());
    }
  }
}
