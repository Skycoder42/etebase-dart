import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../crypto_manager_factory.dart';
import '../sync/box_crypto_manager_sync.dart';
import '../sync/main_crypto_manager_sync.dart';
import 'box_crypto_manager_async.dart';
import 'isolated_crypto_manager.dart';
import 'main_crypto_manager_async.dart';

@internal
final class CryptoManagerFactoryAsync implements CryptoManagerFactory {
  final IsolatedCryptoManager _isolated;

  CryptoManagerFactoryAsync(this._isolated);

  factory CryptoManagerFactoryAsync.sodium(SodiumSumo sodium) =>
      CryptoManagerFactoryAsync(IsolatedCryptoManager(sodium));

  @override
  Future<MainCryptoManagerAsync> createMainCryptoManager(
    SecureKey key, [
    int version = CryptoManagerFactory.currentVersion,
  ]) async {
    final cmRef = await _isolated.createCryptoManager(
      secureKeys: [key],
      cryptoManagerFactory: (sodium, secureKeys, _) =>
          MainCryptoManagerSync(sodium, secureKeys[0], version),
    );
    return MainCryptoManagerAsync(_isolated, cmRef, version);
  }

  @override
  Future<BoxCryptoManagerAsync> createBoxCryptoManager([
    SecureKey? seed,
  ]) async {
    final cmRef = await _isolated.createCryptoManager(
      secureKeys: [if (seed != null) seed],
      cryptoManagerFactory: (sodium, secureKeys, _) =>
          BoxCryptoManagerSync.fromSeed(sodium, secureKeys.firstOrNull),
    );
    return BoxCryptoManagerAsync(_isolated, cmRef);
  }
}
