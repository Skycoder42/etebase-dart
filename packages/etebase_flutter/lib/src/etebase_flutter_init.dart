import 'package:etebase/etebase.dart';

import 'etebase_flutter_platform.dart';

/// A static class to configure the library.
class EtebaseFlutter {
  /// Updates the isolate configuration.
  ///
  /// Has no effect on already running isolates, which means you should invoke
  /// it before creating any clients. You specify a custom [config] and change
  /// the logging via [logLevel].
  ///
  /// **Note:** By default, you do not have to configure anything, as the
  /// default configuration should suffice for most applications.
  void configure({
    EtebaseConfig config = const EtebaseConfig(),
    int? logLevel,
  }) =>
      EtebaseFlutterPlatform.instance.configure(
        config: config,
        logLevel: logLevel,
      );
}
