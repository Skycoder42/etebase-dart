import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../crypto_service.dart';
import '../key_derivator.dart';
import 'box_crypto_manager_async.dart';
import 'isolated_crypto_manager.dart';
import 'main_crypto_manager_async.dart';
import 'storage_crypto_manager_async.dart';

@internal
final class CryptoServiceAsync implements CryptoService {
  final IsolatedCryptoManager _isolated;

  CryptoServiceAsync(this._isolated);

  factory CryptoServiceAsync.fromSodium(SodiumSumo sodium) =>
      CryptoServiceAsync(IsolatedCryptoManager(sodium));

  @override
  late final keyDerivator = KeyDerivator(_isolated.sodium);

  @override
  Future<void> dispose() => _isolated.dispose();

  @override
  Uint8List randomBytes(int length) => _isolated.sodium.randombytes.buf(length);

  @override
  SecureKey secureRandom(int length) => _isolated.sodium.secureRandom(length);

  @override
  SecureKey secureCopy(Uint8List bytes) => _isolated.sodium.secureCopy(bytes);

  @override
  Uint8List bufferPadSmall(Uint8List buffer) =>
      _isolated.sodium.pad(buffer, buffer.length + 1);

  @override
  MainCryptoManagerAsync createMainCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) =>
      MainCryptoManagerAsync(_isolated, key, version);

  @override
  BoxCryptoManagerAsync createIdentityCryptoManager([
    SecureKey? seed,
  ]) =>
      BoxCryptoManagerAsync.fromSeed(_isolated, seed);

  @override
  StorageCryptoManagerAsync createStorageCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) =>
      StorageCryptoManagerAsync(_isolated, key, version);
}
