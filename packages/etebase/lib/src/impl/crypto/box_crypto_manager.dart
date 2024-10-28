import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'i_crypto_manager.dart';

@internal
abstract interface class BoxCryptoManager implements ICryptoManager {
  FutureOr<Uint8List> get pubKey;

  FutureOr<SecureKey> get privKey;

  FutureOr<Uint8List> encrypt({
    required Uint8List message,
    required Uint8List pubKey,
  });

  FutureOr<Uint8List> decrypt({
    required Uint8List nonceCipherText,
    required Uint8List pubKey,
  });
}
