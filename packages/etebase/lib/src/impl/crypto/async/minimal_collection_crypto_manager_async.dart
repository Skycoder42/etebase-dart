import 'package:meta/meta.dart';
import 'package:sodium/src/api/secure_key.dart';

import '../minimal_collection_crypto_manager.dart';
import '../sync/minimal_collection_crypto_manager_sync.dart';
import 'crypto_manager_async.dart';
import 'isolated_crypto_manager.dart';

@internal
base class MinimalCollectionCryptoManagerAsync<
        TCryptoManager extends MinimalCollectionCryptoManagerSync>
    extends CryptoManagerAsync<TCryptoManager>
    implements MinimalCollectionCryptoManager {
  MinimalCollectionCryptoManagerAsync(
    super.isolated,
    super.key,
    super.version,
  );

  @override
  @mustBeOverridden
  Future<CryptoManagerRef<TCryptoManager>> initManagerSync(
    SecureKey key,
    int version,
  ) =>
      isolated.createCryptoManager(
        secureKeys: [key],
        cryptoManagerFactory: (sodium, secureKeys, keyPairs) =>
            MinimalCollectionCryptoManagerSync(sodium, secureKeys[0], version)
                as TCryptoManager,
      );
}
