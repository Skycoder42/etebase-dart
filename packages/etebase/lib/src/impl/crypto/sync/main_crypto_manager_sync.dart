import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../main_crypto_manager.dart';
import 'account_crypto_manager_sync.dart';
import 'box_crypto_manager_sync.dart';
import 'crypto_manager_sync.dart';
import 'login_crypto_manager_sync.dart';

@internal
final class MainCryptoManagerSync extends CryptoManagerSync
    implements MainCryptoManager {
  MainCryptoManagerSync(super.sodium, super.key, super.version);

  @override
  String get context => 'Main';

  @override
  LoginCryptoManagerSync createLoginCryptoManager() => LoginCryptoManagerSync(
        sodium,
        sodium.crypto.sign.seedKeyPair(asymmetricKeySeed),
      );

  @override
  AccountCryptoManagerSync createAccountCryptoManager(SecureKey privKey) =>
      AccountCryptoManagerSync(sodium, privKey, version);

  @override
  BoxCryptoManagerSync createIdentityCryptoManager(SecureKey privKey) =>
      BoxCryptoManagerSync(
        sodium,
        KeyPair(
          publicKey: sodium.crypto.scalarmult.base(n: privKey),
          secretKey: privKey.copy(),
        ),
      );
}
