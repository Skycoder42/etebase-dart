import 'package:etebase/etebase.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../storage/save_result.dart';

class SyncLogger {
  @protected
  final Logger logger;
  @protected
  final String type;

  SyncLogger(this.logger, this.type);

  @protected
  String catItem(String uid, [String? etag]) =>
      etag != null ? '[$type:$uid; etag: $etag]' : '[$type:$uid]';

  @protected
  String catSync([String? collectionType, String? stoken]) {
    final buffer = StringBuffer()..write('[sync');
    if (collectionType != null) {
      buffer.write(':$collectionType');
    }
    if (stoken != null) {
      buffer.write('; stoken: $stoken');
    }
    buffer.write(']');
    return buffer.toString();
  }

  void updateMeta(String uid) =>
      logger.finer('${catItem(uid)} Updating $type metadata');

  void delete(String uid) => logger.finer('${catItem(uid)} Deleting $type');

  void uploadSkipped(String uid) =>
      logger.finest('${catItem(uid)} Skipping locally unchanged $type');

  void uploadOffline(String uid) =>
      logger.finer('${catItem(uid)} Skipping offline');

  void uploadStarted(String uid, String etag) =>
      logger.finer('${catItem(uid, etag)} Uploading $type');

  void uploadAccepted(String uid, String etag) =>
      logger.fine('${catItem(uid, etag)} Server accepted $type');

  void downloadTriggered(String reason, [String? collectionType]) =>
      logger.finest('${catSync(collectionType)} Triggered sync: $reason');

  void downloadWaiting([String? collectionType]) => logger.finer(
    '${catSync(collectionType)} Waiting for internet connection',
  );

  void downloadOffline([String? collectionType]) =>
      logger.finer('${catSync(collectionType)} Skipping offline');

  void downloadFetching(String? stoken, [String? collectionType]) =>
      logger.fine('${catSync(collectionType, stoken)} Fetching updates');

  void downloadSyncing(String? stoken, [String? collectionType]) => logger.fine(
    '${catSync(collectionType, stoken)} Fetching and monitoring updates',
  );

  void downloadResponse<T extends Item>(
    ListResponse<T> response, [
    String? collectionType,
  ]) {
    if (!logger.isLoggable(Level.FINE)) {
      return;
    }

    final stoken = switch (response) {
      ItemListResponse(:final stoken) => stoken,
      CollectionListResponse(:final stoken) => stoken,
      IteratorListResponse(:final iterator) => iterator,
      _ => null,
    };

    if (logger.isLoggable(Level.FINER)) {
      final itemUids = response.data.map((i) => i.uid).join(', ');
      logger.finer(
        '${catSync(collectionType, stoken)} '
        'Processing ${response.data.length} remote ${type}s '
        '(done: ${response.isDone}; itemUids: $itemUids)',
      );
    } else {
      logger.fine(
        '${catSync(collectionType, stoken)} '
        'Processing ${response.data.length} remote ${type}s '
        '(done: ${response.isDone})',
      );
    }
  }

  void downloadRemoved(String uid) =>
      logger.fine('${catItem(uid)} access revoked');

  void downloadItem(String uid) =>
      logger.fine('${catItem(uid)} Fetching latest $type revision');

  void downloadSkipped(String uid) =>
      logger.finest('${catItem(uid)} Skipping excluded $type');

  void saved(
    String uid,
    SaveAction action, {
    required String cacheEtag,
    String? remoteEtag,
  }) {
    final direction = remoteEtag == null ? 'local' : 'remote';
    switch (action) {
      case SaveAction.saved:
        logger.fine(
          '${catItem(uid, cacheEtag)} '
          'Saved $direction $type to storage${_remote(remoteEtag)}',
        );
      case SaveAction.deleted:
        logger.fine(
          '${catItem(uid, cacheEtag)} '
          'Deleted $direction $type from storage${_remote(remoteEtag)}',
        );
      case SaveAction.unchanged:
        logger.finest('${catItem(uid, cacheEtag)} $type unchanged');
    }
  }

  void conflict(
    String uid, {
    required String cacheEtag,
    String? remoteEtag,
    required String itemEtag,
  }) {
    final direction = remoteEtag == null ? 'local' : 'remote';
    logger.warning(
      '${catItem(uid, itemEtag)} Conflict with $direction version of $type '
      'detected!${_cacheAndRemote(cacheEtag, remoteEtag)}',
    );
  }

  void error(String context, Object error, StackTrace stackTrace) =>
      logger.severe('Unexpected error in $context', error, stackTrace);

  String _remote(String? etag) => etag != null ? ' (Remote etag: $etag)' : '';

  String _cacheAndRemote(String cacheEtag, String? remoteEtag) =>
      remoteEtag != null
      ? ' (Cache etag: $cacheEtag; Remote etag: $remoteEtag)'
      : ' (Cache etag: $cacheEtag)';
}
