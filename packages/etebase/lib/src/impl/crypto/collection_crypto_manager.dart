import 'package:meta/meta.dart';

import 'account_crypto_manager.dart';
import 'minimal_collection_crypto_manager.dart';

@internal
abstract interface class CollectionCryptoManager
    implements MinimalCollectionCryptoManager {
  AccountCryptoManager get accountCryptoManager;
}
