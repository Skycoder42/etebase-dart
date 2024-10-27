import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'crypto_manager.dart';

@internal
abstract interface class AccountCryptoManager implements CryptoManager {
  FutureOr<Uint8List> colTypeToUid(String colId);

  FutureOr<String> colTypeFromUid(Uint8List uid);
}
