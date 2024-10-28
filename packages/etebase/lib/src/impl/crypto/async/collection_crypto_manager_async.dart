import 'package:meta/meta.dart';

import '../collection_crypto_manager.dart';
import '../sync/collection_crypto_manager_sync.dart';
import 'account_crypto_manager_async.dart';
import 'minimal_collection_crypto_manager_async.dart';

@internal
final class CollectionCryptoManagerAsync
    extends MinimalCollectionCryptoManagerAsync<CollectionCryptoManagerSync>
    implements CollectionCryptoManager {
  @override
  final AccountCryptoManagerAsync accountCryptoManager;

  CollectionCryptoManagerAsync(
    super.isolated,
    this.accountCryptoManager,
    super.cmRef,
    super.version,
  );
}
