import 'dart:async';

abstract interface class OnlineChecker {
  const factory OnlineChecker.alwaysOnline() = _AlwaysOnlineChecker;

  FutureOr<bool> isOnline();
}

class _AlwaysOnlineChecker implements OnlineChecker {
  const _AlwaysOnlineChecker();

  @override
  bool isOnline() => true;
}
