import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../main_crypto_manager.dart';
import '../sync/main_crypto_manager_sync.dart';
import 'account_crypto_manager_async.dart';
import 'box_crypto_manager_async.dart';
import 'crypto_manager_async.dart';
import 'isolated_crypto_manager.dart';
import 'login_crypto_manager_async.dart';

@internal
final class MainCryptoManagerAsync
    extends CryptoManagerAsync<MainCryptoManagerSync>
    implements MainCryptoManager {
  MainCryptoManagerAsync(super.isolated, super.key, super.version);

  @override
  SecureKey get mainKey => super.key;

  @override
  Future<CryptoManagerRef<MainCryptoManagerSync>> initManagerSync(
    SecureKey key,
    int version,
  ) =>
      isolated.createCryptoManager(
        secureKeys: [key],
        cryptoManagerFactory: (sodium, secureKeys, _) =>
            MainCryptoManagerSync(sodium, secureKeys[0], version),
      );

  @override
  Future<LoginCryptoManagerAsync> createLoginCryptoManager() async {
    final keyPair = await exec(
      (cm, _, __) => cm.sodium.crypto.sign.seedKeyPair(cm.asymmetricKeySeed),
    );
    return LoginCryptoManagerAsync(isolated, keyPair);
  }

  @override
  AccountCryptoManagerAsync createAccountCryptoManager(
    SecureKey privKey,
  ) =>
      AccountCryptoManagerAsync(isolated, privKey, version);

  @override
  BoxCryptoManagerAsync createIdentityCryptoManager(
    SecureKey privKey,
  ) =>
      BoxCryptoManagerAsync(
        isolated,
        KeyPair(
          publicKey: isolated.sodium.crypto.scalarmult.base(n: privKey),
          secretKey: privKey,
        ),
      );
}
