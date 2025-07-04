import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import 'online_checker.dart';
import 'online_status.dart';

@internal
class OnlineWrapper {
  static const defaultWaitInterval = Duration(seconds: 30);

  final OnlineChecker _onlineChecker;
  final Duration _waitInterval;

  final _onlineNotifier = StreamController<OnlineStatus>.broadcast(sync: true);

  OnlineStatus? _currentStatus;
  StreamSubscription<OnlineStatus>? _subscription;
  Timer? _timer;

  OnlineWrapper(
    this._onlineChecker, [
    this._waitInterval = defaultWaitInterval,
  ]) {
    unawaited(_listen());
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await Future.wait([?_subscription?.cancel(), _onlineNotifier.close()]);
  }

  Future<bool> get isOnline async {
    // check if current online status is cached. How this is done depends on
    // whether we have a subscription or not. A subscription does not need to
    // recheck when offline.
    if (_subscription != null) {
      if (_currentStatus case OnlineStatus(:final isOnline)) {
        return isOnline;
      }
    } else {
      if (_currentStatus case OnlineStatus(isOnline: true)) {
        return true;
      }
    }

    final status = await _onlineChecker.checkOnlineStatus();
    // do not overwrite any update received in parallel by the subscription
    _setOnlineStatus(status, overwrite: _subscription == null);
    return status.isOnline;
  }

  Future<void> waitForOnline() {
    if (_currentStatus case OnlineStatus(isOnline: true)) {
      return Future.value();
    }

    if (_subscription == null) {
      _timer ??= Timer.periodic(_waitInterval, _pingOnline);
    }

    return _onlineNotifier.stream.firstWhere((s) => s.isOnline);
  }

  Future<T> runOnline<T>(
    FutureOr<T> Function() callback, {
    FutureOr<T> Function()? whenOffline,
  }) async {
    if (await isOnline) {
      try {
        return await callback();
      } on ConnectionProblem {
        _resetOnlineStatus();
        // break
      } on TemporaryServerProblem {
        _resetOnlineStatus();
        // break
      } catch (_) {
        rethrow;
      }
    }

    return whenOffline?.call() ?? (null as T);
  }

  Stream<T> streamOnline<T>(
    Stream<T> Function() callback, {
    Stream<T> Function()? whenOffline,
  }) async* {
    if (await isOnline) {
      try {
        // TODO can be done cleaner? Ideally, the stream continues on other
        // errors and only aborts on offline errors
        await for (final event in callback()) {
          yield event;
        }
        return;
      } on ConnectionProblem {
        _resetOnlineStatus();
        // break
      } on TemporaryServerProblem {
        _resetOnlineStatus();
        // break
      } catch (_) {
        rethrow;
      }
    }

    yield* whenOffline?.call() ?? const Stream.empty();
  }

  Future<void> _listen() async {
    await _subscription?.cancel();
    _subscription = _onlineChecker.watchOnlineStatus()?.listen(
      _setOnlineStatus,
      onError: _handleError,
      onDone: _listen,
      cancelOnError: false,
    );
  }

  void _setOnlineStatus(OnlineStatus status, {bool overwrite = true}) {
    if (!overwrite && _currentStatus != null) {
      return;
    }

    _currentStatus = status;
    if (_onlineNotifier.hasListener) {
      _onlineNotifier.add(status);
    }
  }

  void _resetOnlineStatus() {
    if (_subscription == null) {
      _currentStatus = OnlineStatus.offline;
    }
  }

  Future<void> _pingOnline(Timer timer) async {
    var cancelTimer = true;
    try {
      // fast cancel if a subscription was startet in the mean time
      if (_subscription != null) {
        return;
      }

      // check if online and cancel if that is the case, otherwise the timer
      // will fire again
      cancelTimer = await isOnline;

      // ignore: avoid_catches_without_on_clauses rethrows
    } catch (e, s) {
      _handleError(e, s);
    } finally {
      if (cancelTimer) {
        timer.cancel();
        _timer?.cancel();
        _timer = null;
      }
    }
  }

  void _handleError(Object error, StackTrace stackTrace) {
    if (_onlineNotifier.hasListener) {
      _onlineNotifier.addError(error, stackTrace);
    } else {
      Zone.current.handleUncaughtError(error, stackTrace);
    }
  }
}
