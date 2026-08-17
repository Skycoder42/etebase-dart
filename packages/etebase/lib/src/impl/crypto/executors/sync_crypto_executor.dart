import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../../api/exceptions/crypto_failure.dart';
import '../../../api/managers/crypto_executor.dart';

@internal
class SyncCryptoExecutor implements CryptoExecutor {
  final SodiumSumo _sodium;

  new(this._sodium);

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
  }) {
    final sodium = _sodium;
    return CryptoFailure.wrap<Future<T>, T>(
      () => _sodium.runIsolated(
        (k, p) => callback(sodium, k, p),
        secureKeys: secureKeys,
        keyPairs: keyPairs,
      ),
    );
  }

  @override
  T exec<T>(
    AsyncCallback<T> callback, {
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  }) => CryptoFailure.wrap<T, T>(() => callback(_sodium, secureKeys, keyPairs));
}
