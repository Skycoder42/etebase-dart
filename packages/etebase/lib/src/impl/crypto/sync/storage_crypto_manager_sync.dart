import 'package:meta/meta.dart';

import '../storage_crypto_manager.dart';
import 'crypto_manager_sync.dart';

@internal
final class StorageCryptoManagerSync extends CryptoManagerSync
    implements StorageCryptoManager {
  StorageCryptoManagerSync(super.sodium, super.key, super.version);

  @override
  String get context => 'Stor';
}
