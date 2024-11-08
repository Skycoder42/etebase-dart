import 'dart:async';
import 'dart:isolate';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sodium/sodium_sumo.dart';

import '../crypto_manager_base.dart';

part 'isolated_crypto_manager.freezed.dart';

@internal
@Freezed(copyWith: false)
sealed class CryptoManagerRef<TCryptoManager extends CryptoManagerBaseSync>
    with _$CryptoManagerRef<TCryptoManager> {
  const factory CryptoManagerRef(int id) = _CryptoManagerRef;
}

@Freezed(copyWith: false, toStringOverride: false, equal: false)
sealed class _IsolateMessage with _$IsolateMessage {
  const factory _IsolateMessage({
    required SodiumSumoFactory sodiumFactory,
    required ReceivePort receivePort,
    required SendPort sendPort,
  }) = __IsolateMessage;
}

@Freezed(copyWith: false, toStringOverride: false, equal: false)
sealed class _CryptoJob<TCryptoManager extends CryptoManagerBaseSync>
    with _$CryptoJob<TCryptoManager> {
  const factory _CryptoJob.createCm({
    required int id,
    required TCryptoManager Function(
      SodiumSumo sodium,
      List<SecureKey> secureKeys,
      List<KeyPair> keyPairs,
    ) cryptoManagerFactory,
    required List<TransferrableSecureKey> secureKeys,
    required List<TransferrableKeyPair> keyPairs,
  }) = _CryptoJobCreateCm;

  const factory _CryptoJob.createCmWithRef({
    required int id,
    required CryptoManagerRef ref,
    required TCryptoManager Function(
      CryptoManagerBaseSync parent,
      List<SecureKey> secureKeys,
      List<KeyPair> keyPairs,
    ) cryptoManagerFactory,
    required List<TransferrableSecureKey> secureKeys,
    required List<TransferrableKeyPair> keyPairs,
  }) = _CryptoJobCreateCmWithRef;

  const factory _CryptoJob.disposeCm({
    required int id,
    required CryptoManagerRef<TCryptoManager> ref,
  }) = _CryptoJobDisposeCm;

  const factory _CryptoJob.exec({
    required int id,
    required CryptoManagerRef<TCryptoManager> ref,
    required dynamic Function(
      TCryptoManager cryptoManager,
      List<SecureKey> secureKeys,
      List<KeyPair> keyPairs,
    ) callback,
    required List<TransferrableSecureKey> secureKeys,
    required List<TransferrableKeyPair> keyPairs,
    required bool disposeIsolateKeys,
  }) = _CryptoJobExec;

  const factory _CryptoJob.exit(int id) = _CryptoJobExit;
}

@Freezed(copyWith: false, toStringOverride: false, equal: false)
sealed class _CryptoJobResult with _$CryptoJobResult {
  const factory _CryptoJobResult.success(int id, dynamic result) =
      _CryptoJobResultSuccess;
  const factory _CryptoJobResult.error(
    int id,
    Object error,
    StackTrace stackTrace,
  ) = _CryptoJobResultError;
}

@internal
class IsolatedCryptoManager {
  final SodiumSumo sodium;

  late final SendPort _sendPort;
  late final ReceivePort _receivePort;
  late final Stream<_CryptoJobResult> _receivePortStream;
  late final Isolate _isolate;
  var _jobIdCtr = 0;
  var _disposed = false;

  IsolatedCryptoManager(this.sodium);

  Future<void> initialize() async {
    _receivePort = ReceivePort('IsolatedCryptoManager.main');
    final isolateRp = ReceivePort('IsolatedCryptoManager.isolate');
    _sendPort = isolateRp.sendPort;
    _receivePortStream =
        _receivePort.cast<_CryptoJobResult>().asBroadcastStream();
    _isolate = await Isolate.spawn(
      debugName: 'IsolatedCryptoManager.isolate',
      _isolateMain,
      _IsolateMessage(
        sodiumFactory: sodium.isolateFactory,
        receivePort: isolateRp,
        sendPort: _receivePort.sendPort,
      ),
    );
  }

  Future<void> dispose({Duration timeout = const Duration(seconds: 5)}) async {
    if (_disposed) {
      return;
    }

    try {
      _disposed = true;
      await _exec<void>(_CryptoJob.exit(_jobIdCtr++)).timeout(timeout);
    } finally {
      _receivePort.close();
      _isolate.kill();
    }
  }

  Future<CryptoManagerRef<TCryptoManager>>
      createCryptoManager<TCryptoManager extends CryptoManagerBaseSync>({
    required TCryptoManager Function(
      SodiumSumo sodium,
      List<SecureKey> secureKeys,
      List<KeyPair> keyPairs,
    ) cryptoManagerFactory,
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  }) async {
    final refId = await _exec<int>(
      _CryptoJob<TCryptoManager>.createCm(
        id: _jobIdCtr++,
        cryptoManagerFactory: cryptoManagerFactory,
        secureKeys:
            secureKeys.map(sodium.createTransferrableSecureKey).toList(),
        keyPairs: keyPairs.map(sodium.createTransferrableKeyPair).toList(),
      ),
    );
    return CryptoManagerRef(refId);
  }

  Future<CryptoManagerRef<TCryptoManager>> createCryptoManagerWithRef<
      TCryptoManager extends CryptoManagerBaseSync,
      TParent extends CryptoManagerBaseSync>({
    required CryptoManagerRef<TParent> ref,
    required TCryptoManager Function(
      TParent cm,
      List<SecureKey> secureKeys,
      List<KeyPair> keyPairs,
    ) cryptoManagerFactory,
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  }) async {
    final refId = await _exec<int>(
      _CryptoJob<TCryptoManager>.createCmWithRef(
        id: _jobIdCtr++,
        ref: ref,
        cryptoManagerFactory: (parent, secureKeys, keyPairs) =>
            cryptoManagerFactory(parent as TParent, secureKeys, keyPairs),
        secureKeys:
            secureKeys.map(sodium.createTransferrableSecureKey).toList(),
        keyPairs: keyPairs.map(sodium.createTransferrableKeyPair).toList(),
      ),
    );
    return CryptoManagerRef(refId);
  }

