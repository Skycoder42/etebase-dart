import 'gen/ffi/libetebase.ffi.isolate.dart';
import 'isolate/etebase_isolate.dart';
import 'isolate/etebase_isolate_reference.dart';
import 'isolate/logging_invocation_handler_wrapper.dart';
import 'model/etebase_config.dart';

/// A static class to initialize the library.
///
/// When using this library as part of a flutter application, you should
/// instead use TODO
abstract class Etebase {
  /// Asynchronously initializes the etebase background isolate for processing.
  ///
  /// If the isolate is already running, this method does nothing and will
  /// return immediately.
  ///
  /// You have to call it at least once before you can use any of the library
  /// methods.
  ///
  /// When using this library as part of a flutter application, you should
  /// instead use TODO
  static void ensureInitialized(
    LoadLibetebaseFn loadLibetebase, {
    EtebaseConfig config = const EtebaseConfig(),
    int? logLevel,
    bool overwrite = false,
  }) {
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

    EtebaseIsolateReference.initialize(
      loadLibetebase: loadLibetebase,
      etebaseConfig: config,
      methodInvocationHandler: handler,
      overwrite: overwrite,
    );
  }
}
