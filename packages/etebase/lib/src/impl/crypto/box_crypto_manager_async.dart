import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'box_crypto_manager.dart';
import 'box_crypto_manager_sync.dart';
import 'isolated_crypto_manager.dart';

@internal
class BoxCryptoManagerAsync implements BoxCryptoManager {
  final IsolatedCryptoManager _isolated;
  final KeyPair _keyPair;

  BoxCryptoManagerAsync(this._isolated, this._keyPair);

  factory BoxCryptoManagerAsync.fromSeed(
    IsolatedCryptoManager isolated, [
    SecureKey? seed,
  ]) =>
      BoxCryptoManagerAsync(
        isolated,
        seed != null
            ? isolated.sodium.crypto.box.seedKeyPair(seed)
            : isolated.sodium.crypto.box.keyPair(),
      );

  @override
  Uint8List get pubKey => _keyPair.publicKey;

  @override
  SecureKey get privKey => _keyPair.secretKey;

  @override
  void dispose() => _keyPair.dispose();

  @override
  Future<Uint8List> encrypt({
    required Uint8List message,
    required Uint8List pubKey,
  }) =>
      _isolated(
        keyPairs: [_keyPair],
        (cm, _, keyPairs) => BoxCryptoManagerSync(cm.sodium, keyPairs[0])
            .encrypt(message: message, pubKey: pubKey),
      );

  @override
  Future<Uint8List> decrypt({
    required Uint8List nonceCipherText,
    required Uint8List pubKey,
  }) =>
      _isolated(
        keyPairs: [_keyPair],
        (cm, _, keyPairs) => BoxCryptoManagerSync(cm.sodium, keyPairs[0])
            .decrypt(nonceCipherText: nonceCipherText, pubKey: pubKey),
      );
}
