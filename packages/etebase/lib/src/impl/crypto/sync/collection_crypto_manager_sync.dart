import 'package:meta/meta.dart';

import '../collection_crypto_manager.dart';
import 'account_crypto_manager_sync.dart';
import 'minimal_collection_crypto_manager_sync.dart';

@internal
final class CollectionCryptoManagerSync
    extends MinimalCollectionCryptoManagerSync
    implements CollectionCryptoManager {
  @override
  final AccountCryptoManagerSync accountCryptoManager;

  CollectionCryptoManagerSync(
    super.sodium,
    this.accountCryptoManager,
    super.key,
    super.version,
  );
}
