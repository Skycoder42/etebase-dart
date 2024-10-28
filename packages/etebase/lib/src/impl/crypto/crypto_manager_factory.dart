import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'box_crypto_manager.dart';
import 'main_crypto_manager.dart';

@internal
abstract interface class CryptoManagerFactory {
  static const currentVersion = 1;

  FutureOr<MainCryptoManager> createMainCryptoManager(
    SecureKey key, [
    int version = currentVersion,
  ]);

  FutureOr<BoxCryptoManager> createBoxCryptoManager([SecureKey? seed]);
}
