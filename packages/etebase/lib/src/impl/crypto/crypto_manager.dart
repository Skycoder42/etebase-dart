import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'crypto_mac.dart';
import 'crypto_manager_base.dart';
import 'rollsum.dart';

@internal
abstract interface class CryptoManager implements CryptoManagerBase {
  static const keySize = 32;

  int get version;

  FutureOr<Uint8List> encrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]);

  FutureOr<Uint8List> encryptKey(
    SecureKey key, [
    Uint8List? additionalData,
  ]);

  FutureOr<Uint8List> decrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]);

  FutureOr<SecureKey> decryptKey(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
    int? keySize,
  ]);

  FutureOr<({Uint8List mac, Uint8List nonceCipherText})> encryptDetached(
    Uint8List message, [
    Uint8List? additionalData,
  ]);

  FutureOr<Uint8List> decryptDetached(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]);

  FutureOr<bool> verify(
    Uint8List nonceCipherText,
    Uint8List mac, [
    Uint8List? additionalData,
  ]);

  FutureOr<Uint8List> deterministicEncrypt(
    Uint8List message, [
    Uint8List? additionalData,
  ]);

  FutureOr<Uint8List> deterministicDecrypt(
    Uint8List nonceCipherText, [
    Uint8List? additionalData,
  ]);

  FutureOr<SecureKey> deriveSubkey(Uint8List salt);

  FutureOr<CryptoMac> getCryptoMac({bool withKey = true});

  FutureOr<Uint8List> calculateMac(
    Uint8List message, {
    bool withKey = true,
  });

  Rollsum getChunker();
}
