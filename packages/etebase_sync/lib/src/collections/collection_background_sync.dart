import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../models/conflict_origin.dart';
import '../storage/collection_store.dart';
import '../sync/background_sync.dart';
import '../sync/sync_event.dart';
import 'collection_conflict_resolver.dart';

typedef _SyncRequest = ({String collectionType, String? stoken});

@internal
final class CollectionBackgroundSync
    extends
        BackgroundSync<
          Collection,
          CollectionListResponse<Collection>,
          CollectionStore
        > {
  final CollectionManager _collectionManager;
  final CollectionConflictResolver _conflictResolver;

  final _collectionResponseTypes = Expando<String>(
    'CollectionBackgroundSync._collectionResponseTypes',
  );
  final _controller = StreamController<_SyncRequest>();

  CollectionBackgroundSync(
    super.online,
    super.store,
    this._collectionManager,
    this._conflictResolver,
    super.logger,
  );

  @override
  Future<void> dispose() async =>
      await Future.wait([super.dispose(), _controller.close()]);

  Future<void> sync(String collectionType) async {
    // TODO this if condition wont work
    if (!isDownSyncActive) {
      logger.downloadTriggered('Manual sync', collectionType);
      _controller.add((
        collectionType: collectionType,
        stoken: await store.getStoken(collectionType),
      ));
    }

    await syncEvents
        .whereType<SyncDownloadFinishedEvent>()
        .where((e) => e.scope == collectionType)
        .first;
  }

  @override
  Stream<CollectionListResponse<Collection>> streamRemote() =>
      _controller.stream.asyncExpand(_fetchUpdates);

  @override
  Future<void> updateStoken(CollectionListResponse<Collection> response) async {
    final collectionType = _collectionResponseTypes[response];
    if (collectionType == null) {
      throw StateError(
        'No collectionType for response! This should not happen',
      );
    }

    await store.saveStoken(collectionType, response.stoken);
  }

  @override
  String? scopeFor(CollectionListResponse<Collection> response) =>
      _collectionResponseTypes[response];

  @override
  Future<void> upload(Collection item) async =>
      await _collectionManager.transaction(item);

  @override
  Future<Collection> download(String uid) async =>
      await _collectionManager.fetch(uid);

  @override
  Future<void> resolveConflict(
    Collection target,
    Collection conflicted,
    ConflictOrigin origin,
  ) async =>
      await _conflictResolver.resolveConflict(target, conflicted, origin);

  Stream<CollectionListResponse<Collection>> _fetchUpdates(
    _SyncRequest request,
  ) {
    CollectionListResponse<Collection>? response;
    return online
        .streamOnline<CollectionListResponse<Collection>>(
          () async* {
            do {
              final stoken = response?.stoken ?? request.stoken;
              logger.downloadFetching(stoken, request.collectionType);
              response = await _collectionManager.list(
                request.collectionType,
                FetchOptions(stoken: stoken),
              );
              await _handleRemovedMemberships(response!);
              yield response!;
            } while (!response!.isDone);
          },
          whenOffline: () {
            logger.downloadOffline(request.collectionType);
            return CollectionListResponse(
              data: const [],
              stoken: response?.stoken ?? request.stoken,
              isDone: true,
            );
          },
        )
        .doOnData(
          (response) =>
              _collectionResponseTypes[response] = request.collectionType,
        );
  }

  Future<void> _handleRemovedMemberships(
    CollectionListResponse<Collection> response,
  ) async {
    if (response.removedMemberships case final List<RemovedCollection> cols) {
      for (final RemovedCollection(:uid) in cols) {
        logger.downloadRemoved(uid);
        // TODO handle this
      }
    }
  }
}
