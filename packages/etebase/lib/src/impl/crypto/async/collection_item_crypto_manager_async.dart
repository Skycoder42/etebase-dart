import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../collection_item_crypto_manager.dart';
import '../sync/collection_item_crypto_manager_sync.dart';
import 'crypto_manager_async.dart';
import 'isolated_crypto_manager.dart';

@internal
final class CollectionItemCryptoManagerAsync
    extends CryptoManagerAsync<CollectionItemCryptoManagerSync>
    implements CollectionItemCryptoManager {
  CollectionItemCryptoManagerAsync(super.isolated, super.key, super.version);

  @override
  Future<CryptoManagerRef<CollectionItemCryptoManagerSync>> initManagerSync(
    SecureKey key,
    int version,
  ) =>
      isolated.createCryptoManager(
        secureKeys: [key],
        cryptoManagerFactory: (sodium, secureKeys, _) =>
            CollectionItemCryptoManagerSync(sodium, secureKeys[0], version),
      );
}
