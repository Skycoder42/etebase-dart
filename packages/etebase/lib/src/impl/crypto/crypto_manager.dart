import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'crypto_executor.dart';

@internal
abstract base class CryptoManager {
  static const _subKeySize = 32;
  static const _hashSize = 32;

  final SodiumSumo sodium;
  final CryptoExecutor executor;
  final int version;

  late final SecureKey cipherKey;
  late final SecureKey macKey;
  late final SecureKey asymmetricKeySeed;
  late final SecureKey subDerivationKey;
  late final SecureKey deterministicEncryptionKey;

  String get context;

  CryptoManager(
    this.sodium,
    this.executor,
    this.version,
  );

  @mustCallSuper
  Future<void> init(SecureKey key) async {
    cipherKey = await _keyGen(key, 1);
    macKey = await _keyGen(key, 2);
    asymmetricKeySeed = await _keyGen(key, 3);
    subDerivationKey = await _keyGen(key, 4);
    deterministicEncryptionKey = await _keyGen(key, 5);
  }

  Future<Uint8List> encrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]) async =>
      await executor(
        secureKeys: [cipherKey],
        (sodium, secureKeys, _) {
          final nonce = sodium.randombytes.buf(
            sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
          );
          final encrypted = sodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
            key: secureKeys[0],
            nonce: nonce,
            message: message,
            additionalData: additionalData,
          );
          return _concat([nonce, encrypted]);
        },
      );

  Future<Uint8List> decrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]) async =>
      await executor(
        secureKeys: [cipherKey],
        (sodium, secureKeys, _) {
          final (nonce, cipherText) = _split2(
            nonceCipherText,
            sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
          );
          return sodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
            key: secureKeys[0],
            nonce: nonce,
            cipherText: cipherText,
            additionalData: additionalData,
          );
        },
      );

  Future<(Uint8List, Uint8List)> encryptDetached(
    Uint8List message, [
    Uint8List? additionalData,
  ]) async =>
      await executor(
        secureKeys: [cipherKey],
        (sodium, secureKeys, _) {
          final nonce = sodium.randombytes.buf(
            sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
          );
          final encrypted =
              sodium.crypto.aeadXChaCha20Poly1305IETF.encryptDetached(
            key: secureKeys[0],
            nonce: nonce,
            message: message,
            additionalData: additionalData,
          );
          final data = _concat([nonce, encrypted.cipherText]);
          return (encrypted.mac, data);
        },
      );

  Future<Uint8List> decryptDetached(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]) async =>
      await executor(
        secureKeys: [cipherKey],
        (sodium, secureKeys, _) {
          final (nonce, cipherText) = _split2(
            nonceCipherText,
            sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
          );
          return sodium.crypto.aeadXChaCha20Poly1305IETF.decryptDetached(
            key: secureKeys[0],
            nonce: nonce,
            cipherText: cipherText,
            mac: mac,
            additionalData: additionalData,
          );
        },
      );

  Future<Uint8List> deterministicDecrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]) async =>
      await executor(
        secureKeys: [deterministicEncryptionKey],
        (sodium, secureKeys, _) {
          final (nonce, cipherText) = _split2(
            nonceCipherText,
            sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
          );
          return sodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
            key: secureKeys[0],
            nonce: nonce,
            cipherText: cipherText,
            additionalData: additionalData,
          );
        },
      );

  Future<bool> verify(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]) async =>
      await executor(
        secureKeys: [cipherKey],
        (sodium, secureKeys, _) {
          final (nonce, cipherText) = _split2(
            nonceCipherText,
            sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
          );
          sodium.crypto.aeadXChaCha20Poly1305IETF.decryptDetached(
            key: secureKeys[0],
            nonce: nonce,
            cipherText: cipherText,
            mac: mac,
            additionalData: additionalData,
          );
          return true;
        },
      );

  Future<Uint8List> deterministicEncrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]) async =>
      await executor(
        secureKeys: [deterministicEncryptionKey],
        (sodium, secureKeys, _) {
          final nonce = Uint8List.sublistView(
            _calculateMacSync(message),
            0,
            sodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
          );
          final encrypted = sodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
            key: secureKeys[0],
            nonce: nonce,
            message: message,
            additionalData: additionalData,
          );
          return _concat([nonce, encrypted]);
        },
      );

  Future<Uint8List> deriveSubkey(Uint8List salt) async => await executor(
        secureKeys: [subDerivationKey],
        (sodium, secureKeys, _) => sodium.crypto.genericHash(
          message: secureKeys[0].extractBytes(),
          key: sodium.secureCopy(salt),
          outLen: _hashSize,
        ),
      );

  Future<Uint8List> calculateMac(
    Uint8List message, {
    bool withKey = true,
  }) async =>
      await executor(
        secureKeys: [macKey],
        (sodium, secureKeys, _) => sodium.crypto.genericHash(
          message: message,
          key: withKey ? secureKeys[0] : null,
          outLen: _hashSize,
        ),
      );

  Uint8List _calculateMacSync(
    Uint8List message, {
    bool withKey = true,
  }) =>
      sodium.crypto.genericHash(
        message: message,
        key: withKey ? macKey : null,
        outLen: _hashSize,
      );

  Future<SecureKey> _keyGen(SecureKey key, int keyId) async => await executor(
        secureKeys: [key],
        (sodium, secureKeys, _) => sodium.crypto.kdf.deriveFromKey(
          masterKey: secureKeys[0],
          context: context.padRight(sodium.crypto.kdf.contextBytes),
          subkeyId: BigInt.from(keyId),
          subkeyLen: _subKeySize,
        ),
      );

  Uint8List _concat(List<Uint8List> chunks) {
    if (chunks.length == 1) {
      return chunks.single;
    }

    final result = Uint8List(chunks.map((c) => c.length).sum);
    var offset = 0;
    for (final chunk in chunks) {
      result.setAll(offset, chunk);
      offset += chunk.length;
    }
    return result;
  }

  (Uint8List, Uint8List) _split2(Uint8List data, int split) => (
        Uint8List.sublistView(data, 0, split),
        Uint8List.sublistView(data, split)
      );
}
