import 'package:logging/logging.dart';

import '../online/online_status.dart';

class OnlineLogger {
  final Logger _logger;

  OnlineLogger(Logger parent) : _logger = Logger('${parent.fullName}.online');

  void statusChanged(OnlineStatus status) =>
      _logger.fine('Online status changed: ${status.name}');

  void watchStarted() => _logger.finest('Watching for network changes');

  void pingStarted(Duration interval) =>
      _logger.finer('Starting online check ping with interval $interval');

  void ping(OnlineStatus status) =>
      _logger.finer('Ping result: ${status.name}');

  void error(Object error, StackTrace stackTrace) => _logger.warning(
    'Network online check failed with error',
    error,
    stackTrace,
  );
}
