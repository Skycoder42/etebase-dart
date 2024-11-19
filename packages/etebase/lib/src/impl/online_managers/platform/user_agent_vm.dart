import 'dart:io';

import 'package:meta/meta.dart';

import 'user_agent_stub.dart' as stub;

@internal
abstract base class UserAgent {
  static String build(String clientName) => stub.UserAgent.buildFromValues(
        clientName,
        values: [
          'Dart/${Platform.version}',
          if (Platform.isIOS || Platform.isMacOS)
            '${Platform.operatingSystem} ${Platform.operatingSystemVersion}'
          else
            Platform.operatingSystemVersion,
        ],
      );
}
