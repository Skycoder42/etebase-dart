import 'package:meta/meta.dart';

import '../collection_item_crypto_manager.dart';
import 'crypto_manager_sync.dart';

@internal
final class CollectionItemCryptoManagerSync extends CryptoManagerSync
    implements CollectionItemCryptoManager {
  CollectionItemCryptoManagerSync(super.sodium, super.key, super.version);

  @override
  String get context => 'ColItem';
}
