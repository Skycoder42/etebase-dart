import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'account_crypto_manager.dart';
import 'box_crypto_manager.dart';
import 'crypto_manager.dart';
import 'login_crypto_manager.dart';

@internal
abstract interface class MainCryptoManager implements CryptoManager {
  FutureOr<LoginCryptoManager> createLoginCryptoManager();

  FutureOr<AccountCryptoManager> createAccountCryptoManager(SecureKey privKey);

  FutureOr<BoxCryptoManager> createIdentityCryptoManager(SecureKey privKey);
}
