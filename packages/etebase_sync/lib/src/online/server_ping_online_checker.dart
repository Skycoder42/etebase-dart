import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import 'online_checker.dart';
import 'online_status.dart';

@internal
class ServerPingOnlineChecker implements OnlineChecker {
  final Client _client;

  ServerPingOnlineChecker(this._client);

  @override
  Future<OnlineStatus> checkOnlineStatus() async {
    try {
      final ok = await _client.checkEtebaseServer();
      return ok ? OnlineStatus.online : OnlineStatus.offline;
    } on ConnectionProblem {
      return OnlineStatus.offline;
    } on TemporaryServerProblem {
      return OnlineStatus.offline;
    }
  }

  @override
  Stream<OnlineStatus>? watchOnlineStatus() => null;
}
