import 'dart:async';

import 'online_status.dart';

abstract interface class OnlineChecker {
  Future<OnlineStatus> checkOnlineStatus();

  Stream<OnlineStatus>? watchOnlineStatus();
}
