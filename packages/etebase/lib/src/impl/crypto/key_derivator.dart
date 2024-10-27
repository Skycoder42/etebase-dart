import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'crypto_manager_sync.dart';

@internal
enum KeyDerivationDifficulty {
  hard,
  medium,
  easy,
}

@internal
class KeyDerivator {
  final SodiumSumo _sodium;

  KeyDerivator(this._sodium);

  Future<SecureKey> call({
    required Uint8List salt,
    required String password,
    KeyDerivationDifficulty difficulty = KeyDerivationDifficulty.hard,
  }) async =>
      await _sodium.runIsolated(
        (sodium, _, __) => _sodium.crypto.pwhash(
          outLen: CryptoManagerSync.keySize,
          password: password.toCharArray(),
          salt: salt,
          opsLimit: switch (difficulty) {
            KeyDerivationDifficulty.hard =>
              _sodium.crypto.pwhash.opsLimitSensitive,
            KeyDerivationDifficulty.medium =>
              _sodium.crypto.pwhash.opsLimitModerate,
            KeyDerivationDifficulty.easy =>
              _sodium.crypto.pwhash.opsLimitInteractive,
          },
          memLimit: _sodium.crypto.pwhash.opsLimitModerate,
        ),
      );
}
