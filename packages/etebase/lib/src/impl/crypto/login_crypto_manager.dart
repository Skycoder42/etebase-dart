import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/crypto_executor.dart';
import 'crypto_manager_base.dart';

@internal
class LoginCryptoManager implements CryptoManagerBase {
  @protected
  @override
  final CryptoExecutor executor;
  final KeyPair _keyPair;

  LoginCryptoManager(this.executor, this._keyPair);

  Uint8List get pubKey => _keyPair.publicKey;

  @override
  void dispose() => _keyPair.dispose();

  FutureOr<Uint8List> signDetached(Uint8List message) => executor.exec(
        secureKeys: [_keyPair.secretKey],
        (sodium, secureKeys, _) => sodium.crypto.sign.detached(
          message: message,
          secretKey: secureKeys.single,
        ),
      );

  FutureOr<bool> verifyDetached({
    required Uint8List message,
    required Uint8List signature,
    required Uint8List pubKey,
  }) =>
      executor.exec(
        (sodium, _, __) => sodium.crypto.sign.verifyDetached(
          message: message,
          signature: signature,
          publicKey: pubKey,
        ),
      );
}
