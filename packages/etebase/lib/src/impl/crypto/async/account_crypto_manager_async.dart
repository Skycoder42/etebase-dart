import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../account_crypto_manager.dart';
import '../crypto_service.dart';
import '../sync/account_crypto_manager_sync.dart';
import 'collection_crypto_manager_async.dart';
import 'crypto_manager_async.dart';
import 'isolated_crypto_manager.dart';

@internal
final class AccountCryptoManagerAsync
    extends CryptoManagerAsync<AccountCryptoManagerSync>
    implements AccountCryptoManager {
  AccountCryptoManagerAsync(super.isolated, super.key, super.version);

  @override
  Future<CryptoManagerRef<AccountCryptoManagerSync>> initManagerSync(
    SecureKey key,
    int version,
  ) =>
      isolated.createCryptoManager(
        secureKeys: [key],
        cryptoManagerFactory: (sodium, secureKeys, _) =>
            AccountCryptoManagerSync(sodium, secureKeys[0], version),
      );

  @override
  Future<Uint8List> colTypeToUid(String colId) =>
      exec((cm, _, __) => cm.colTypeToUid(colId));

  @override
  Future<String> colTypeFromUid(Uint8List uid) =>
      exec((cm, _, __) => cm.colTypeFromUid(uid));

  @override
  CollectionCryptoManagerAsync createCollectionCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) =>
      CollectionCryptoManagerAsync(isolated, this, key, version);
}
