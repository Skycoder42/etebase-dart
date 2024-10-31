import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../crypto_service.dart';
import '../key_derivator.dart';
import '../sync/box_crypto_manager_sync.dart';
import '../sync/main_crypto_manager_sync.dart';
import 'box_crypto_manager_async.dart';
import 'isolated_crypto_manager.dart';
import 'main_crypto_manager_async.dart';

@internal
final class CryptoServiceAsync implements CryptoService {
  final IsolatedCryptoManager _isolated;

  CryptoServiceAsync(this._isolated);

  factory CryptoServiceAsync.fromSodium(SodiumSumo sodium) =>
      CryptoServiceAsync(IsolatedCryptoManager(sodium));

  @override
  late final keyDerivator = KeyDerivator(_isolated.sodium);

  @override
  Future<void> dispose() async => _isolated.dispose();

  @override
  Uint8List randomBytes(int length) => _isolated.sodium.randombytes.buf(length);

  @override
  SecureKey secureRandom(int length) => _isolated.sodium.secureRandom(length);

  @override
  SecureKey secureCopy(Uint8List bytes) => _isolated.sodium.secureCopy(bytes);

  @override
  Future<MainCryptoManagerAsync> createMainCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) async {
    final cmRef = await _isolated.createCryptoManager(
      secureKeys: [key],
      cryptoManagerFactory: (sodium, secureKeys, _) =>
          MainCryptoManagerSync(sodium, secureKeys[0], version),
    );
    return MainCryptoManagerAsync(_isolated, cmRef, version);
  }

  @override
  Future<BoxCryptoManagerAsync> createIdentityCryptoManager([
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
