import 'dart:async';

import 'package:etebase_sync/src/online/online_checker.dart';
import 'package:etebase_sync/src/online/online_status.dart';

class TestOnlineChecker implements OnlineChecker {
  final controller = StreamController<OnlineStatus>.broadcast();
  OnlineStatus _status = OnlineStatus.online;

  OnlineStatus get testStatus => _status;

  set testStatus(OnlineStatus status) {
    _status = status;
    controller.add(_status);
  }

  @override
  Future<OnlineStatus> checkOnlineStatus() => Future.value(testStatus);

  @override
  Stream<OnlineStatus> watchOnlineStatus() => controller.stream;

  @override
  Future<void> dispose() async {
    if (controller.hasListener) {
      return;
    }
    unawaited(controller.close());
  }
}
