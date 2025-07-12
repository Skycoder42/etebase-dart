import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import '../logging/online_logger.dart';
import 'online_checker.dart';
import 'online_status.dart';

@internal
class OnlineWrapper {
  static const defaultWaitInterval = Duration(seconds: 30);

  final OnlineChecker _onlineChecker;
  final OnlineLogger _logger;
  final Duration _waitInterval;

  final _onlineNotifier = StreamController<OnlineStatus>.broadcast(sync: true);

  OnlineStatus? _currentStatus;
  StreamSubscription<OnlineStatus>? _subscription;
  Timer? _timer;

  OnlineWrapper(
    this._onlineChecker,
    this._logger, [
    this._waitInterval = defaultWaitInterval,
  ]) {
    unawaited(_listen());
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await Future.wait([?_subscription?.cancel(), _onlineNotifier.close()]);
  }

  Stream<OnlineStatus> get stream => _onlineNotifier.stream;

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

    try {
      final status = await _onlineChecker.checkOnlineStatus();
      // do not overwrite any update received in parallel by the subscription
      _setOnlineStatus(status, overwrite: _subscription == null);
      return status.isOnline;

      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      _logger.error(e, s);
      return false;
    }
  }

  Future<void> waitForOnline() async {
    if (await isOnline) {
      return Future.value();
    }

    if (_subscription == null) {
      _logger.pingStarted(_waitInterval);
      _timer ??= Timer.periodic(_waitInterval, _pingOnline);
    }

    await _onlineNotifier.stream.firstWhere((s) => s.isOnline);
  }

  Future<T> runOnline<T>(
    FutureOr<T> Function() callback, {
    T Function()? whenOffline,
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
    T Function()? whenOffline,
  }) => Stream.fromFuture(isOnline).asyncExpand(
    (isOnline) => switch (isOnline) {
      true => _OnlineWrapperStreamBuilder(callback(), whenOffline).stream,
      false when whenOffline != null => Stream.value(whenOffline()),
      false => const Stream.empty(),
    },
  );

  Future<void> _listen() async {
    await _subscription?.cancel();
    _subscription = _onlineChecker.watchOnlineStatus()?.listen(
      _setOnlineStatus,
      onError: _logger.error,
      onDone: _listen,
      cancelOnError: false,
    );
    if (_subscription != null) {
      _logger.watchStarted();
    }
  }

  void _setOnlineStatus(OnlineStatus status, {bool overwrite = true}) {
    if (!overwrite && _currentStatus != null) {
      return;
    }

    _currentStatus = status;
    _logger.statusChanged(status);
    if (_onlineNotifier.hasListener) {
      _onlineNotifier.add(status);
    }
  }

  void _resetOnlineStatus() {
    if (_subscription == null) {
      _currentStatus = OnlineStatus.offline;
      _logger.statusChanged(_currentStatus!);
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
      _logger.ping(_currentStatus ?? OnlineStatus.offline);

      // ignore: avoid_catches_without_on_clauses rethrows
    } catch (e, s) {
      _logger.error(e, s);
    } finally {
      if (cancelTimer) {
        timer.cancel();
        _timer?.cancel();
        _timer = null;
      }
    }
  }
}

class _OnlineWrapperStreamBuilder<T> {
  final Stream<T> _stream;
  final T Function()? _whenOffline;

  late final StreamController<T> _controller = _stream.isBroadcast
      ? StreamController.broadcast(onListen: _onListen, onCancel: _onCancel)
      : StreamController(onListen: _onListen, onCancel: _onCancel);
  late final StreamSubscription<T> _subscription;

  _OnlineWrapperStreamBuilder(this._stream, this._whenOffline);

  Stream<T> get stream => _controller.stream;

  void _onListen() {
    _subscription = _stream.listen(
      _controller.add,
      onError: _onError,
      onDone: _controller.close,
      cancelOnError: false,
    );
  }

  void _onCancel() {
    unawaited(_subscription.cancel());
    unawaited(_controller.close());
  }

  void _onError(Object error, StackTrace stackTrace) {
    if (error case ConnectionProblem() || TemporaryServerProblem()) {
      if (_whenOffline != null) {
        _controller.add(_whenOffline());
      }

      unawaited(_subscription.cancel());
      unawaited(_controller.close());
    } else {
      _controller.addError(error, stackTrace);
    }
  }
}
