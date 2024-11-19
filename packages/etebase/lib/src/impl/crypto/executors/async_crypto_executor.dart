import 'dart:async';
import 'dart:isolate';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../../api/exceptions/crypto_failure.dart';
import '../../../api/managers/crypto_executor.dart';

part 'async_crypto_executor.freezed.dart';

@Freezed(toStringOverride: false, equal: false)
sealed class _IsolateMessage with _$IsolateMessage {
  const factory _IsolateMessage({
    required SodiumSumoFactory sodiumFactory,
    required ReceivePort receivePort,
    required SendPort sendPort,
  }) = __IsolateMessage;
}

@Freezed(toStringOverride: false, equal: false)
sealed class _CryptoJob with _$CryptoJob {
  const factory _CryptoJob.run({
    required int id,
    required dynamic Function(
      SodiumSumo cryptoManager,
      List<SecureKey> secureKeys,
      List<KeyPair> keyPairs,
    ) callback,
    required List<TransferrableSecureKey> secureKeys,
    required List<TransferrableKeyPair> keyPairs,
  }) = _CryptoJobRun;

  const factory _CryptoJob.exit(int id) = _CryptoJobExit;
}

@Freezed(toStringOverride: false, equal: false)
sealed class _CryptoJobResult with _$CryptoJobResult {
  const factory _CryptoJobResult.success(int id, [dynamic result]) =
      _CryptoJobResultSuccess;
  const factory _CryptoJobResult.error(
    int id,
    Object error,
    StackTrace stackTrace,
  ) = _CryptoJobResultError;
}

@internal
class AsyncCryptoExecutor implements CryptoExecutor {
  static final _finalizer = Finalizer(_finalize);

  final SodiumSumo _sodium;

  late final SendPort _sendPort;
  late final ReceivePort _receivePort;
  late final Stream<_CryptoJobResult> _receivePortStream;
  late final Isolate _isolate;
  var _jobIdCtr = 0;
  var _disposed = false;

  AsyncCryptoExecutor(this._sodium);

  Future<void> initialize() async {
    _receivePort = ReceivePort('AsyncCryptoExecutor.main');
    final isolateRp = ReceivePort('AsyncCryptoExecutor.isolate');
    _sendPort = isolateRp.sendPort;
    _receivePortStream =
        _receivePort.cast<_CryptoJobResult>().asBroadcastStream();
    _isolate = await Isolate.spawn(
      debugName: 'AsyncCryptoExecutor.isolate',
      _isolateMain,
      _IsolateMessage(
        sodiumFactory: _sodium.isolateFactory,
        receivePort: isolateRp,
        sendPort: _receivePort.sendPort,
      ),
    );

    _finalizer.attach(this, (_isolate, _receivePort), detach: this);
  }

  @override
  Future<void> dispose({Duration timeout = const Duration(seconds: 5)}) async {
    if (_disposed) {
      return;
    }

    try {
      _disposed = true;
      await _exec<void>(_CryptoJob.exit(_jobIdCtr++)).timeout(timeout);
    } on TimeoutException {
      // ignore
    } finally {
      _finalizer.detach(this);
      _receivePort.close();
      _isolate.kill();
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
  }) =>
      CryptoFailure.wrap<Future<T>, T>(
        () => _exec<T>(
          _CryptoJob.run(
            id: _jobIdCtr++,
            callback: callback,
            secureKeys:
                secureKeys.map(_sodium.createTransferrableSecureKey).toList(),
            keyPairs: keyPairs.map(_sodium.createTransferrableKeyPair).toList(),
          ),
        ),
      );

  @override
  Future<T> exec<T>(
    AsyncCallback<T> callback, {
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  }) =>
      execAsync(
        callback,
        secureKeys: secureKeys,
        keyPairs: keyPairs,
      );

  Future<TResult> _exec<TResult>(_CryptoJob job) {
    _sendPort.send(job);
    return switch (TResult) {
      // ignore: type_literal_in_constant_pattern
      SecureKey => _waitForResult<TransferrableSecureKey>(job.id)
          .then(_sodium.materializeTransferrableSecureKey)
          .then((k) => k as TResult),
      // ignore: type_literal_in_constant_pattern
      KeyPair => _waitForResult<TransferrableKeyPair>(job.id)
          .then(_sodium.materializeTransferrableKeyPair)
          .then((k) => k as TResult),
      _ => _waitForResult<TResult>(job.id),
    };
  }

  Future<TResult> _waitForResult<TResult>(int jobId) => _receivePortStream
      .where((r) => r.id == jobId)
      .map(
        (r) => switch (r) {
          _CryptoJobResultSuccess() => r.result as TResult,
          _CryptoJobResultError() =>
            Error.throwWithStackTrace(r.error, r.stackTrace),
        },
      )
      .first;

  static void _finalize((Isolate, ReceivePort) token) {
    final (isolate, port) = token;
    port.close();
    isolate.kill();
  }
}

Future<void> _isolateMain(_IsolateMessage message) async {
  try {
    final sodium = await message.sodiumFactory();

    await for (final job in message.receivePort.cast<_CryptoJob>()) {
      try {
        switch (job) {
          case _CryptoJobRun():
            message.sendPort.send(_processRunJob(sodium, job));
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
    message.receivePort.close();
  }
}

_CryptoJobResult _processRunJob(
  SodiumSumo sodium,
  _CryptoJobRun job,
) {
  List<SecureKey>? keys;
  List<KeyPair>? pairs;

  try {
    keys =
        job.secureKeys.map(sodium.materializeTransferrableSecureKey).toList();
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
      default:
        transferrableResult = result;
    }

    return _CryptoJobResult.success(
      job.id,
      transferrableResult,
    );
  } finally {
    for (final key in keys ?? const <SecureKey>[]) {
      key.dispose();
    }
    for (final pair in pairs ?? const <KeyPair>[]) {
      pair.dispose();
    }
  }
}
