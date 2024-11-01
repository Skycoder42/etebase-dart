import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../box_crypto_manager.dart';
import '../crypto_manager_base.dart';
import '../crypto_utils.dart';

@internal
class BoxCryptoManagerSync implements BoxCryptoManager, CryptoManagerBaseSync {
  final SodiumSumo _sodium;
  final KeyPair _keyPair;

  BoxCryptoManagerSync(this._sodium, this._keyPair);

  factory BoxCryptoManagerSync.fromSeed(
    SodiumSumo sodium, [
    SecureKey? seed,
  ]) {
    final cm = BoxCryptoManagerSync(
      sodium,
      seed != null
          ? sodium.crypto.box.seedKeyPair(seed)
          : sodium.crypto.box.keyPair(),
    );
    seed?.dispose();
    return cm;
  }

  @override
  Uint8List get pubKey => _keyPair.publicKey;

  @override
  SecureKey get privKey => _keyPair.secretKey;

  @override
  void dispose() => _keyPair.dispose();

  @override
  Uint8List encrypt({
    required Uint8List message,
    required Uint8List pubKey,
  }) {
    final nonce = _sodium.randombytes.buf(_sodium.crypto.box.nonceBytes);
    final result = _sodium.crypto.box.easy(
      message: message,
      nonce: nonce,
      publicKey: pubKey,
      secretKey: _keyPair.secretKey,
    );
    return CryptoUtils.concat([nonce, result]);
  }

  @override
  Uint8List decrypt({
    required Uint8List nonceCipherText,
    required Uint8List pubKey,
  }) {
    final (nonce, cipherText) = CryptoUtils.split2(
      nonceCipherText,
      _sodium.crypto.box.nonceBytes,
    );
    return _sodium.crypto.box.openEasy(
      cipherText: cipherText,
      nonce: nonce,
      publicKey: pubKey,
      secretKey: _keyPair.secretKey,
    );
  }
}
