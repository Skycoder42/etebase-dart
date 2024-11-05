import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../crypto_service.dart';
import 'box_crypto_manager_async.dart';
import 'isolated_crypto_manager.dart';
import 'main_crypto_manager_async.dart';
import 'storage_crypto_manager_async.dart';

@internal
final class CryptoServiceAsync
    with CryptoServiceCommon
    implements CryptoService {
  final IsolatedCryptoManager _isolated;

  CryptoServiceAsync(this._isolated);

  factory CryptoServiceAsync.fromSodium(SodiumSumo sodium) =>
      CryptoServiceAsync(IsolatedCryptoManager(sodium));

  @override
  SodiumSumo get sodium => _isolated.sodium;

  @override
  Future<void> dispose() => _isolated.dispose();

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
