import 'dart:async';
import 'dart:isolate';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sodium/sodium_sumo.dart';

import 'crypto_manager_sync.dart';

part 'isolated_crypto_manager.freezed.dart';

@Freezed(copyWith: false, toStringOverride: false, equal: false)
sealed class _IsolateMessage<TCryptoManager extends CryptoManagerSync>
    with _$IsolateMessage<TCryptoManager> {
  const factory _IsolateMessage({
    required SodiumSumoFactory sodiumFactory,
    required int version,
    required TransferrableSecureKey key,
    required TCryptoManager Function(
      SodiumSumo sodium,
      SecureKey key,
      int version,
    ) cryptoManagerFactory,
    required ReceivePort receivePort,
    required SendPort sendPort,
  }) = __IsolateMessage;
}

@Freezed(copyWith: false, toStringOverride: false, equal: false)
sealed class _CryptoJob<TCryptoManager extends CryptoManagerSync>
    with _$CryptoJob<TCryptoManager> {
  const factory _CryptoJob({
    required int id,
    required FutureOr<dynamic> Function(
      TCryptoManager cryptoManager,
      List<SecureKey> secureKey,
      List<KeyPair> keyPairs,
    ) callback,
    @Default([]) List<TransferrableSecureKey> secureKey,
    @Default([]) List<TransferrableKeyPair> keyPairs,
  }) = __CryptoJob;
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
class IsolatedCryptoManager<TCryptoManager extends CryptoManagerSync> {
  final SodiumSumo sodium;

  late final Isolate _isolate;
  late final SendPort _sendPort;
  late final ReceivePort _receivePort;
  late final Stream<_CryptoJobResult> _receivePortStream;
  var _jobIdCtr = 0;

  @protected
  IsolatedCryptoManager(this.sodium);

  @protected
  Future<void> initialize(
    SecureKey key,
    int version,
    TCryptoManager Function(
      SodiumSumo sodium,
      SecureKey key,
      int version,
    ) cryptoManagerFactory,
  ) async {
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
        version: version,
        key: sodium.createTransferrableSecureKey(key),
        cryptoManagerFactory: cryptoManagerFactory,
        receivePort: isolateRp,
        sendPort: _receivePort.sendPort,
      ),
    );
  }

  void dispose() {
    _receivePort.close();
    _isolate.kill();
  }

  Future<TResult> call<TResult>(
    FutureOr<TResult> Function(
      TCryptoManager cryptoManager,
      List<SecureKey> secureKey,
      List<KeyPair> keyPairs,
    ) callback, {
    List<SecureKey> secureKey = const [],
    List<KeyPair> keyPairs = const [],
  }) {
    final jobId = _jobIdCtr++;
    _sendPort.send(
      _CryptoJob(
        id: jobId,
        callback: callback,
        secureKey: secureKey.map(sodium.createTransferrableSecureKey).toList(),
        keyPairs: keyPairs.map(sodium.createTransferrableKeyPair).toList(),
      ),
    );

    return switch (TResult) {
      // ignore: type_literal_in_constant_pattern
      SecureKey => _waitForResult<TransferrableSecureKey>(jobId)
          .then(sodium.materializeTransferrableSecureKey)
          .then((k) => k as TResult),
      // ignore: type_literal_in_constant_pattern
      KeyPair => _waitForResult<TransferrableKeyPair>(jobId)
          .then(sodium.materializeTransferrableKeyPair)
          .then((k) => k as TResult),
      _ => _waitForResult<TResult>(jobId),
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

Future<void> _isolateMain<TCryptoManager extends CryptoManagerSync>(
  _IsolateMessage<TCryptoManager> message,
) async {
  final sodium = await message.sodiumFactory();
  final cryptoManager = message.cryptoManagerFactory(
    sodium,
    sodium.materializeTransferrableSecureKey(message.key),
    message.version,
  );

  await for (final job in message.receivePort.cast<_CryptoJob>()) {
    try {
      final result = await job.callback(
        cryptoManager,
        job.secureKey.map(sodium.materializeTransferrableSecureKey).toList(),
        job.keyPairs.map(sodium.materializeTransferrableKeyPair).toList(),
      );
      final jobResult = _CryptoJobResult.success(
        job.id,
        switch (result) {
          SecureKey() => sodium.createTransferrableSecureKey(result),
          KeyPair() => sodium.createTransferrableKeyPair(result),
          _ => result,
        },
      );
      message.sendPort.send(jobResult);

      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      message.sendPort.send(_CryptoJobResult.error(job.id, e, s));
    }
  }
}
