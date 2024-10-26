import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

@internal
abstract class CryptoExecutor {
  Future<T> call<T>(
    SodiumSumoIsolateCallback<T> callback, {
    bool isPwHash = false,
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  });
}

@internal
class IsolateCryptoExecutor implements CryptoExecutor {
  final SodiumSumo _sodiumSumo;
  final bool _pwHashOnly;

  // ignore: avoid_positional_boolean_parameters
  IsolateCryptoExecutor(this._sodiumSumo, this._pwHashOnly);

  @override
  Future<T> call<T>(
    SodiumSumoIsolateCallback<T> callback, {
    bool isPwHash = false,
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  }) async {
    if (_pwHashOnly && !isPwHash) {
      return await callback(_sodiumSumo, secureKeys, keyPairs);
    }
    return await _sodiumSumo.runIsolated(
      callback,
      secureKeys: secureKeys,
      keyPairs: keyPairs,
    );
  }
}
