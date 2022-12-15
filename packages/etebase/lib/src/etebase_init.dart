import 'package:synchronized/synchronized.dart';

import 'gen/ffi/libetebase.ffi.isolate.dart';
import 'isolate/etebase_isolate.dart';
import 'isolate/logging_invocation_handler_wrapper.dart';
import 'model/etebase_config.dart';

/// A static class to initialize the library.
///
/// When using this library as part of a flutter application, you should
/// instead use TODO
abstract class Etebase {
  static final _lock = Lock();

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
  static Future<void> ensureInitialized(
    LoadLibetebaseFn loadLibetebase, {
    EtebaseConfig config = const EtebaseConfig(),
    int? logLevel,
  }) =>
      _lock.synchronized(() async {
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
      });

  /// Terminates the background isolate.
  ///
  /// This is required to be called shortly before you terminate your
  /// application. If it is not called, the application will never terminate, as
  /// the isolate in the background keeps running. Calling this method more than
  /// once is allowed and will do nothing.
  ///
  /// If you are writing a pure dart application, I recommend to terminate in
  /// the main:
  ///
  /// ```dart
  /// Future<void> main() async {
  ///   await Etebase.ensureInitialized(...);
  ///   try {
  ///     // your application code ...
  ///   } finally {
  ///     await Etebase.terminate();
  ///   }
  /// }
  /// ```
  ///
  /// When using this library as part of a flutter application, you should
  /// instead use TODO
  static Future<void> terminate() => _lock.synchronized(
        () => EtebaseIsolate.hasInstance
            ? EtebaseIsolate.current.terminate()
            : Future.value(),
      );
}
