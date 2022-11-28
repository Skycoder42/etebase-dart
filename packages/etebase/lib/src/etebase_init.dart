import '../gen/ffi/libetebase.ffi.isolate.dart';
import 'isolate/etebase_isolate.dart';
import 'model/etebase_config.dart';

abstract class Etebase {
  static Future<void> ensureInitialized(
    LoadLibetebaseFn loadLibetebase, {
    EtebaseConfig config = const EtebaseConfig(),
  }) async {
    await EtebaseIsolate.spawn(
      loadLibetebase: loadLibetebase,
      etebaseConfig: config,
      methodInvocationHandler: etebaseIsolateMessageHandler,
    );
  }

  static void terminate() => EtebaseIsolate.current.terminate();
}
