import 'dart:async';

enum OnlineStatus {
  online(true),
  offline(false);

  final bool isOnline;

  // ignore: avoid_positional_boolean_parameters single parameter
  const OnlineStatus(this.isOnline);
}

abstract interface class OnlineChecker {
  const factory OnlineChecker.alwaysOnline() = _AlwaysOnlineChecker;

  Future<OnlineStatus> checkOnlineStatus();
}

abstract interface class OnlineWatcher implements OnlineChecker {
  Stream<OnlineStatus> watchOnlineStatus();
}

class _AlwaysOnlineChecker implements OnlineWatcher {
  const _AlwaysOnlineChecker();

  @override
  Future<OnlineStatus> checkOnlineStatus() => Future.value(OnlineStatus.online);

  @override
  Stream<OnlineStatus> watchOnlineStatus() {
    final sc = StreamController<OnlineStatus>();
    sc
      ..onCancel = sc.close
      ..onListen = () => sc.add(OnlineStatus.online);
    return sc.stream;
  }
}
