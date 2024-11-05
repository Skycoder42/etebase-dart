import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../crypto_service.dart';
import 'box_crypto_manager_sync.dart';
import 'main_crypto_manager_sync.dart';
import 'storage_crypto_manager_sync.dart';

@internal
final class CryptoServiceSync
    with CryptoServiceCommon
    implements CryptoService {
  @override
  final SodiumSumo sodium;

  CryptoServiceSync(this.sodium);

  @override
  void dispose() {}

  @override
  MainCryptoManagerSync createMainCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) =>
      MainCryptoManagerSync(sodium, key, version);

  @override
  BoxCryptoManagerSync createIdentityCryptoManager([SecureKey? seed]) =>
      BoxCryptoManagerSync.fromSeed(sodium, seed);

  @override
  StorageCryptoManagerSync createStorageCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) =>
      StorageCryptoManagerSync(sodium, key, version);
}
