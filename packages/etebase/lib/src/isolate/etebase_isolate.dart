import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:meta/meta.dart';

import '../../gen/ffi/libetebase.ffi.dart';
import '../model/etebase_config.dart';
import 'isolate_terminated.dart';
import 'method_invocation.dart';
import 'method_result.dart';

typedef LoadLibetebaseFn = FutureOr<DynamicLibrary> Function();

@internal
typedef MethodInvocationHandler = MethodResult Function(
  LibEtebaseFFI libEtebaseFFI,
  EtebaseConfig etebaseConfig,
  MethodInvocation invocation,
);

class _EtebaseIsolateInitMessage {
  final LoadLibetebaseFn loadLibetebase;
  final EtebaseConfig etebaseConfig;
  final MethodInvocationHandler methodInvocationHandler;
  final SendPort sendPort;

  const _EtebaseIsolateInitMessage(
    this.loadLibetebase,
    this.etebaseConfig,
    this.methodInvocationHandler,
    this.sendPort,
  );
}

@internal
class EtebaseIsolate {
  final Isolate _isolate;
  final ReceivePort _receivePort;
  final Stream<MethodResult> _receiveBroadcast;
  final SendPort _sendPort;

  int _invocationCounter = 0;

  EtebaseIsolate._(
    this._isolate,
    this._receivePort,
    this._receiveBroadcast,
    this._sendPort,
  );

  Future<T> invoke<T>(Symbol method, List<dynamic> arguments) {
    final id = _invocationCounter++;
    final result = _receiveBroadcast.firstWhere(
      (r) => r.id == id,
      orElse: () => throw IsolateTerminated(),
    );

    _sendPort.send(MethodInvocation(id, method, arguments));

    return result.then((r) => r.unwrap<T>());
  }

  void terminate() {
    _isolate.kill();
    _receivePort.close();

    assert(_instance == this, 'This should be the active instance!');
    _instance = null;
  }

  // static parts

  static EtebaseIsolate? _instance;

  static EtebaseIsolate get current {
    if (_instance == null) {
      throw StateError(
        'No active etebase isolate - call EtebaseIsolate.spawn to create one',
      );
    }
    return _instance!;
  }

  static Future<EtebaseIsolate> spawn({
    required LoadLibetebaseFn loadLibetebase,
    required EtebaseConfig etebaseConfig,
    required MethodInvocationHandler methodInvocationHandler,
  }) async {
    if (_instance != null) {
      return _instance!;
    }

    ReceivePort? receivePort;
    Isolate? isolate;
    try {
      receivePort = ReceivePort('$EtebaseIsolate.spawn');
      final receiveBroadcast =
          receivePort.cast<MethodResult>().asBroadcastStream();

      final setupResultFuture = receiveBroadcast.first;
      isolate = await Isolate.spawn(
        _main,
        _EtebaseIsolateInitMessage(
          loadLibetebase,
          etebaseConfig,
          methodInvocationHandler,
          receivePort.sendPort,
        ),
        debugName: '$EtebaseIsolate',
        errorsAreFatal: true,
      );

      final setupResult = await setupResultFuture;
      assert(setupResult.id == -1, 'ID of setup result should be -1');

      return _instance = EtebaseIsolate._(
        isolate,
        receivePort,
        receiveBroadcast,
        setupResult.unwrap<SendPort>(),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      isolate?.kill();
      receivePort?.close();
      rethrow;
    }
  }

  static Future<void> _main(_EtebaseIsolateInitMessage initMessage) async {
    final config = initMessage.etebaseConfig;
    final sendPort = initMessage.sendPort;
    final receivePort = ReceivePort('$EtebaseIsolate._main');

    try {
      sendPort.send(MethodResult.success(-1, receivePort.sendPort));

      final dyLib = await initMessage.loadLibetebase();
      final libEtebase = LibEtebaseFFI(dyLib);

      await for (final invocation in receivePort.cast<MethodInvocation>()) {
        try {
          final result = initMessage.methodInvocationHandler(
            libEtebase,
            config,
            invocation,
          );
          assert(
            result.id == invocation.id,
            'methodInvocationHandler must not change the invocation id',
          );
          sendPort.send(result);
          // ignore: avoid_catches_without_on_clauses
        } catch (error) {
          sendPort.send(MethodResult.exception(invocation.id, error));
        }
      }
    } finally {
      receivePort.close();
    }
  }
}
