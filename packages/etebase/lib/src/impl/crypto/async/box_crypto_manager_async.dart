import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../box_crypto_manager.dart';
import '../sync/box_crypto_manager_sync.dart';
import 'crypto_manager_base_async.dart';
import 'isolated_crypto_manager.dart';

@internal
final class BoxCryptoManagerAsync
    extends CryptoManagerBaseAsync<BoxCryptoManagerSync>
    implements BoxCryptoManager {
  final KeyPair _keyPair;

  BoxCryptoManagerAsync(super.isolated, this._keyPair);

  factory BoxCryptoManagerAsync.fromSeed(
    IsolatedCryptoManager isolated, [
    SecureKey? seed,
  ]) {
    final cm = BoxCryptoManagerAsync(
      isolated,
      seed != null
          ? isolated.sodium.crypto.box.seedKeyPair(seed)
          : isolated.sodium.crypto.box.keyPair(),
    );
    seed?.dispose();
    return cm;
  }

  @override
  Uint8List get pubKey => _keyPair.publicKey;

  @override
  SecureKey get privKey => _keyPair.secretKey;

  @override
  Future<CryptoManagerRef<BoxCryptoManagerSync>> initSync() =>
      isolated.createCryptoManager(
        keyPairs: [_keyPair],
        cryptoManagerFactory: (sodium, _, keyPairs) =>
            BoxCryptoManagerSync(sodium, keyPairs[0]),
      );

  @override
  Future<void> dispose() {
    _keyPair.dispose();
    return super.dispose();
  }

  @override
  Future<Uint8List> encrypt({
    required Uint8List message,
    required Uint8List pubKey,
  }) =>
      exec(
        (cm, _, __) => cm.encrypt(message: message, pubKey: pubKey),
      );

  @override
  Future<Uint8List> decrypt({
    required Uint8List nonceCipherText,
    required Uint8List pubKey,
  }) =>
      exec(
        (cm, _, __) =>
            cm.decrypt(nonceCipherText: nonceCipherText, pubKey: pubKey),
      );
}
