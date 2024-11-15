import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../crypto_mac.dart';
import '../crypto_manager.dart';
import '../crypto_manager_base.dart';
import '../crypto_utils.dart';
import '../rollsum.dart';

@internal
abstract base class CryptoManagerSync
    implements CryptoManager, CryptoManagerBaseSync {
  static const hashSize = 32;

  final SodiumSumo sodium;
  @protected
  final SecureKey key;
  @override
  final int version;

  late final cipherKey = _keyGen(key, 1);
  late final macKey = _keyGen(key, 2);
  late final asymmetricKeySeed = _keyGen(key, 3);
  late final subDerivationKey = _keyGen(key, 4);
  late final deterministicEncryptionKey = _keyGen(key, 5);
  final _disposables = <SecureKey>[];

  @protected
  String get context;

  int get _nonceBytes => sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes;

  CryptoManagerSync(
    this.sodium,
    this.key,
    this.version,
  );

  @override
  void dispose() {
    key.dispose();
    // using the list ensures that keys are not initialized in the dispose
    // method. Each call to [_keyGen] adds the generated key to the list.
    for (final key in _disposables) {
      key.dispose();
    }
  }

  @override
  Uint8List encrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]) {
    final nonce = sodium.randombytes.buf(_nonceBytes);
    final encrypted = sodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
      key: cipherKey,
      nonce: nonce,
      message: message,
      additionalData: additionalData,
    );
    return CryptoUtils.concat([nonce, encrypted]);
  }

  @override
  Uint8List encryptKey(
    SecureKey key, [
    Uint8List? additionalData,
  ]) =>
      key.runUnlockedSync((keyData) => encrypt(keyData, additionalData));

  @override
  Uint8List decrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]) {
    final (nonce, cipherText) =
        CryptoUtils.split2(nonceCipherText, _nonceBytes);
    return sodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
      key: cipherKey,
      nonce: nonce,
      cipherText: cipherText,
      additionalData: additionalData,
    );
  }

  @override
  SecureKey decryptKey(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
    int? keySize,
  ]) {
    final decrypted = decrypt(nonceCipherText, additionalData);
    return sodium.secureCopy(
      keySize != null
          ? Uint8List.sublistView(decrypted, 0, keySize)
          : decrypted,
    );
  }

  @override
  ({Uint8List mac, Uint8List nonceCipherText}) encryptDetached(
    Uint8List message, [
    Uint8List? additionalData,
  ]) {
    final nonce = sodium.randombytes.buf(_nonceBytes);
    final encrypted = sodium.crypto.aeadXChaCha20Poly1305IETF.encryptDetached(
      key: cipherKey,
      nonce: nonce,
      message: message,
      additionalData: additionalData,
    );
    final data = CryptoUtils.concat([nonce, encrypted.cipherText]);
    return (mac: encrypted.mac, nonceCipherText: data);
  }

  @override
  Uint8List decryptDetached(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]) {
    final (nonce, cipherText) =
        CryptoUtils.split2(nonceCipherText, _nonceBytes);
    return sodium.crypto.aeadXChaCha20Poly1305IETF.decryptDetached(
      key: cipherKey,
      nonce: nonce,
      cipherText: cipherText,
      mac: mac,
      additionalData: additionalData,
    );
  }

  @override
  bool verify(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]) {
    final (nonce, cipherText) =
        CryptoUtils.split2(nonceCipherText, _nonceBytes);
    sodium.crypto.aeadXChaCha20Poly1305IETF.decryptDetached(
      key: cipherKey,
      nonce: nonce,
      cipherText: cipherText,
      mac: mac,
      additionalData: additionalData,
    );
    return true;
  }

  @override
  Uint8List deterministicEncrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]) {
    final nonce = Uint8List.sublistView(
      calculateMac(message),
      0,
      _nonceBytes,
    );
    final encrypted = sodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
      key: deterministicEncryptionKey,
      nonce: nonce,
      message: message,
      additionalData: additionalData,
    );
    return CryptoUtils.concat([nonce, encrypted]);
  }

  @override
  Uint8List deterministicDecrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]) {
    final (nonce, cipherText) =
        CryptoUtils.split2(nonceCipherText, _nonceBytes);
    return sodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
      key: deterministicEncryptionKey,
      nonce: nonce,
      cipherText: cipherText,
      additionalData: additionalData,
    );
  }

  @override
  SecureKey deriveSubkey(Uint8List salt) => sodium.secureCopy(
        subDerivationKey.runUnlockedSync(
          (subDerivationKeyBytes) {
            final key = sodium.secureCopy(salt);
            try {
              return sodium.crypto.genericHash(
                message: subDerivationKeyBytes,
                key: key,
                outLen: hashSize,
              );
            } finally {
              key.dispose();
            }
          },
        ),
      );

  @override
  CryptoMac getCryptoMac({bool withKey = true}) =>
      CryptoMac(sodium, key: withKey ? macKey : null);

  @override
  Uint8List calculateMac(
    Uint8List message, {
    bool withKey = true,
  }) =>
      sodium.crypto.genericHash(
        message: message,
        key: withKey ? macKey : null,
        outLen: hashSize,
      );

  @override
  Rollsum getChunker() => Rollsum();

  SecureKey _keyGen(SecureKey key, int keyId) {
    final subKey = sodium.crypto.kdf.deriveFromKey(
      masterKey: key,
      context: context.padRight(sodium.crypto.kdf.contextBytes),
      subkeyId: BigInt.from(keyId),
      subkeyLen: CryptoManager.keySize,
    );
    _disposables.add(subKey);
    return subKey;
  }
}
