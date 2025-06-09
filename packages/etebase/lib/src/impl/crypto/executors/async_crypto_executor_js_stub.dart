// coverage:ignore-file

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../../api/managers/crypto_executor.dart';

@internal
class AsyncCryptoExecutor implements CryptoExecutor {
  const AsyncCryptoExecutor(SodiumSumo _);

  Never _throwUnsupported() => throw UnsupportedError(
    'CryptoExecutor.async / Client.createAsync is not supported on JS platforms',
  );

  Future<void> initialize() => _throwUnsupported();

  @override
  Future<void> dispose({Duration timeout = const Duration(seconds: 5)}) =>
      Future.value();

  @override
  T execSync<T>(SyncCallback<T> callback) => _throwUnsupported();

  @override
  Future<T> execAsync<T>(
    AsyncCallback<T> callback, {
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  }) => _throwUnsupported();

  @override
  Future<T> exec<T>(
    AsyncCallback<T> callback, {
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  }) => _throwUnsupported();
}
