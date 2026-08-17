import 'package:meta/meta.dart';

import 'crypto_manager.dart';

@internal
class MinimalCollectionCryptoManager extends CryptoManager {
  new(super.executor, super.key, super.version);

  @override
  String get context => 'Col';
}
