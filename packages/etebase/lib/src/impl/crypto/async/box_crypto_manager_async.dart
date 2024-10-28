import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../box_crypto_manager.dart';
import '../sync/box_crypto_manager_sync.dart';
import 'isolated_crypto_manager.dart';

@internal
class BoxCryptoManagerAsync implements BoxCryptoManager {
  final IsolatedCryptoManager _isolated;
  final CryptoManagerRef<BoxCryptoManagerSync> _cmRef;

  BoxCryptoManagerAsync(this._isolated, this._cmRef);

  @override
  Future<Uint8List> get pubKey => _isolated(_cmRef, (cm, _, __) => cm.pubKey);

  @override
  Future<SecureKey> get privKey => _isolated(_cmRef, (cm, _, __) => cm.privKey);

  @override
  Future<void> dispose() => _isolated.disposeCryptoManager(_cmRef);

  @override
  Future<Uint8List> encrypt({
    required Uint8List message,
    required Uint8List pubKey,
  }) =>
      _isolated(
        _cmRef,
        (cm, _, __) => cm.encrypt(message: message, pubKey: pubKey),
      );

  @override
  Future<Uint8List> decrypt({
    required Uint8List nonceCipherText,
    required Uint8List pubKey,
  }) =>
      _isolated(
        _cmRef,
        (cm, _, __) =>
            cm.decrypt(nonceCipherText: nonceCipherText, pubKey: pubKey),
      );
}
