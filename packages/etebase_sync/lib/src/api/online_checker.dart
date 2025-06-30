import 'dart:async';

abstract interface class OnlineChecker {
  const factory OnlineChecker.alwaysOnline() = _AlwaysOnlineChecker;

  bool get isOnline;
}

class _AlwaysOnlineChecker implements OnlineChecker {
  const _AlwaysOnlineChecker();

  @override
  bool get isOnline => true;
}
