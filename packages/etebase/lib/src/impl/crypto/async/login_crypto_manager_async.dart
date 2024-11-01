import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../login_crypto_manager.dart';
import '../sync/login_crypto_manager_sync.dart';
import 'crypto_manager_base_async.dart';
import 'isolated_crypto_manager.dart';

@internal
final class LoginCryptoManagerAsync
    extends CryptoManagerBaseAsync<LoginCryptoManagerSync>
    implements LoginCryptoManager {
  final KeyPair _keyPair;

  LoginCryptoManagerAsync(super.isolated, this._keyPair);

  @override
  Uint8List get pubKey => _keyPair.publicKey;

  @override
  Future<CryptoManagerRef<LoginCryptoManagerSync>> initSync() =>
      isolated.createCryptoManager(
        keyPairs: [_keyPair],
        cryptoManagerFactory: (sodium, _, keyPairs) =>
            LoginCryptoManagerSync(sodium, keyPairs[0]),
      );

  @override
  Future<void> dispose() {
    _keyPair.dispose();
    return super.dispose();
  }

  @override
  Future<Uint8List> signDetached(Uint8List message) =>
      exec((cm, _, __) => cm.signDetached(message));

  @override
  Future<bool> verifyDetached({
    required Uint8List message,
    required Uint8List signature,
    required Uint8List pubKey,
  }) =>
      exec(
        (cm, _, __) => cm.verifyDetached(
          message: message,
          signature: signature,
          pubKey: pubKey,
        ),
      );
}
