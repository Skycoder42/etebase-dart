import 'package:meta/meta.dart';

import 'crypto_manager.dart';

@internal
class CollectionItemCryptoManager extends CryptoManager {
  CollectionItemCryptoManager(super.executor, super.key, super.version);

  @override
  String get context => 'ColItem';
}
