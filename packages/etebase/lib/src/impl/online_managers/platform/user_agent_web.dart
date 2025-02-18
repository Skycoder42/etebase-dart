import 'package:meta/meta.dart';
import 'package:web/web.dart';

import 'user_agent_stub.dart' as stub;

@internal
abstract base class UserAgent {
  static String build(String clientName) => stub.UserAgent.buildFromValues(
    clientName,
    suffix: window.navigator.userAgent,
  );
}
