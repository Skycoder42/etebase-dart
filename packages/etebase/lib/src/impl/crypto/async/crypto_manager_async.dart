import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../crypto_mac.dart';
import '../crypto_manager.dart';
import '../rollsum.dart';
import '../sync/crypto_manager_sync.dart';
import 'crypto_manager_base_async.dart';
import 'isolated_crypto_manager.dart';

@internal
abstract base class CryptoManagerAsync<TCryptoManager extends CryptoManagerSync>
    extends CryptoManagerBaseAsync<TCryptoManager> implements CryptoManager {
  @protected
  final SecureKey key;
  @override
  final int version;

  @protected
  CryptoManagerAsync(super.isolated, this.key, this.version);

  // more specialized method ensures key/version are always copied,
  // without class references
  @visibleForOverriding
  Future<CryptoManagerRef<TCryptoManager>> initManagerSync(
    SecureKey key,
    int version,
  );

  @override
  @nonVirtual
  Future<CryptoManagerRef<TCryptoManager>> initSync() =>
      initManagerSync(key, version);

  @override
  @mustCallSuper
  Future<void> dispose() {
    key.dispose();
    return super.dispose();
  }

  @override
  Future<Uint8List> encrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]) =>
      exec((cm, _, __) => cm.encrypt(message, additionalData));

  @override
  Future<Uint8List> encryptKey(
    SecureKey key, [
    Uint8List? additionalData,
  ]) =>
      exec(
        secureKey: [key],
        disposeIsolateKeys: true,
        (cm, secureKeys, __) => cm.encryptKey(secureKeys[0], additionalData),
      );

  @override
  Future<Uint8List> decrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]) =>
      exec((cm, _, __) => cm.decrypt(nonceCipherText, additionalData));

  @override
  Future<SecureKey> decryptKey(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
    int? keySize,
  ]) =>
      exec(
        (cm, _, __) => cm.decryptKey(
          nonceCipherText,
          additionalData,
          keySize,
        ),
      );

  @override
  Future<({Uint8List mac, Uint8List nonceCipherText})> encryptDetached(
    Uint8List message, [
    Uint8List? additionalData,
  ]) =>
      exec((cm, _, __) => cm.encryptDetached(message, additionalData));

  @override
  Future<Uint8List> decryptDetached(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]) =>
      exec(
        (cm, _, __) => cm.decryptDetached(nonceCipherText, mac, additionalData),
      );

  @override
  Future<bool> verify(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]) =>
      exec((cm, _, __) => cm.verify(nonceCipherText, mac, additionalData));

  @override
  Future<Uint8List> deterministicEncrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]) =>
      exec((cm, _, __) => cm.deterministicEncrypt(message, additionalData));

  @override
  Future<Uint8List> deterministicDecrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]) =>
      exec(
        (cm, _, __) => cm.deterministicDecrypt(nonceCipherText, additionalData),
      );

  @override
  Future<SecureKey> deriveSubkey(Uint8List salt) =>
      exec((cm, _, __) => cm.deriveSubkey(salt));

  @override
  Future<CryptoMac> getCryptoMac({bool withKey = true}) async {
    if (!withKey) {
      return CryptoMac(isolated.sodium);
    }

    final key = isolated.sodium.materializeTransferrableSecureKey(
      await exec(
        (cm, _, __) => cm.sodium.createTransferrableSecureKey(cm.macKey),
      ),
    );
    try {
      return CryptoMac(isolated.sodium, key: key);
    } finally {
      key.dispose();
    }
  }

  @override
  Future<Uint8List> calculateMac(
    Uint8List message, {
    bool withKey = true,
  }) =>
      exec((cm, _, __) => cm.calculateMac(message, withKey: withKey));

  @override
  Rollsum getChunker() => Rollsum();
}
