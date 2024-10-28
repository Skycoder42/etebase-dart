import 'package:meta/meta.dart';

import '../storage_crypto_manager.dart';
import '../sync/storage_crypto_manager_sync.dart';
import 'crypto_manager_async.dart';

@internal
final class StorageCryptoManagerAsync
    extends CryptoManagerAsync<StorageCryptoManagerSync>
    implements StorageCryptoManager {
  StorageCryptoManagerAsync(super.isolated, super.cmRef, super.version);
}
