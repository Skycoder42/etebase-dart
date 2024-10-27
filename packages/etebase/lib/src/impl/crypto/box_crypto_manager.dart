import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

@internal
abstract interface class BoxCryptoManager {
  Uint8List get pubKey;

  SecureKey get privKey;

  void dispose();

  FutureOr<Uint8List> encrypt({
    required Uint8List message,
    required Uint8List pubKey,
  });

  FutureOr<Uint8List> decrypt({
    required Uint8List nonceCipherText,
    required Uint8List pubKey,
  });
}
