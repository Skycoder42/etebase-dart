import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../account_crypto_manager.dart';
import '../collection_crypto_manager.dart';
import '../collection_item_crypto_manager.dart';
import '../crypto_service.dart';
import '../minimal_collection_crypto_manager.dart';
import 'account_crypto_manager_sync.dart';
import 'box_crypto_manager_sync.dart';
import 'collection_crypto_manager_sync.dart';
import 'collection_item_crypto_manager_sync.dart';
import 'main_crypto_manager_sync.dart';
import 'minimal_collection_crypto_manager_sync.dart';
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

  @override
  CollectionCryptoManager createCollectionCryptoManager(
    AccountCryptoManager parentCryptoManager,
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) =>
      CollectionCryptoManagerSync(
        sodium,
        parentCryptoManager as AccountCryptoManagerSync,
        key,
        version,
      );

  @override
  CollectionItemCryptoManager createCollectionItemCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) =>
      CollectionItemCryptoManagerSync(sodium, key, version);

  @override
  MinimalCollectionCryptoManager createMinimalCollectionCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) =>
      MinimalCollectionCryptoManagerSync(sodium, key, version);
}
