import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../storage_crypto_manager.dart';
import '../sync/storage_crypto_manager_sync.dart';
import 'crypto_manager_async.dart';
import 'isolated_crypto_manager.dart';

@internal
final class StorageCryptoManagerAsync
    extends CryptoManagerAsync<StorageCryptoManagerSync>
    implements StorageCryptoManager {
  StorageCryptoManagerAsync(super.isolated, super.key, super.version);

  @override
  Future<CryptoManagerRef<StorageCryptoManagerSync>> initManagerSync(
    SecureKey key,
    int version,
  ) =>
      isolated.createCryptoManager(
        secureKeys: [key],
        cryptoManagerFactory: (sodium, secureKeys, _) =>
            StorageCryptoManagerSync(sodium, secureKeys[0], version),
      );
}
