import 'package:meta/meta.dart';

import '../minimal_collection_crypto_manager.dart';
import 'crypto_manager_sync.dart';

@internal
base class MinimalCollectionCryptoManagerSync extends CryptoManagerSync
    implements MinimalCollectionCryptoManager {
  MinimalCollectionCryptoManagerSync(super.sodium, super.key, super.version);

  @override
  String get context => 'Col';
}
