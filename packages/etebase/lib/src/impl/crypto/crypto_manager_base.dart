import 'dart:async';

import 'package:meta/meta.dart';

@internal
abstract interface class CryptoManagerBase {
  FutureOr<void> dispose();
}

@internal
abstract interface class CryptoManagerBaseSync implements CryptoManagerBase {
  @override
  void dispose();
}
