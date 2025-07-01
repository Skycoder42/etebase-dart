import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

import '../api/exceptions/item_deleted.dart';
import '../api/models/conflict_origin.dart';
import '../impl/etebase_sync_impl.dart';
import '../items/sync_event.dart';
import '../storage/item_store.dart';
import '../storage/save_result.dart';

@internal
abstract base class BackgroundSync<TItem extends Item> {
  @protected
  final EtebaseSyncImpl etebaseSync;
  @protected
  final ItemStore<TItem> store;

  final _syncLock = Lock();
  final _syncedController = StreamController<SyncEvent>.broadcast(sync: true);

  late final StreamSubscription<void> _cacheSub;
  late final StreamSubscription<void> _remoteSub;

  var _downSyncActive = false;

  @protected
  bool get isDownSyncActive => _downSyncActive;

  BackgroundSync(this.etebaseSync, this.store);

  Stream<SyncEvent> get syncEvents => _syncedController.stream;

  @mustCallSuper
  Future<void> init() async {
    _cacheSub = store
        .stream()
        .asyncMap(_handleUpload)
        .whereNotNull()
        .listen(
          _syncedController.add,
          onError: _handleError,
          // TODO handle onDone
          cancelOnError: false,
        );

    _cacheSub = streamRemote()
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

  @visibleForOverriding
  Stream<ItemListResponse<TItem>> streamRemote();

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

  Future<SyncEvent?> _handleUpload(String uid) => _syncLock.synchronized(
    () => etebaseSync.runOnline(() async {
      final item = await store.getItem(uid, forUpload: true);
      if (item == null) {
        return null;
      }

      try {
        await upload(item);
        final remoteEtag = item.etag;
        final result = await store.saveUploaded(item);
        final savedEtag = await _handleSaveResult(item, remoteEtag, result);
        return _createEvent(
          uid: uid,
          remoteEtag: remoteEtag,
          cacheEtag: savedEtag,
        );
      } on Conflict {
        final remoteItem = await download(item.uid);
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
    }, whenOffline: () => SyncEvent.offline(uid)),
  );

  Future<String> _handleSaveResult(
    TItem item,
    String remoteEtag,
    SaveResult<TItem> result,
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
    required TItem remote,
    required TItem cache,
    required String remoteEtag,
    required ConflictOrigin origin,
  }) async {
    try {
      final cacheEtag = cache.etag;
      await resolveConflict(remote, cache, origin);
      final result = await store.saveLocal(
        remote,
        expectedEtag: cacheEtag,
        remoteEtag: remoteEtag,
      );
      return await _handleSaveResult(remote, remoteEtag, result);
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

  Stream<SyncEvent> _handleResponse(ItemListResponse<TItem> response) async* {
    if (!_downSyncActive) {
      _downSyncActive = true;
      yield const SyncEvent.downloadStarted();
    }

    for (final item in response.data) {
      try {
        yield await _syncLock.synchronized(() async {
          final result = await store.saveRemote(item);
          final savedEtag = await _handleSaveResult(item, item.etag, result);
          return SyncEvent.downloaded(item.uid, savedEtag);
        });

        // ignore: avoid_catches_without_on_clauses
      } catch (e, s) {
        // workaround, as one cannot yield multiple exceptions from an async*
        _handleError(e, s);
      }
    }

    await store.saveStoken(response.stoken);

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
