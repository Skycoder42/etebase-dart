import 'package:etebase/etebase.dart';
import 'package:logging/logging.dart';

class SyncLogger {
  final Logger _logger;
  final String _type;

  SyncLogger(Logger parent, this._type)
    : _logger = Logger('${parent.fullName}.sync');

  String _catItem(String uid, [String? etag]) =>
      etag != null ? '[$_type:$uid; etag: $etag]' : '[$_type:$uid]';

  String _catSync([String? stoken]) =>
      stoken != null ? '[sync; stoken: $stoken]' : '[sync]';

  void uploadSkipped(String uid) =>
      _logger.finest('${_catItem(uid)} Skipping locally unchanged');

  void uploadOffline(String uid) =>
      _logger.finer('${_catItem(uid)} Skipping offline');

  void uploadStarted(String uid, String etag) =>
      _logger.finer('${_catItem(uid, etag)} Uploading');

  void uploadAccepted(String uid, String etag) =>
      _logger.fine('${_catItem(uid, etag)} Server accepted upload');

  void downloadTriggered(String reason) =>
      _logger.finest('${_catSync()} Triggered sync: $reason');

  void downloadWaiting() =>
      _logger.finer('${_catSync()} Waiting for internet connection');

  void downloadOffline() => _logger.finer('${_catSync()} Skipping offline');

  void downloadFetching(String? stoken) =>
      _logger.fine('${_catSync(stoken)} Fetching updates');

  void downloadSyncing(String? stoken) =>
      _logger.fine('${_catSync(stoken)} Fetching and monitoring updates');

  void downloadResponse<T extends Item>(ListResponse<T> response) {
    if (!_logger.isLoggable(Level.FINE)) {
      return;
    }

    final stoken = switch (response) {
      ItemListResponse(:final stoken) => stoken,
      CollectionListResponse(:final stoken) => stoken,
      IteratorListResponse(:final iterator) => iterator,
      _ => null,
    };

    if (_logger.isLoggable(Level.FINER)) {
      final itemUids = response.data.map((i) => i.uid).join(', ');
      _logger.finer(
        '${_catSync(stoken)} Processing ${response.data.length} remote items '
        '(done: ${response.isDone}; itemUids: $itemUids)',
      );
    } else {
      _logger.fine(
        '${_catSync(stoken)} Processing ${response.data.length} remote items '
        '(done: ${response.isDone})',
      );
    }
  }

  void downloadRemoved(String uid) =>
      _logger.fine('${_catItem(uid)} access revoked');

  void downloadItem(String uid) =>
      _logger.fine('${_catItem(uid)} Fetching latest');

  void downloadSkipped(String uid) =>
      _logger.finest('${_catItem(uid)} Skipping excluded item');

  void saved(
    String uid, {
    required String cacheEtag,
    required String remoteEtag,
  }) => _logger.fine(
    '${_catItem(uid, cacheEtag)} Saved to storage. Remote etag: $remoteEtag',
  );

  void conflict(
    String uid, {
    required String cacheEtag,
    required String remoteEtag,
    required String itemEtag,
  }) => _logger.fine(
    '${_catItem(uid, itemEtag)} Conflict detected! '
    'Cache etag: $cacheEtag. Remote etag: $remoteEtag',
  );

  void error(String context, Object error, StackTrace stackTrace) =>
      _logger.severe('Unexpected error in $context', error, stackTrace);
}
