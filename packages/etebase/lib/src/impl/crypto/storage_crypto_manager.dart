import 'package:meta/meta.dart';

import 'crypto_manager.dart';

@internal
class StorageCryptoManager extends CryptoManager {
  new(super.executor, super.key, super.version);

  @override
  String get context => 'Stor';
}
