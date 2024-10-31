import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'box_crypto_manager.dart';
import 'key_derivator.dart';
import 'main_crypto_manager.dart';
import 'storage_crypto_manager.dart';

@internal
abstract interface class CryptoService {
  static const currentVersion = 1;

  KeyDerivator get keyDerivator;

  FutureOr<void> dispose();

  Uint8List randomBytes(int length);

  SecureKey secureRandom(int length);

  SecureKey secureCopy(Uint8List bytes);

  FutureOr<MainCryptoManager> createMainCryptoManager(
    SecureKey key, {
    int version = currentVersion,
  });

  FutureOr<BoxCryptoManager> createIdentityCryptoManager([SecureKey? seed]);

  FutureOr<StorageCryptoManager> createStorageCryptoManager(
    SecureKey key, {
    int version = currentVersion,
  });
}
