import 'package:meta/meta.dart';

import '../minimal_collection_crypto_manager.dart';
import '../sync/minimal_collection_crypto_manager_sync.dart';
import 'crypto_manager_async.dart';

@internal
base class MinimalCollectionCryptoManagerAsync<
        TCryptoManager extends MinimalCollectionCryptoManagerSync>
    extends CryptoManagerAsync<TCryptoManager>
    implements MinimalCollectionCryptoManager {
  MinimalCollectionCryptoManagerAsync(
    super.isolated,
    super.cmRef,
    super.version,
  );
}
