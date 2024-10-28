import 'dart:async';

import 'package:meta/meta.dart';

@internal
abstract interface class ICryptoManager {
  FutureOr<void> dispose();
}

@internal
abstract interface class ICryptoManagerSync implements ICryptoManager {
  @override
  void dispose();
}
