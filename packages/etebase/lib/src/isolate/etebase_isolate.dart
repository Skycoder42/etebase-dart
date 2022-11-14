import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import '../../gen/ffi/libetebase.ffi.dart';
import 'isolate_terminated.dart';
import 'method_invocation.dart';
import 'method_result.dart';

typedef LoadLibetebaseFn = FutureOr<DynamicLibrary> Function();

class _EtebaseIsolateInitMessage {
  final LoadLibetebaseFn loadLibetebase;
  final SendPort sendPort;

  const _EtebaseIsolateInitMessage(
    this.loadLibetebase,
    this.sendPort,
  );
}

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

  Future<Object?> invoke(Symbol method, List<Object?> arguments) {
    final id = _invocationCounter++;
    final result = _receiveBroadcast.firstWhere(
      (r) => r.id == id,
      orElse: () => throw IsolateTerminated(),
    );

    _sendPort.send(MethodInvocation(id, method, arguments));

    return result.then((r) => r.result);
  }

  void terminate() {
    _isolate.kill();
    _receivePort.close();

    assert(_instance == this, 'This should be the active instance!');
    _instance = null;
  }

  // static parts

  static EtebaseIsolate? _instance;

  static EtebaseIsolate get current => _instance!; // TODO assert non null

  static Future<EtebaseIsolate> spawn({
    required LoadLibetebaseFn loadLibetebase,
  }) async {
    if (_instance != null) {
      return _instance!;
    }

    final receivePort = ReceivePort('$EtebaseIsolate.spawn');
    final receiveBroadcast =
        receivePort.cast<MethodResult>().asBroadcastStream();

    final setupResultFuture = receiveBroadcast.first;
    final isolate = await Isolate.spawn(
      _main,
      _EtebaseIsolateInitMessage(loadLibetebase, receivePort.sendPort),
      debugName: '$EtebaseIsolate',
      errorsAreFatal: false, // TODO ???
    );

    final setupResult = await setupResultFuture;
    assert(setupResult.id == -1, 'ID of setup result should be -1');

    return _instance = EtebaseIsolate._(
      isolate,
      receivePort,
      receiveBroadcast,
      // ignore: cast_nullable_to_non_nullable
      setupResult.result as SendPort,
    );
  }

  static Future<void> _main(_EtebaseIsolateInitMessage message) async {
    final sendPort = message.sendPort;
    final receivePort = ReceivePort('$EtebaseIsolate._main');

    try {
      sendPort.send(MethodResult(-1, receivePort.sendPort));

      final dyLib = await message.loadLibetebase();
      final libetebase = LibEtebaseFFI(dyLib);

      await for (final invocation in receivePort.cast<MethodInvocation>()) {
        // TODO process invocation
      }
    } finally {
      receivePort.close();
    }
  }
}
