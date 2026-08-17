import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'account_crypto_manager.dart';
import 'box_crypto_manager.dart';
import 'crypto_manager.dart';
import 'login_crypto_manager.dart';

@internal
class MainCryptoManager extends CryptoManager {
  new(super.executor, super.key, super.version);

  @override
  String get context => 'Main';

  SecureKey get mainKey => super.key;

  LoginCryptoManager createLoginCryptoManager() => LoginCryptoManager(
    executor,
    executor.execSync(
      (sodium) => sodium.crypto.sign.seedKeyPair(asymmetricKeySeed),
    ),
  );

  AccountCryptoManager createAccountCryptoManager(SecureKey privkey) =>
      AccountCryptoManager(executor, privkey, version);

  BoxCryptoManager createIdentityCryptoManager(SecureKey privkey) =>
      BoxCryptoManager(
        executor,
        executor.execSync(
          (sodium) => KeyPair(
            publicKey: sodium.crypto.scalarmult.base(n: privkey),
            secretKey: privkey,
          ),
        ),
      );
}
