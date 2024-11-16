import 'package:meta/meta.dart';

import 'executors/crypto_executor.dart';

@internal
abstract interface class CryptoManagerBase {
  CryptoExecutor get executor;

  void dispose();
}
