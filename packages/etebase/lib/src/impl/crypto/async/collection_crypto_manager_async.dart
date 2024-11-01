import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../collection_crypto_manager.dart';
import '../sync/collection_crypto_manager_sync.dart';
import 'account_crypto_manager_async.dart';
import 'isolated_crypto_manager.dart';
import 'minimal_collection_crypto_manager_async.dart';

@internal
final class CollectionCryptoManagerAsync
    extends MinimalCollectionCryptoManagerAsync<CollectionCryptoManagerSync>
    implements CollectionCryptoManager {
  @override
  final AccountCryptoManagerAsync accountCryptoManager;

  CollectionCryptoManagerAsync(
    super.isolated,
    this.accountCryptoManager,
    super.key,
    super.version,
  );

  // TODO dispose account manager?

  @override
  Future<CryptoManagerRef<CollectionCryptoManagerSync>> initManagerSync(
    SecureKey key,
    int version,
  ) async =>
      isolated.createCryptoManagerWithRef(
        ref: await accountCryptoManager.cmRef,
        secureKeys: [key],
        cryptoManagerFactory: (accountManager, secureKeys, _) =>
            CollectionCryptoManagerSync(
          accountManager.sodium,
          accountManager,
          secureKeys[0],
          version,
        ),
      );
}
