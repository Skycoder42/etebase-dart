part of 'items.dart';

@internal
abstract base class ItemBackgroundSync extends BackgroundSync<Item> {
  final ItemManager _itemManager;
  final Repository _repository;

  ItemBackgroundSync(
    super.etebaseSync,
    super.store,
    this._itemManager,
    this._repository,
  );

  factory ItemBackgroundSync.forMode(
    EtebaseSyncImpl sync,
    ItemStore store,
    ItemManager itemManager,
    Repository repository,
    SyncMode syncMode,
  ) => switch (syncMode) {
    SyncModeManual() => _ManualBackgroundSync(
      sync,
      store,
      itemManager,
      repository,
    ),
    SyncModePeriodic(:final period, :final fireImmediately) =>
      _PeriodicBackgroundSync(
        sync,
        store,
        itemManager,
        repository,
        period: period,
        fireImmediately: fireImmediately,
      ),
    SyncModeLive() => _LiveBackgroundSync(sync, store, itemManager, repository),
  };

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
      forceState: RecordState.conflictResolving,
    );
    final conflictedRecord = await _repository._createRecord(
      conflicted,
      forceState: RecordState.locked,
    );
    try {
      await targetRecord.resolveConflict(conflictedRecord, origin);
    } finally {
      // only detach, items are disposed by caller
      targetRecord._detach();
      conflictedRecord._detach();
    }
  }
}

abstract base class _PullBasedBackgroundSync extends ItemBackgroundSync {
  _PullBasedBackgroundSync(
    super.etebaseSync,
    super.store,
    super._itemManager,
    super._repository,
  );

  Stream<ItemListResponse<Item>> _fetchUpdates(String? stoken) {
    ItemListResponse<Item>? response;
    return etebaseSync.streamOnline<ItemListResponse<Item>>(
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
    super.etebaseSync,
    super.store,
    super._itemManager,
    super._repository,
  );

  @override
  Future<void> dispose() async =>
      await Future.wait([super.dispose(), _controller.close()]);

  @override
  Future<void> sync() async {
    if (!isDownSyncActive) {
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
    super.etebaseSync,
    super.store,
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
    if (!isDownSyncActive) {
      _controller.add(await store.getStoken());
    }

    await syncEvents.whereType<SyncDownloadFinishedEvent>().first;
  }

  @override
  Stream<ItemListResponse<Item>> streamRemote() => MergeStream([
    // periodic sync
    Stream<void>.periodic(period).asyncMap((_) => store.getStoken()),
    if (fireImmediately)
      // initial sync, as periodic only emits after the first period expired
      Stream.fromFuture(store.getStoken()),
    // manual sync
    _controller.stream,
  ]).asyncExpand(_fetchUpdates);
}

final class _LiveBackgroundSync extends ItemBackgroundSync {
  Completer<bool>? _syncBlocker;

  _LiveBackgroundSync(
    super.etebaseSync,
    super.store,
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
    } else if (!isDownSyncActive) {
      return;
    }

    if (etebaseSync.isOnline) {
      await syncEvents.whereType<SyncDownloadFinishedEvent>().first;
    }
  }

  @override
  Stream<ItemListResponse<Item>> streamRemote() async* {
    while ((await _syncBlocker?.future) ?? true) {
      await etebaseSync.waitForOnline();

      yield* etebaseSync
          .streamOnline(() async* {
            final stoken = await store.getStoken();
            yield* _itemManager.subscribeChanges(
              ItemFetchOptions(stoken: stoken, withCollection: false),
            );
          })
          // Blocks the automatic resumption of syncs until manually unblocked
          .doOnError((_, _) => _syncBlocker ??= Completer());
    }
  }
}
