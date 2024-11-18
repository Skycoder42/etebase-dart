import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/crypto_executor.dart';
import 'crypto_utils.dart';

@internal
enum KeyDerivationDifficulty {
  hard,
  medium,
  easy,
}

@internal
class KeyDerivator {
  final CryptoExecutor _executor;

  KeyDerivator(this._executor);

  Uint8List randomSalt() => _executor.execSync(
        (sodium) => sodium.randombytes.buf(sodium.crypto.pwhash.saltBytes),
      );

  Future<SecureKey> call({
    required Uint8List salt,
    required String password,
    KeyDerivationDifficulty difficulty = KeyDerivationDifficulty.hard,
  }) =>
      _executor.execAsync(
        (sodium, _, __) => sodium.crypto.pwhash(
          outLen: CryptoUtils.symmetricKeySize,
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
