import 'package:etebase/etebase.dart';

import 'etebase_flutter_platform.dart';

class EtebaseFlutter {
  void configure({
    EtebaseConfig config = const EtebaseConfig(),
    int? logLevel,
  }) =>
      EtebaseFlutterPlatform.instance.configure(
        config: config,
        logLevel: logLevel,
      );
}
