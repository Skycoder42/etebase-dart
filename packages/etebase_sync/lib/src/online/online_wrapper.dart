import 'dart:async';

import 'package:etebase/etebase.dart';

import 'online_checker.dart';

sealed class OnlineWrapper {
  const OnlineWrapper._();

  FutureOr<bool> get isOnline;

  Future<void> waitForOnline();

  Future<void> dispose();

  Future<T> runOnline<T>(
    FutureOr<T> Function() callback, {
    FutureOr<T> Function()? whenOffline,
  }) async {
    if (await isOnline) {
      try {
        return await callback();
      } on ConnectionProblem {
        // break
      } on TemporaryServerProblem {
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
        // break
      } on TemporaryServerProblem {
        // break
      } catch (_) {
        rethrow;
      }
    }

    yield* whenOffline?.call() ?? const Stream.empty();
  }
}

class OnlineCheckerWrapper extends OnlineWrapper {
  final OnlineChecker _onlineProber;
  final Duration waitInterval;

  (Timer, Completer<void>)? _activeWaiter;

  OnlineCheckerWrapper(this._onlineProber, this.waitInterval) : super._();

  @override
  Future<bool> get isOnline async =>
      (await _onlineProber.checkOnlineStatus()).isOnline;

  @override
  Future<void> waitForOnline() async {
    if (_activeWaiter != null && await isOnline) {
      return;
    } else if (_activeWaiter case (_, final completer)) {
      return completer.future;
    }

    final completer = Completer<void>();
    final timer = Timer.periodic(
      waitInterval,
      (timer) => _checkOnline(timer, completer),
    );
    _activeWaiter = (timer, completer);
    await completer.future;
  }

  @override
  Future<void> dispose() => Future.sync(() {
    if (_activeWaiter case (final timer, _)) {
      timer.cancel();
    }

    if (_activeWaiter case (_, final completer) when !completer.isCompleted) {
      completer.completeError(StateError('The resource was disposed'));
    }
  });

  Future<void> _checkOnline(Timer timer, Completer<void> completer) async {
    try {
      if (await isOnline) {
        timer.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    } catch (e, s) {
      timer.cancel();
      if (!completer.isCompleted) {
        completer.completeError(e, s);
      }
    }
  }
}

class OnlineWatcherWrapper extends OnlineWrapper {
  final OnlineWatcher _onlineWatcher;

  final _onlineNotifier = StreamController<OnlineStatus>.broadcast(sync: true);

  StreamSubscription<OnlineStatus>? _subscription;
  OnlineStatus? _currentStatus;

  OnlineWatcherWrapper(this._onlineWatcher) : super._() {
    unawaited(_listen());
  }

  @override
  Future<bool> get isOnline => switch (_currentStatus) {
    OnlineStatus(:final isOnline) => Future.value(isOnline),
    _ => _onlineWatcher.checkOnlineStatus().then((status) => status.isOnline),
  };

  @override
  Future<void> waitForOnline() {
    if (_currentStatus?.isOnline ?? false) {
      return Future.value();
    }

    return _onlineNotifier.stream.firstWhere((s) => s.isOnline);
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _onlineNotifier.close();
  }

  Future<void> _listen() async {
    await _subscription?.cancel();
    _subscription = _onlineWatcher.watchOnlineStatus().listen(
      _onOnlineStatusEvent,
      onDone: _listen,
      cancelOnError: false,
    );
  }

  void _onOnlineStatusEvent(OnlineStatus status) {
    _currentStatus = status;
    if (_onlineNotifier.hasListener) {
      _onlineNotifier.add(status);
    }
  }
}
