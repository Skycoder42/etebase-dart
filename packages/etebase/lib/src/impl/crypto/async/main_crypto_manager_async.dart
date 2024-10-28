import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../main_crypto_manager.dart';
import '../sync/main_crypto_manager_sync.dart';
import 'account_crypto_manager_async.dart';
import 'box_crypto_manager_async.dart';
import 'crypto_manager_async.dart';
import 'login_crypto_manager_async.dart';

@internal
final class MainCryptoManagerAsync
    extends CryptoManagerAsync<MainCryptoManagerSync>
    implements MainCryptoManager {
  MainCryptoManagerAsync(super.isolated, super.cmRef, super.version);

  @override
  Future<LoginCryptoManagerAsync> createLoginCryptoManager() async {
    final loginRef = await isolated.createCryptoManagerWithParent(
      parentRef: cmRef,
      cryptoManagerFactory: (cm, _, __) => cm.createLoginCryptoManager(),
    );
    return LoginCryptoManagerAsync(isolated, loginRef);
  }

  @override
  Future<AccountCryptoManagerAsync> createAccountCryptoManager(
    SecureKey privKey,
  ) async {
    final accountRef = await isolated.createCryptoManagerWithParent(
      parentRef: cmRef,
      secureKeys: [privKey],
      cryptoManagerFactory: (cm, secureKeys, __) =>
          cm.createAccountCryptoManager(secureKeys[0]),
    );
    return AccountCryptoManagerAsync(isolated, accountRef, version);
  }

  @override
  Future<BoxCryptoManagerAsync> createBoxCryptoManager(
    SecureKey privKey,
  ) async {
    final boxRef = await isolated.createCryptoManagerWithParent(
      parentRef: cmRef,
      secureKeys: [privKey],
      cryptoManagerFactory: (cm, secureKeys, __) =>
          cm.createBoxCryptoManager(secureKeys[0]),
    );
    return BoxCryptoManagerAsync(isolated, boxRef);
  }
}
