import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/crypto_executor.dart';
import 'crypto_utils.dart';

@internal
enum KeyDerivationDifficulty { hard, medium, easy }

@internal
class KeyDerivator {
  static const saltSize = 32;

  @visibleForTesting
  final CryptoExecutor executor;

  new(this.executor);

  Uint8List randomSalt() =>
      executor.execSync((sodium) => sodium.randombytes.buf(saltSize));

  Future<SecureKey> call({
    required Uint8List salt,
    required String password,
    KeyDerivationDifficulty difficulty = KeyDerivationDifficulty.hard,
  }) => executor.execAsync(
    (sodium, _, _) => sodium.crypto.pwhash.callStr(
      outLen: CryptoUtils.symmetricKeySize,
      password: password,
      salt: salt.sublist(0, sodium.crypto.pwhash.saltBytes),
      opsLimit: switch (difficulty) {
        KeyDerivationDifficulty.hard => sodium.crypto.pwhash.opsLimitSensitive,
        KeyDerivationDifficulty.medium => sodium.crypto.pwhash.opsLimitModerate,
        KeyDerivationDifficulty.easy =>
          sodium.crypto.pwhash.opsLimitInteractive,
      },
      memLimit: sodium.crypto.pwhash.memLimitModerate,
    ),
  );
}
