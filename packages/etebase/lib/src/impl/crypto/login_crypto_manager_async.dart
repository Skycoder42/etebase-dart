import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'isolated_crypto_manager.dart';
import 'login_crypto_manager.dart';

@internal
class LoginCryptoManagerAsync implements LoginCryptoManager {
  final IsolatedCryptoManager _isolated;
  final KeyPair _keyPair;

  LoginCryptoManagerAsync(this._isolated, this._keyPair);

  @override
  Uint8List get pubKey => _keyPair.publicKey;

  @override
  void dispose() => _keyPair.dispose();

  @override
  Future<Uint8List> signDetached(Uint8List message) => _isolated(
        secureKey: [_keyPair.secretKey],
        (cm, secureKeys, _) => cm.sodium.crypto.sign.detached(
          message: message,
          secretKey: secureKeys[0],
        ),
      );

  @override
  Future<bool> verifyDetached({
    required Uint8List message,
    required Uint8List signature,
    required Uint8List pubKey,
  }) =>
      _isolated(
        (cm, _, __) => cm.sodium.crypto.sign.verifyDetached(
          message: message,
          signature: signature,
          publicKey: pubKey,
        ),
      );
}
