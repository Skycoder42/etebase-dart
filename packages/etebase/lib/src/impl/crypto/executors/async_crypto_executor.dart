import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../../api/exceptions/async_crypto_executor_isolate_failure.dart';
import '../../../api/exceptions/crypto_failure.dart';
import '../../../api/managers/crypto_executor.dart';

part 'async_crypto_executor.freezed.dart';

@Freezed(toStringOverride: false, equal: false)
sealed class _IsolateMessage with _$IsolateMessage {
  const factory({
    required SodiumSumo sodium,
    required SendPort sendPort,
    void Function()? setup,
  }) = __IsolateMessage;
}

@Freezed(toStringOverride: false, equal: false)
sealed class _CryptoJob with _$CryptoJob {
  const factory run({
    required int id,
    required dynamic Function(
      SodiumSumo sodium,
      List<SecureKey> secureKeys,
      List<KeyPair> keyPairs,
    )
    callback,
    required List<TransferrableSecureKey> secureKeys,
    required List<TransferrableKeyPair> keyPairs,
  }) = _CryptoJobRun;

  const factory exit(int id) = _CryptoJobExit;
}

@Freezed(toStringOverride: false, equal: false)
sealed class _CryptoJobResult with _$CryptoJobResult {
  const factory success(int id, [dynamic result]) = _CryptoJobResultSuccess;
  const factory error(int id, Object error, StackTrace stackTrace) =
      _CryptoJobResultError;
}

@internal
class AsyncCryptoExecutor implements CryptoExecutor {
  static final _finalizer = Finalizer(_finalize);

  final SodiumSumo _sodium;

  late final SendPort _sendPort;
  late final ReceivePort _receivePort;
  late final ReceivePort _errorPort;
  late final Stream<_CryptoJobResult> _receivePortStream;
  late final Isolate _isolate;
  var _jobIdCtr = 1; // start at 1 as 0 is reserved for the initializer message
  var _disposed = false;

  new(this._sodium);

  Future<void> initialize({
    @visibleForTesting void Function()? setupIsolate,
  }) async {
    _receivePort = ReceivePort('AsyncCryptoExecutor.main');
    _receivePortStream = _receivePort
        .cast<_CryptoJobResult>()
        .asBroadcastStream();

    _errorPort = ReceivePort('AsyncCryptoExecutor.error')
      ..cast<List<dynamic>>()
          .map((l) => l.cast<String>())
          .listen(
            (error) => Zone.current.handleUncaughtError(
              AsyncCryptoExecutorIsolateFailure(error[0]),
              StackTrace.fromString(error[1]),
            ),
            onError: Zone.current.handleUncaughtError,
          );

    final sendPortFuture = _waitForResult<SendPort>(0);
    _isolate = await Isolate.spawn(
      debugName: 'AsyncCryptoExecutor.isolate',
      _isolateMain,
      _IsolateMessage(
        sodium: _sodium,
        sendPort: _receivePort.sendPort,
        setup: setupIsolate,
      ),
      onError: _errorPort.sendPort,
    );

    _finalizer.attach(this, (_isolate, _receivePort, _errorPort), detach: this);
    _sendPort = await sendPortFuture;
  }

  @override
  Future<void> dispose({Duration timeout = const Duration(seconds: 5)}) async {
    if (_disposed) {
      return;
    }

    try {
      _disposed = true;
      await _exec<void>(_CryptoJob.exit(_nextJobId)).timeout(timeout);
    } on TimeoutException {
      // ignore
    } finally {
      _finalizer.detach(this);
      _isolate.kill();
      _receivePort.close();
      _errorPort.close();
    }
  }

  @override
  T execSync<T>(SyncCallback<T> callback) =>
      CryptoFailure.wrap<T, T>(() => callback(_sodium));

  @override
  Future<T> execAsync<T>(
    AsyncCallback<T> callback, {
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  }) => CryptoFailure.wrap<Future<T>, T>(
    () => _exec<T>(
      _CryptoJob.run(
        id: _nextJobId,
        callback: callback,
        secureKeys: secureKeys
            .map(_sodium.createTransferrableSecureKey)
            .toList(),
        keyPairs: keyPairs.map(_sodium.createTransferrableKeyPair).toList(),
      ),
    ),
  );

  @override
  Future<T> exec<T>(
    AsyncCallback<T> callback, {
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  }) => execAsync(callback, secureKeys: secureKeys, keyPairs: keyPairs);

  int get _nextJobId => _jobIdCtr++;

  Future<TResult> _exec<TResult>(_CryptoJob job) {
    _sendPort.send(job);
    // ignore: switch_on_type false positive
    return switch (TResult) {
      SecureKey =>
        _waitForResult<TransferrableSecureKey>(job.id)
            .then(_sodium.materializeTransferrableSecureKey)
            .then((k) => k as TResult),
      KeyPair => _waitForResult<TransferrableKeyPair>(
        job.id,
      ).then(_sodium.materializeTransferrableKeyPair).then((k) => k as TResult),
      Uint8List => _waitForResult<TransferableTypedData>(
        job.id,
      ).then((d) => d.materialize().asUint8List() as TResult),
      _ => _waitForResult<TResult>(job.id),
    };
  }

  Future<TResult> _waitForResult<TResult>(int jobId) => _receivePortStream
      .where((r) => r.id == jobId)
      .map(
        (r) => switch (r) {
          _CryptoJobResultSuccess() => r.result as TResult,
          _CryptoJobResultError() => Error.throwWithStackTrace(
            r.error,
            r.stackTrace,
          ),
        },
      )
      .first;

  static void _finalize((Isolate, ReceivePort, ReceivePort) token) {
    final (isolate, dataPort, errPort) = token;
    isolate.kill();
    dataPort.close();
    errPort.close();
  }
}

Future<void> _isolateMain(_IsolateMessage message) async {
  final receivePort = ReceivePort('AsyncCryptoExecutor.isolate');
  try {
    message.setup?.call();
    message.sendPort.send(_CryptoJobResult.success(0, receivePort.sendPort));

    await for (final job in receivePort.cast<_CryptoJob>()) {
      try {
        switch (job) {
          case _CryptoJobRun():
            message.sendPort.send(_processRunJob(message.sodium, job));
          case _CryptoJobExit():
            message.sendPort.send(_CryptoJobResult.success(job.id));
            return;
        }

        // ignore: avoid_catches_without_on_clauses
      } catch (e, s) {
        message.sendPort.send(_CryptoJobResult.error(job.id, e, s));
      }
    }
  } finally {
    receivePort.close();
  }
}

_CryptoJobResult _processRunJob(SodiumSumo sodium, _CryptoJobRun job) {
  List<SecureKey>? keys;
  List<KeyPair>? pairs;

  try {
    keys = job.secureKeys
        .map(sodium.materializeTransferrableSecureKey)
        .toList();
    pairs = job.keyPairs.map(sodium.materializeTransferrableKeyPair).toList();

    final result = job.callback(sodium, keys, pairs);

    dynamic transferrableResult;
    switch (result) {
      case SecureKey():
        transferrableResult = sodium.createTransferrableSecureKey(result);
        result.dispose();
      case KeyPair():
        transferrableResult = sodium.createTransferrableKeyPair(result);
        result.dispose();
      case Uint8List():
        transferrableResult = TransferableTypedData.fromList([result]);
      default:
        transferrableResult = result;
    }

    return _CryptoJobResult.success(job.id, transferrableResult);
  } finally {
    for (final key in keys ?? const <SecureKey>[]) {
      key.dispose();
    }
    for (final pair in pairs ?? const <KeyPair>[]) {
      pair.dispose();
    }
  }
}
