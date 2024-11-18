import 'package:meta/meta.dart';

import '../../api/managers/crypto_executor.dart';

@internal
abstract interface class CryptoManagerBase {
  CryptoExecutor get executor;

  void dispose();
}
