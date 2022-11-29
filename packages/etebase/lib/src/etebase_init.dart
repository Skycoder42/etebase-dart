import '../gen/ffi/libetebase.ffi.isolate.dart';
import 'isolate/etebase_isolate.dart';
import 'isolate/logging_invocation_handler_wrapper.dart';
import 'model/etebase_config.dart';

abstract class Etebase {
  static Future<void> ensureInitialized(
    LoadLibetebaseFn loadLibetebase, {
    EtebaseConfig config = const EtebaseConfig(),
    int? logLevel,
  }) async {
    var handler = etebaseIsolateMessageHandler;
    if (logLevel != null) {
      handler = LoggingInvocationHandlerWrapper(
        etebaseIsolateMessageHandler,
        logLevel: logLevel,
      );
    }

    // ignore: prefer_asserts_with_message
    assert(() {
      if (logLevel == null) {
        handler = const LoggingInvocationHandlerWrapper(
          etebaseIsolateMessageHandler,
        );
      }
      return true;
    }());

    await EtebaseIsolate.spawn(
      loadLibetebase: loadLibetebase,
      etebaseConfig: config,
      methodInvocationHandler: handler,
    );
  }

  static void terminate() => EtebaseIsolate.current.terminate();
}
