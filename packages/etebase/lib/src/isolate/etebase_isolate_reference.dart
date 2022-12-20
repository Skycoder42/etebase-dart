import 'package:meta/meta.dart';

import '../model/etebase_config.dart';
import 'etebase_isolate.dart';
import 'etebase_isolate_error.dart';

class _EtebaseInitParams {
  final LoadLibetebaseFn loadLibetebase;
  final EtebaseConfig etebaseConfig;
  final MethodInvocationHandler methodInvocationHandler;
  final Duration? terminationTimeout;

  const _EtebaseInitParams(
    this.loadLibetebase,
    this.etebaseConfig,
    this.methodInvocationHandler,
    this.terminationTimeout,
  );
}

/// @nodoc
@internal
class EtebaseIsolateReference {
  static _EtebaseInitParams? _initParams;

  static int _refCtr = 0;
  static EtebaseIsolate? _currentIsolate;

  /// @nodoc
  static void initialize({
    required LoadLibetebaseFn loadLibetebase,
    required EtebaseConfig etebaseConfig,
    required MethodInvocationHandler methodInvocationHandler,
    Duration? terminationTimeout = const Duration(seconds: 30),
    bool overwrite = false,
  }) {
    if (overwrite || _initParams == null) {
      _initParams = _EtebaseInitParams(
        loadLibetebase,
        etebaseConfig,
        methodInvocationHandler,
        terminationTimeout,
      );
    }
  }

  /// @nodoc
  static Future<EtebaseIsolateReference> create() async {
    if (_initParams == null) {
      throw EtebaseIsolateError.notInitialized();
    }

    if (_refCtr++ == 0) {
      assert(
        _currentIsolate == null,
        'Invalid state: _refCtr == 0, but _currentIsolate != null',
      );

      _currentIsolate = await EtebaseIsolate.spawn(
        loadLibetebase: _initParams!.loadLibetebase,
        etebaseConfig: _initParams!.etebaseConfig,
        methodInvocationHandler: _initParams!.methodInvocationHandler,
      );
    }

    return EtebaseIsolateReference._();
  }

  EtebaseIsolateReference._();

  /// @nodoc
  Future<T> invoke<T>(Symbol method, List<dynamic> arguments) {
    if (_currentIsolate == null) {
      throw EtebaseIsolateError.clientDisposed();
    }
    return _currentIsolate!.invoke<T>(method, arguments);
  }

  /// @nodoc
  Future<void> dispose() async {
    if (--_refCtr == 0) {
      assert(
        _currentIsolate != null,
        'Invalid state: _refCtr == 1, but _currentIsolate == null',
      );

      final isolate = _currentIsolate!;
      _currentIsolate = null;
      await isolate.terminate(timeout: _initParams?.terminationTimeout);
    }
  }
}
