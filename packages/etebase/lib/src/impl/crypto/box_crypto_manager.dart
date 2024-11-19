import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/crypto_executor.dart';
import 'crypto_manager_base.dart';
import 'crypto_utils.dart';

@internal
class BoxCryptoManager implements CryptoManagerBase {
  @override
  @protected
  final CryptoExecutor executor;
  final KeyPair _keyPair;
  var _disposed = false;

  BoxCryptoManager(this.executor, this._keyPair);

  factory BoxCryptoManager.fromSeed(
    CryptoExecutor executor, [
    SecureKey? seed,
  ]) {
    final cm = BoxCryptoManager(
      executor,
      executor.execSync(
        (sodium) => seed != null
            ? sodium.crypto.box.seedKeyPair(seed)
            : sodium.crypto.box.keyPair(),
      ),
    );
    seed?.dispose();
    return cm;
  }

  Uint8List get pubkey => _keyPair.publicKey;

  SecureKey get privkey => _keyPair.secretKey;

  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _keyPair.dispose();
    }
  }

  FutureOr<Uint8List> encrypt({
    required Uint8List message,
    required Uint8List pubkey,
  }) =>
      executor.exec(
        secureKeys: [_keyPair.secretKey],
        (sodium, secureKeys, _) {
          final nonce = sodium.randombytes.buf(sodium.crypto.box.nonceBytes);
          final result = sodium.crypto.box.easy(
            message: message,
            nonce: nonce,
            publicKey: pubkey,
            secretKey: secureKeys.single,
          );
          return CryptoUtils.concat([nonce, result]);
        },
      );

  FutureOr<Uint8List> decrypt({
    required Uint8List nonceCipherText,
    required Uint8List pubkey,
  }) =>
      executor.exec(
        secureKeys: [_keyPair.secretKey],
        (sodium, secureKeys, _) {
          final (nonce, cipherText) = CryptoUtils.split2(
            nonceCipherText,
            sodium.crypto.box.nonceBytes,
          );
          return sodium.crypto.box.openEasy(
            cipherText: cipherText,
            nonce: nonce,
            publicKey: pubkey,
            secretKey: secureKeys.single,
          );
        },
      );
}
