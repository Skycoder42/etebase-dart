import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/crypto_executor.dart';
import 'crypto_mac.dart';
import 'crypto_manager_base.dart';
import 'crypto_utils.dart';
import 'rollsum.dart';

@internal
abstract class CryptoManager implements CryptoManagerBase {
  final int version;

  @protected
  @override
  @visibleForTesting
  final CryptoExecutor executor;
  @protected
  @visibleForTesting
  final SecureKey key;

  @protected
  @visibleForTesting
  late final cipherKey = _keyGen(key, 1);
  @protected
  @visibleForTesting
  late final macKey = _keyGen(key, 2);
  @protected
  @visibleForTesting
  late final asymmetricKeySeed = _keyGen(key, 3);
  @protected
  @visibleForTesting
  late final subDerivationKey = _keyGen(key, 4);
  @protected
  @visibleForTesting
  late final deterministicEncryptionKey = _keyGen(key, 5);

  final _disposables = <SecureKey>[];
  var _disposed = false;

  CryptoManager(this.executor, this.key, this.version);

  @visibleForOverriding
  String get context;

  @override
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      key.dispose();
    }

    // using the list ensures that keys are not initialized in the dispose
    // method. Each call to [_keyGen] adds the generated key to the list.
    for (final key in _disposables) {
      key.dispose();
    }
    _disposables.clear();
  }

  FutureOr<Uint8List> encrypt(Uint8List message, [Uint8List? additionalData]) =>
      executor.exec(
        secureKeys: [cipherKey],
        (sodium, secureKeys, _) =>
            _encrypt(sodium, secureKeys.single, message, additionalData),
      );

  FutureOr<Uint8List> decrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]) => executor.exec(
    secureKeys: [cipherKey],
    (sodium, secureKeys, _) =>
        _decrypt(sodium, secureKeys.single, nonceCipherText, additionalData),
  );

  Uint8List encryptKey(SecureKey key, [Uint8List? additionalData]) =>
      executor.execSync(
        (sodium) => key.runUnlockedSync(
          (keyData) => _encrypt(sodium, cipherKey, keyData, additionalData),
        ),
      );

  SecureKey decryptKey(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
    int? keySize,
  ]) => executor.execSync((sodium) {
    final decrypted = _decrypt(
      sodium,
      cipherKey,
      nonceCipherText,
      additionalData,
    );
    return sodium.secureCopy(
      keySize != null
          ? Uint8List.sublistView(decrypted, 0, keySize)
          : decrypted,
    );
  });

  FutureOr<({Uint8List mac, Uint8List nonceCipherText})> encryptDetached(
    Uint8List message, [
    Uint8List? additionalData,
  ]) => executor.exec(
    secureKeys: [cipherKey],
    (sodium, secureKeys, _) =>
        _encryptDetached(sodium, secureKeys.single, message, additionalData),
  );

  FutureOr<Uint8List> decryptDetached(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]) => executor.exec(
    secureKeys: [cipherKey],
    (sodium, secureKeys, _) => _decryptDetached(
      sodium,
      secureKeys.single,
      nonceCipherText,
      mac,
      additionalData,
    ),
  );

  FutureOr<void> verify(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]) => executor.exec(secureKeys: [cipherKey], (sodium, secureKeys, _) {
    _decryptDetached(
      sodium,
      secureKeys.single,
      nonceCipherText,
      mac,
      additionalData,
    );
  });

  FutureOr<Uint8List> calculateMac(Uint8List message, {bool withKey = true}) =>
      executor.exec(
        secureKeys: [if (withKey) macKey],
        (sodium, secureKeys, _) =>
            _calculateMac(sodium, secureKeys.singleOrNull, message),
      );

  CryptoMac getCryptoMac({bool withKey = true}) =>
      CryptoMac(executor, key: withKey ? macKey : null);

  Rollsum getChunker() => Rollsum();

  SecureKey deriveSubkey(Uint8List salt) => executor.execSync(
    (sodium) => sodium.secureCopy(
      subDerivationKey.runUnlockedSync((subDerivationKeyBytes) {
        final key = sodium.secureCopy(salt);
        try {
          return sodium.crypto.genericHash(
            message: subDerivationKeyBytes,
            key: key,
            outLen: CryptoUtils.symmetricKeySize,
          );
        } finally {
          key.dispose();
        }
      }),
    ),
  );

  @protected
  @visibleForTesting
  Uint8List deterministicEncrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]) => executor.execSync((sodium) {
    final nonce = Uint8List.sublistView(
      _calculateMac(sodium, macKey, message),
      0,
      sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
    );
    final encrypted = sodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
      key: deterministicEncryptionKey,
      nonce: nonce,
      message: message,
      additionalData: additionalData,
    );
    return CryptoUtils.concat([nonce, encrypted]);
  });

  @protected
  @visibleForTesting
  Uint8List deterministicDecrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]) => executor.execSync((sodium) {
    final (nonce, cipherText) = CryptoUtils.split2(
      nonceCipherText,
      sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
    );
    return sodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
      key: deterministicEncryptionKey,
      nonce: nonce,
      cipherText: cipherText,
      additionalData: additionalData,
    );
  });

  SecureKey _keyGen(SecureKey key, int keyId) => executor.execSync((sodium) {
    final subKey = sodium.crypto.kdf.deriveFromKey(
      masterKey: key,
      context: context.padRight(sodium.crypto.kdf.contextBytes),
      subkeyId: BigInt.from(keyId),
      subkeyLen: CryptoUtils.symmetricKeySize,
    );
    _disposables.add(subKey);
    return subKey;
  });

  static Uint8List _encrypt(
    SodiumSumo sodium,
    SecureKey cipherKey,
    Uint8List message,
    Uint8List? additionalData,
  ) {
    final nonce = sodium.randombytes.buf(
      sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
    );
    final encrypted = sodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
      key: cipherKey,
      nonce: nonce,
      message: message,
      additionalData: additionalData,
    );
    return CryptoUtils.concat([nonce, encrypted]);
  }

  static Uint8List _decrypt(
    SodiumSumo sodium,
    SecureKey cipherKey,
    Uint8List nonceCipherText,
    Uint8List? additionalData,
  ) {
    final (nonce, cipherText) = CryptoUtils.split2(
      nonceCipherText,
      sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
    );
    return sodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
      key: cipherKey,
      nonce: nonce,
      cipherText: cipherText,
      additionalData: additionalData,
    );
  }

  static ({Uint8List mac, Uint8List nonceCipherText}) _encryptDetached(
    SodiumSumo sodium,
    SecureKey cipherKey,
    Uint8List message,
    Uint8List? additionalData,
  ) {
    final nonce = sodium.randombytes.buf(
      sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
    );
    final encrypted = sodium.crypto.aeadXChaCha20Poly1305IETF.encryptDetached(
      key: cipherKey,
      nonce: nonce,
      message: message,
      additionalData: additionalData,
    );
    final data = CryptoUtils.concat([nonce, encrypted.cipherText]);
    return (mac: encrypted.mac, nonceCipherText: data);
  }

  static Uint8List _decryptDetached(
    SodiumSumo sodium,
    SecureKey cipherKey,
    Uint8List nonceCipherText,
    Uint8List mac,
    Uint8List? additionalData,
  ) {
    final (nonce, cipherText) = CryptoUtils.split2(
      nonceCipherText,
      sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
    );
    return sodium.crypto.aeadXChaCha20Poly1305IETF.decryptDetached(
      key: cipherKey,
      nonce: nonce,
      cipherText: cipherText,
      mac: mac,
      additionalData: additionalData,
    );
  }

  static Uint8List _calculateMac(
    SodiumSumo sodium,
    SecureKey? key,
    Uint8List message,
  ) => sodium.crypto.genericHash(
    message: message,
    key: key,
    outLen: CryptoUtils.hashSize,
  );
}
