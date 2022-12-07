import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import '../../gen/ffi/libetebase.ffi.dart';
import '../model/etebase_config.dart';
import 'etebase_isolate_error.dart';
import 'method_invocation.dart';
import 'method_result.dart';

typedef LoadLibetebaseFn = FutureOr<DynamicLibrary> Function();

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

class EtebaseIsolate {
  static const _controlInitializeIsolateMessageId = -1;
  static const _controlTerminateIsolateMessage =
      #__ctrl_etebase_isolate_terminate;

  final Isolate _isolate;
  final ReceivePort _exitPort;
  final ReceivePort _receivePort;
  final Stream<MethodResult> _receiveBroadcast;
  final SendPort _sendPort;

  late final Future<void> _terminatedAndDisposed;

  int _invocationCounter = 0;

  EtebaseIsolate._(
    this._isolate,
    this._exitPort,
    this._receivePort,
    this._receiveBroadcast,
    this._sendPort,
  ) {
    // ignore: discarded_futures
    _terminatedAndDisposed = _exitPort.first.whenComplete(_dispose);
  }

  Future<T> invoke<T>(Symbol method, List<dynamic> arguments) {
    final id = _invocationCounter++;
    final result = _receiveBroadcast.firstWhere(
      (r) => r.id == id,
      orElse: () => throw EtebaseIsolateError.isolateTerminated(),
    );

    _sendPort.send(MethodInvocation(id, method, arguments));

    return result.then((r) => r.unwrap<T>());
  }

  Future<void> terminate({
    Duration timeout = const Duration(seconds: 30),
  }) {
    _sendPort.send(
      MethodInvocation(
        _invocationCounter++,
        _controlTerminateIsolateMessage,
        const <dynamic>[],
      ),
    );

    if (timeout == Duration.zero) {
      return _terminatedAndDisposed;
    } else {
      return _terminatedAndDisposed.timeout(timeout, onTimeout: _isolate.kill);
    }
  }

  void _dispose() {
    _receivePort.close();
    _exitPort.close();

    assert(_instance == this, 'this should be the active instance!');
    _instance = null;
  }

  // static parts

  static EtebaseIsolate? _instance;

  static bool get hasInstance => _instance != null;

  static EtebaseIsolate get current {
    if (_instance == null) {
      throw EtebaseIsolateError.notInitialized();
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
    ReceivePort? exitPort;
    Isolate? isolate;
    try {
      receivePort = ReceivePort('$EtebaseIsolate.spawn');
      exitPort = ReceivePort('$EtebaseIsolate.exit');
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
        onExit: exitPort.sendPort,
      );

      final setupResult = await setupResultFuture;
      assert(
        setupResult.id == _controlInitializeIsolateMessageId,
        'ID of setup result should be $_controlInitializeIsolateMessageId',
      );

      return _instance = EtebaseIsolate._(
        isolate,
        exitPort,
        receivePort,
        receiveBroadcast,
        setupResult.unwrap<SendPort>(),
      );

      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      // coverage:ignore-start
      isolate?.kill();
      receivePort?.close();
      exitPort?.close();
      rethrow;
      // coverage:ignore-end
    }
  }

  static Future<void> _main(_EtebaseIsolateInitMessage initMessage) async {
    final config = initMessage.etebaseConfig;
    final sendPort = initMessage.sendPort;
    final receivePort = ReceivePort('$EtebaseIsolate._main');

    try {
      final dyLib = await initMessage.loadLibetebase();
      final libEtebase = LibEtebaseFFI(dyLib);

      sendPort.send(
        MethodResult.success(
          _controlInitializeIsolateMessageId,
          receivePort.sendPort,
        ),
      );

      await for (final invocation in receivePort.cast<MethodInvocation>()) {
        // handle control messages
        switch (invocation.method) {
          case _controlTerminateIsolateMessage:
            // exit the isolate
            return;
          default:
            // continue normal message handling
            break;
        }

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
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      sendPort.send(
        MethodResult.exception(_controlInitializeIsolateMessageId, error),
      );
      rethrow;
    } finally {
      receivePort.close();
    }
  }
}