  Future<void>
      disposeCryptoManager<TCryptoManager extends CryptoManagerBaseSync>(
    CryptoManagerRef<TCryptoManager> ref,
  ) {
    if (_disposed) {
      return Future.value();
    }

    return _exec<void>(
      _CryptoJob<TCryptoManager>.disposeCm(
        id: _jobIdCtr++,
        ref: ref,
      ),
    );
  }

  Future<TResult> call<TResult, TCryptoManager extends CryptoManagerBaseSync>(
    CryptoManagerRef<TCryptoManager> cmRef,
    TResult Function(
      TCryptoManager cm,
      List<SecureKey> secureKeys,
      List<KeyPair> keyPairs,
    ) callback, {
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
    bool disposeIsolateKeys = false,
  }) =>
      _exec<TResult>(
        _CryptoJob<TCryptoManager>.exec(
          id: _jobIdCtr++,
          ref: cmRef,
          callback: callback,
          secureKeys:
              secureKeys.map(sodium.createTransferrableSecureKey).toList(),
          keyPairs: keyPairs.map(sodium.createTransferrableKeyPair).toList(),
          disposeIsolateKeys: disposeIsolateKeys,
        ),
      );

  Future<TResult> _exec<TResult>(_CryptoJob job) {
    _sendPort.send(job);
    return switch (TResult) {
      // ignore: type_literal_in_constant_pattern
      SecureKey => _waitForResult<TransferrableSecureKey>(job.id)
          .then(sodium.materializeTransferrableSecureKey)
          .then((k) => k as TResult),
      // ignore: type_literal_in_constant_pattern
      KeyPair => _waitForResult<TransferrableKeyPair>(job.id)
          .then(sodium.materializeTransferrableKeyPair)
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
}

Future<void> _isolateMain(_IsolateMessage message) async {
  final sodium = await message.sodiumFactory();
  var refCtr = 0;
  final cryptoManagers = <int, CryptoManagerBaseSync>{};

  void withKeys(
    void Function(List<SecureKey> secureKeys, List<KeyPair> keyPairs)
        callback, {
    required List<TransferrableSecureKey> secureKeys,
    required List<TransferrableKeyPair> keyPairs,
    bool disposeIsolateKeys = false,
  }) {
    final keys =
        secureKeys.map(sodium.materializeTransferrableSecureKey).toList();
    final pairs = keyPairs.map(sodium.materializeTransferrableKeyPair).toList();
    try {
      callback(keys, pairs);
    } finally {
      if (disposeIsolateKeys) {
        for (final key in keys) {
          key.dispose();
        }
        for (final pair in pairs) {
          pair.dispose();
        }
      }
    }
  }

  int addCm(CryptoManagerBaseSync cm) {
    final ref = refCtr++;
    cryptoManagers[ref] = cm;
    return ref;
  }

  void tearDown() {
    message.receivePort.close();
    for (final cm in cryptoManagers.values) {
      cm.dispose();
    }
  }

  await for (final job in message.receivePort.cast<_CryptoJob>()) {
    try {
      switch (job) {
        case _CryptoJobCreateCm():
          withKeys(
            secureKeys: job.secureKeys,
            keyPairs: job.keyPairs,
            (secureKeys, keyPairs) => message.sendPort.send(
              _CryptoJobResult.success(
                job.id,
                addCm(
                  job.cryptoManagerFactory(
                    sodium,
                    secureKeys,
                    keyPairs,
                  ),
                ),
              ),
            ),
          );
        case _CryptoJobCreateCmWithRef():
          withKeys(
            secureKeys: job.secureKeys,
            keyPairs: job.keyPairs,
            (secureKeys, keyPairs) => message.sendPort.send(
              _CryptoJobResult.success(
                job.id,
                addCm(
                  job.cryptoManagerFactory(
                    cryptoManagers[job.ref.id]!,
                    secureKeys,
                    keyPairs,
                  ),
                ),
              ),
            ),
          );
        case _CryptoJobDisposeCm():
          cryptoManagers.remove(job.ref.id)?.dispose();
          message.sendPort.send(_CryptoJobResult.success(job.id, null));
        case _CryptoJobExec():
          withKeys(
            secureKeys: job.secureKeys,
            keyPairs: job.keyPairs,
            disposeIsolateKeys: job.disposeIsolateKeys,
            (secureKeys, keyPairs) {
              final result = job.callback(
                cryptoManagers[job.ref.id]!,
                secureKeys,
                keyPairs,
              );

              dynamic transferrableResult;
              switch (result) {
                case SecureKey():
                  transferrableResult =
                      sodium.createTransferrableSecureKey(result);
                  result.dispose();
                case KeyPair():
                  transferrableResult =
                      sodium.createTransferrableKeyPair(result);
                  result.dispose();
                default:
                  transferrableResult = result;
              }

              message.sendPort.send(
                _CryptoJobResult.success(
                  job.id,
                  transferrableResult,
                ),
              );
            },
          );
        case _CryptoJobExit():
          tearDown();
          message.sendPort.send(_CryptoJobResult.success(job.id, null));
          return;
      }

      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      message.sendPort.send(_CryptoJobResult.error(job.id, e, s));
    }
  }

  tearDown();
}
