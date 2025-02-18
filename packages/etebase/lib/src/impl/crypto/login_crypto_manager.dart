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
  @visibleForTesting
  final CryptoExecutor executor;

  @visibleForTesting
  final KeyPair keyPair;

  var _disposed = false;

  LoginCryptoManager(this.executor, this.keyPair);

  Uint8List get pubkey => keyPair.publicKey;

  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      keyPair.dispose();
    }
  }

  FutureOr<Uint8List> signDetached(Uint8List message) => executor.exec(
    secureKeys: [keyPair.secretKey],
    (sodium, secureKeys, _) => sodium.crypto.sign.detached(
      message: message,
      secretKey: secureKeys.single,
    ),
  );

  FutureOr<bool> verifyDetached({
    required Uint8List message,
    required Uint8List signature,
    required Uint8List pubkey,
  }) => executor.exec(
    (sodium, _, _) => sodium.crypto.sign.verifyDetached(
      message: message,
      signature: signature,
      publicKey: pubkey,
    ),
  );
}
