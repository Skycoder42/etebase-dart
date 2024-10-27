import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'crypto_mac_sync.dart';
import 'crypto_manager.dart';
import 'crypto_manager_sync.dart';
import 'isolated_crypto_manager.dart';
import 'rollsum.dart';

@internal
base class CryptoManagerAsync<TCryptoManager extends CryptoManagerSync>
    implements CryptoManager {
  @protected
  final IsolatedCryptoManager<TCryptoManager> isolated;

  @protected
  CryptoManagerAsync(this.isolated);

  @override
  void dispose() => isolated.dispose();

  @override
  Future<Uint8List> encrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]) =>
      isolated((cm, _, __) => cm.encrypt(message, additionalData));

  @override
  Future<Uint8List> decrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]) =>
      isolated((cm, _, __) => cm.decrypt(nonceCipherText, additionalData));

  @override
  Future<({Uint8List mac, Uint8List nonceCipherText})> encryptDetached(
    Uint8List message, [
    Uint8List? additionalData,
  ]) =>
      isolated((cm, _, __) => cm.encryptDetached(message, additionalData));

  @override
  Future<Uint8List> decryptDetached(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]) =>
      isolated(
        (cm, _, __) => cm.decryptDetached(nonceCipherText, mac, additionalData),
      );

  @override
  Future<bool> verify(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]) =>
      isolated((cm, _, __) => cm.verify(nonceCipherText, mac, additionalData));

  @override
  Future<Uint8List> deterministicEncrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]) =>
      isolated((cm, _, __) => cm.deterministicEncrypt(message, additionalData));

  @override
  Future<Uint8List> deterministicDecrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]) =>
      isolated(
        (cm, _, __) => cm.deterministicDecrypt(nonceCipherText, additionalData),
      );

  @override
  Future<Uint8List> deriveSubkey(Uint8List salt) =>
      isolated((cm, _, __) => cm.deriveSubkey(salt));

  @override
  Future<CryptoMac> getCryptoMac({bool withKey = true}) async {
    if (!withKey) {
      return CryptoMac(isolated.sodium);
    }

    final key = await isolated(
      (cm, _, __) => cm.sodium.createTransferrableSecureKey(cm.macKey),
    );
    return CryptoMac(
      isolated.sodium,
      key: isolated.sodium.materializeTransferrableSecureKey(key),
    );
  }

  @override
  Future<Uint8List> calculateMac(
    Uint8List message, {
    bool withKey = true,
  }) =>
      isolated((cm, _, __) => cm.calculateMac(message, withKey: withKey));

  @override
  Rollsum getChunker() => Rollsum();

  @override
  String prettyFingerprint(
    Uint8List content, [
    String delimiter = CryptoManager.defaultFingerprintDelimiter,
  ]) =>
      CryptoManagerSync.prettyFingerprintSync(
        isolated.sodium,
        content,
        delimiter,
      );
}
