import 'package:meta/meta.dart';

import '../collection_item_crypto_manager.dart';
import '../sync/collection_item_crypto_manager_sync.dart';
import 'crypto_manager_async.dart';

@internal
final class CollectionItemCryptoManagerAsync
    extends CryptoManagerAsync<CollectionItemCryptoManagerSync>
    implements CollectionItemCryptoManager {
  CollectionItemCryptoManagerAsync(super.isolated, super.cmRef, super.version);
}
