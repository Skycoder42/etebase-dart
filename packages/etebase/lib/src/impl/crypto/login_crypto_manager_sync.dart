import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'login_crypto_manager.dart';

@internal
class LoginCryptoManagerSync implements LoginCryptoManager {
  final SodiumSumo _sodium;
  final KeyPair _keyPair;

  LoginCryptoManagerSync(this._sodium, this._keyPair);

  @override
  Uint8List get pubKey => _keyPair.publicKey;

  @override
  void dispose() => _keyPair.dispose();

  @override
  Uint8List signDetached(Uint8List message) => _sodium.crypto.sign.detached(
        message: message,
        secretKey: _keyPair.secretKey,
      );

  @override
  bool verifyDetached({
    required Uint8List message,
    required Uint8List signature,
    required Uint8List pubKey,
  }) =>
      _sodium.crypto.sign.verifyDetached(
        message: message,
        signature: signature,
        publicKey: pubKey,
      );
}
