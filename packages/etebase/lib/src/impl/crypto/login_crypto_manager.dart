import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'crypto_manager_base.dart';

@internal
abstract interface class LoginCryptoManager implements CryptoManagerBase {
  Uint8List get pubKey;

  FutureOr<Uint8List> signDetached(Uint8List message);

  FutureOr<bool> verifyDetached({
    required Uint8List message,
    required Uint8List signature,
    required Uint8List pubKey,
  });
}
