import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'account_crypto_manager.dart';
import 'box_crypto_manager.dart';
import 'box_crypto_manager_sync.dart';
import 'crypto_manager_sync.dart';
import 'login_crypto_manager.dart';
import 'login_crypto_manager_sync.dart';
import 'main_crypto_manager.dart';

@internal
final class MainCryptoManagerSync extends CryptoManagerSync
    implements MainCryptoManager {
  MainCryptoManagerSync(super.sodium, super.key, super.version);

  @override
  String get context => 'Main';

  @override
  LoginCryptoManager createLoginCryptoManager() => LoginCryptoManagerSync(
        sodium,
        sodium.crypto.sign.seedKeyPair(asymmetricKeySeed),
      );

  @override
  AccountCryptoManager createAccountCryptoManager(SecureKey privKey) =>
      throw UnimplementedError();

  @override
  BoxCryptoManager createBoxCryptoManager(SecureKey privKey) =>
      BoxCryptoManagerSync(
        sodium,
        KeyPair(
          publicKey: sodium.crypto.scalarmult.base(n: privKey),
          secretKey: privKey,
        ),
      );
}
