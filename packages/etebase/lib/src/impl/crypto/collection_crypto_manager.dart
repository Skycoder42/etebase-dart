import 'package:meta/meta.dart';

import 'account_crypto_manager.dart';
import 'minimal_collection_crypto_manager.dart';

@internal
class CollectionCryptoManager extends MinimalCollectionCryptoManager {
  final AccountCryptoManager accountCryptoManager;

  CollectionCryptoManager(
    super.executor,
    this.accountCryptoManager,
    super.key,
    super.version,
  );
}
