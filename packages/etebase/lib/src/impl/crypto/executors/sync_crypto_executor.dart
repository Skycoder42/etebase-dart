import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../../api/exceptions/crypto_failure.dart';
import 'crypto_executor.dart';

@internal
class SyncCryptoExecutor implements CryptoExecutor {
  final SodiumSumo _sodium;

  SyncCryptoExecutor(this._sodium);

  @override
  void dispose() {}

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
        () => _sodium.runIsolated(
          callback,
          secureKeys: secureKeys,
          keyPairs: keyPairs,
        ),
      );

  @override
  T exec<T>(
    AsyncCallback<T> callback, {
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  }) =>
      CryptoFailure.wrap<T, T>(
        () => callback(
          _sodium,
          secureKeys,
          keyPairs,
        ),
      );
}
