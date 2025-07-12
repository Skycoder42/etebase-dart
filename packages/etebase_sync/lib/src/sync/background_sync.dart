import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

import '../exceptions/conflict_origin.dart';
import '../exceptions/item_deleted.dart';
import '../logging/sync_logger.dart';
import '../online/online_wrapper.dart';
import '../storage/save_result.dart';
import '../storage/store.dart';
import 'sync_event.dart';

// TODO error handling

@internal
abstract base class BackgroundSync<
  TItem extends Item,
  TResponse extends ListResponse<TItem>,
  TStore extends Store<TItem>
> {
  @protected
  final OnlineWrapper online;
  @protected
  final TStore store;
  @protected
  final SyncLogger logger;

  final _syncLock = Lock();
  final _syncedController = StreamController<SyncEvent>.broadcast(sync: true);

  late final StreamSubscription<void> _cacheSub;
  late final StreamSubscription<void> _remoteSub;

  var _downSyncActive = false;

  @protected
  bool get isDownSyncActive => _downSyncActive;

  BackgroundSync(this.online, this.store, this.logger);

  Stream<SyncEvent> get syncEvents => _syncedController.stream;

  Future<void> waitForSync(String uid) =>
      syncEvents.firstWhere((e) => e.uid == uid);

  @mustCallSuper
  Future<void> init() async {
    _cacheSub = store
        .streamModified()
        // delay ensure that events are processed after whatever triggered them
        // finishes processing
        .interval(const Duration(milliseconds: 1))
        .mergeWith([_pendingUploadsAfterReconnect()])
        .asyncMap(_handleUpload)
        .whereNotNull()
        .listen(
          _syncedController.add,
          onError: (Object e, StackTrace s) => _handleError('upload', e, s),
          // TODO handle onDone
          cancelOnError: false,
        );

    _remoteSub = streamRemote()
        .asyncExpand(_handleResponse)
        .listen(
          _syncedController.add,
          onError: (Object e, StackTrace s) => _handleError('download', e, s),
          // TODO handle onDone
          cancelOnError: false,
        );
  }

  @mustCallSuper
  Future<void> dispose() async {
    await _remoteSub.cancel();
    await _cacheSub.cancel();
    // do not await, as for broadcast streams it may never complete
    unawaited(_syncedController.close());
  }

  @visibleForOverriding
  Stream<TResponse> streamRemote();

  @visibleForOverriding
  bool shouldSkip(TItem item) => false;

  @visibleForOverriding
  Future<void> updateStoken(TResponse response);

  @visibleForOverriding
  String? scopeFor(TResponse response) => null;

  @visibleForOverriding
  Future<void> upload(TItem item);

  @visibleForOverriding
  Future<TItem> download(String uid);

  @visibleForOverriding
  Future<void> resolveConflict(
    TItem target,
    TItem conflicted,
    ConflictOrigin origin,
  );

  Stream<String> _pendingUploadsAfterReconnect() => online.stream
      .distinct()
      .where((e) => e.isOnline)
      .expand((_) => store.getPendingUploads());

  Future<SyncEvent?> _handleUpload(String uid) => _syncLock.synchronized(
    () => online.runOnline(
      () async {
        final item = await store.getItem(uid, forUpload: true);
        if (item == null) {
          logger.uploadSkipped(uid);
          return null;
        }

        try {
          final remoteEtag = item.etag;
          logger.uploadStarted(uid, remoteEtag);
          await upload(item);
          logger.uploadAccepted(uid, remoteEtag);
          final result = await store.saveUploaded(item);
          final savedEtag = await _handleSaveResult(item, remoteEtag, result);
          return _createEvent(
            uid: uid,
            remoteEtag: remoteEtag,
            cacheEtag: savedEtag,
          );
        } on Conflict {
          logger.downloadItem(uid);
          final remoteItem = await download(uid);
          final remoteEtag = remoteItem.etag;
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
      },
      whenOffline: () {
        logger.uploadOffline(uid);
        return SyncEvent.offline(uid);
      },
    ),
  );

  Stream<SyncEvent> _handleResponse(TResponse response) async* {
    if (!_downSyncActive) {
      _downSyncActive = true;
      yield SyncEvent.downloadStarted(scopeFor(response));
    }

    logger.downloadResponse(response, scopeFor(response));
    for (final item in response.data) {
      try {
        if (shouldSkip(item)) {
          logger.downloadSkipped(item.uid);
          continue;
        }

        yield await _syncLock.synchronized(() async {
          final result = await store.saveRemote(item);
          final savedEtag = await _handleSaveResult(item, item.etag, result);
          return SyncEvent.downloaded(item.uid, savedEtag);
        });

        // ignore: avoid_catches_without_on_clauses
      } catch (e, s) {
        // workaround, as one cannot yield multiple exceptions from an async*
        _handleError('download', e, s);
      } finally {
        item.dispose();
      }
    }

    await updateStoken(response);

    if (response.isDone) {
      _downSyncActive = false;
      yield SyncEvent.downloadFinished(scopeFor(response));
    }
  }

  Future<String> _handleSaveResult(
    TItem item,
    String remoteEtag,
    SaveResult<TItem> result,
  ) async {
    switch (result) {
      case SaveOk(:final etag, :final action):
        logger.saved(item.uid, action, cacheEtag: etag, remoteEtag: remoteEtag);
        return etag;
      case SaveConflict(:final cacheItem):
        return await _resolveConflict(
          remote: item,
          cache: cacheItem,
          remoteEtag: remoteEtag,
          origin: ConflictOrigin.cache,
        );
    }
  }

  Future<String> _resolveConflict({
    required TItem remote,
    required TItem cache,
    required String remoteEtag,
    required ConflictOrigin origin,
  }) async {
    try {
      final cacheEtag = cache.etag;
      logger.conflict(
        remote.uid,
        cacheEtag: cacheEtag,
        remoteEtag: remoteEtag,
        itemEtag: remote.etag,
      );
      await resolveConflict(remote, cache, origin);
      final result = await store.saveLocal(
        remote,
        expectedEtag: cacheEtag,
        remoteEtag: remoteEtag,
      );
      return await _handleSaveResult(remote, remoteEtag, result);
    } on ItemDeleted {
      /// more or less ignore this case, as because of locking it should be
      /// impossible. If it does happen, return the [remoteEtag]. This will
      /// always trigger a [SyncEvent.uploaded] event, which is what we want,
      /// as the item was resolved somewhere else and thus we are done here.
      return remoteEtag;
    } finally {
      remote.dispose();
      cache.dispose();
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

  void _handleError(String context, Object error, StackTrace stackTrace) {
    logger.error(context, error, stackTrace);

    if (_syncedController.hasListener) {
      _syncedController.addError(error, stackTrace);
    }
  }
}
