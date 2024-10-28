import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../crypto_manager_factory.dart';
import 'box_crypto_manager_sync.dart';
import 'main_crypto_manager_sync.dart';

@internal
final class CryptoManagerFactorySync implements CryptoManagerFactory {
  final SodiumSumo _sodium;

  CryptoManagerFactorySync(this._sodium);

  @override
  MainCryptoManagerSync createMainCryptoManager(
    SecureKey key, [
    int version = CryptoManagerFactory.currentVersion,
  ]) =>
      MainCryptoManagerSync(_sodium, key, version);

  @override
  BoxCryptoManagerSync createBoxCryptoManager([SecureKey? seed]) =>
      BoxCryptoManagerSync.fromSeed(_sodium, seed);
}
