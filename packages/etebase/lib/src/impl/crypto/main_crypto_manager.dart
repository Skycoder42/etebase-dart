import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'account_crypto_manager.dart';
import 'box_crypto_manager.dart';
import 'crypto_manager.dart';
import 'login_crypto_manager.dart';

@internal
abstract interface class MainCryptoManager implements CryptoManager {
  SecureKey get mainKey;

  FutureOr<LoginCryptoManager> createLoginCryptoManager();

  AccountCryptoManager createAccountCryptoManager(SecureKey privKey);

  BoxCryptoManager createIdentityCryptoManager(SecureKey privKey);
}
