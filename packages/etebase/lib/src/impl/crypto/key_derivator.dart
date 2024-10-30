import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'crypto_manager.dart';

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

  Uint8List randomSalt() =>
      _sodium.randombytes.buf(_sodium.crypto.pwhash.saltBytes);

  Future<SecureKey> call({
    required Uint8List salt,
    required String password,
    KeyDerivationDifficulty difficulty = KeyDerivationDifficulty.hard,
  }) async =>
      await _sodium.runIsolated(
        (sodium, _, __) => sodium.crypto.pwhash(
          outLen: CryptoManager.keySize,
          password: password.toCharArray(),
          salt: salt,
          opsLimit: switch (difficulty) {
            KeyDerivationDifficulty.hard =>
              sodium.crypto.pwhash.opsLimitSensitive,
            KeyDerivationDifficulty.medium =>
              sodium.crypto.pwhash.opsLimitModerate,
            KeyDerivationDifficulty.easy =>
              sodium.crypto.pwhash.opsLimitInteractive,
          },
          memLimit: sodium.crypto.pwhash.memLimitModerate,
        ),
      );
}
