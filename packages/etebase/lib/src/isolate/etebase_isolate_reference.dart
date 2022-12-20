import 'package:meta/meta.dart';

import 'etebase_isolate.dart';

/// @nodoc
@internal
class EtebaseIsolateReference {
  static int _refCtr = 0;
  static EtebaseIsolate? _currentIsolate;

  /// @nodoc
  static Future<EtebaseIsolateReference> create() async {
    if (_refCtr++ == 0) {
      assert(
        _currentIsolate == null,
        'Invalid state: _refCtr == 0, but _currentIsolate != null',
      );

      _currentIsolate = await EtebaseIsolate.spawn(
        loadLibetebase: loadLibetebase,
        etebaseConfig: etebaseConfig,
        methodInvocationHandler: methodInvocationHandler,
      );
    }

    return EtebaseIsolateReference._();
  }

  EtebaseIsolateReference._();

  /// @nodoc
  Future<void> dispose({Duration timeout = const Duration(seconds: 30)}) async {
    if (--_refCtr == 0) {
      assert(
        _currentIsolate != null,
        'Invalid state: _refCtr == 1, but _currentIsolate == null',
      );

      final isolate = _currentIsolate!;
      _currentIsolate = null;
      await isolate.terminate(timeout: timeout);
    }
  }
}
