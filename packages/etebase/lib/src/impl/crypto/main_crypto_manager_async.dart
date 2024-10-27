import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'account_crypto_manager.dart';
import 'box_crypto_manager.dart';
import 'box_crypto_manager_async.dart';
import 'crypto_manager_async.dart';
import 'login_crypto_manager.dart';
import 'login_crypto_manager_async.dart';
import 'main_crypto_manager.dart';

@internal
final class MainCryptoManagerAsync extends CryptoManagerAsync
    implements MainCryptoManager {
  MainCryptoManagerAsync(super.isolated);

  @override
  Future<LoginCryptoManager> createLoginCryptoManager() async {
    final keyPair = await isolated(
      (cm, _, __) => cm.sodium.crypto.sign.seedKeyPair(cm.asymmetricKeySeed),
    );
    return LoginCryptoManagerAsync(isolated, keyPair);
  }

  @override
  FutureOr<AccountCryptoManager> createAccountCryptoManager(
    SecureKey privKey,
  ) =>
      throw UnimplementedError();

  @override
  Future<BoxCryptoManager> createBoxCryptoManager(SecureKey privKey) async {
    final keyPair = await isolated(
      secureKey: [privKey],
      (cm, secureKeys, __) => KeyPair(
        publicKey: cm.sodium.crypto.scalarmult.base(n: secureKeys[0]),
        secretKey: secureKeys[0],
      ),
    );
    return BoxCryptoManagerAsync(isolated, keyPair);
  }
}
