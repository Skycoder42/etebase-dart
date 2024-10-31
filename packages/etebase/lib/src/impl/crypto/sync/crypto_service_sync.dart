import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../crypto_service.dart';
import '../key_derivator.dart';
import 'box_crypto_manager_sync.dart';
import 'main_crypto_manager_sync.dart';

@internal
final class CryptoServiceSync implements CryptoService {
  final SodiumSumo _sodium;

  CryptoServiceSync(this._sodium);

  @override
  late final keyDerivator = KeyDerivator(_sodium);

  @override
  void dispose() {}

  @override
  Uint8List randomBytes(int length) => _sodium.randombytes.buf(length);

  @override
  SecureKey secureRandom(int length) => _sodium.secureRandom(length);

  @override
  SecureKey secureCopy(Uint8List bytes) => _sodium.secureCopy(bytes);

  @override
  MainCryptoManagerSync createMainCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) =>
      MainCryptoManagerSync(_sodium, key, version);

  @override
  BoxCryptoManagerSync createIdentityCryptoManager([SecureKey? seed]) =>
      BoxCryptoManagerSync.fromSeed(_sodium, seed);
}
