import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../login_crypto_manager.dart';
import '../sync/login_crypto_manager_sync.dart';
import 'isolated_crypto_manager.dart';

@internal
class LoginCryptoManagerAsync implements LoginCryptoManager {
  final IsolatedCryptoManager _isolated;
  final CryptoManagerRef<LoginCryptoManagerSync> _cmRef;

  LoginCryptoManagerAsync(this._isolated, this._cmRef);

  @override
  Future<Uint8List> get pubKey => _isolated(_cmRef, (cm, _, __) => cm.pubKey);

  @override
  Future<void> dispose() => _isolated.disposeCryptoManager(_cmRef);

  @override
  Future<Uint8List> signDetached(Uint8List message) =>
      _isolated(_cmRef, (cm, _, __) => cm.signDetached(message));

  @override
  Future<bool> verifyDetached({
    required Uint8List message,
    required Uint8List signature,
    required Uint8List pubKey,
  }) =>
      _isolated(
        _cmRef,
        (cm, _, __) => cm.verifyDetached(
          message: message,
          signature: signature,
          pubKey: pubKey,
        ),
      );
}
