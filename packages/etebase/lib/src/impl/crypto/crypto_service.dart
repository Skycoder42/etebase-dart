import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'account_crypto_manager.dart';
import 'box_crypto_manager.dart';
import 'collection_crypto_manager.dart';
import 'collection_item_crypto_manager.dart';
import 'key_derivator.dart';
import 'main_crypto_manager.dart';
import 'minimal_collection_crypto_manager.dart';
import 'storage_crypto_manager.dart';
import 'sync/crypto_manager_sync.dart';

@internal
abstract interface class CryptoService {
  static const currentVersion = 1;
  static const defaultFingerprintDelimiter = '   ';

  KeyDerivator get keyDerivator;

  FutureOr<void> dispose();

  Uint8List randomBytes(int length);

  String genUidBase64();

  SecureKey secureAlloc(int length);

  SecureKey secureRandom(int length);

  SecureKey secureCopy(Uint8List bytes);

  Uint8List bufferPadSmall(Uint8List buffer);

  Uint8List bufferPad(Uint8List buffer);

  Uint8List bufferUnpad(Uint8List buffer);

  List<int> shuffle<T>(List<T> list);

  MainCryptoManager createMainCryptoManager(
    SecureKey key, {
    int version = currentVersion,
  });

  BoxCryptoManager createIdentityCryptoManager([SecureKey? seed]);

  StorageCryptoManager createStorageCryptoManager(
    SecureKey key, {
    int version = currentVersion,
  });

  CollectionItemCryptoManager createCollectionItemCryptoManager(
    SecureKey key, {
    int version = currentVersion,
  });

  MinimalCollectionCryptoManager createMinimalCollectionCryptoManager(
    SecureKey key, {
    int version = currentVersion,
  });

  CollectionCryptoManager createCollectionCryptoManager(
    AccountCryptoManager parentCryptoManager,
    SecureKey key, {
    int version = currentVersion,
  });

  String prettyFingerprint(
    Uint8List content, [
    String delimiter = defaultFingerprintDelimiter,
  ]);
}

@internal
mixin CryptoServiceCommon implements CryptoService {
  @protected
  SodiumSumo get sodium;

  @override
  late final keyDerivator = KeyDerivator(sodium);

  @override
  Uint8List randomBytes(int length) => sodium.randombytes.buf(length);

  @override
  String genUidBase64() => base64.encode(randomBytes(24));

  @override
  SecureKey secureAlloc(int length) => sodium.secureAlloc(length);

  @override
  SecureKey secureRandom(int length) => sodium.secureRandom(length);

  @override
  SecureKey secureCopy(Uint8List bytes) => sodium.secureCopy(bytes);

  @override
  Uint8List bufferPadSmall(Uint8List buffer) =>
      sodium.pad(buffer, buffer.length + 1);

  @override
  Uint8List bufferPad(Uint8List buffer) =>
      sodium.pad(buffer, _getPadding(buffer.length));

  @override
  Uint8List bufferUnpad(Uint8List buffer) =>
      buffer.isEmpty ? buffer : sodium.unpad(buffer, buffer.length);

  @override
  List<int> shuffle<T>(List<T> list) {
    final len = list.length;
    final shuffledIndices = List.filled(len, 0);

    // Fill up with the indices
    for (var i = 0; i < len; i++) {
      shuffledIndices[i] = i;
    }

    for (var i = 0; i < len; i++) {
      final j = i + sodium.randombytes.uniform(len - i);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;

      // Also swap the index array
      final tmp2 = shuffledIndices[i];
      shuffledIndices[i] = shuffledIndices[j];
      shuffledIndices[j] = tmp2;
    }

    final ret = List.filled(len, 0);
    for (var i = 0; i < len; i++) {
      ret[shuffledIndices[i]] = i;
    }

    return ret;
  }

  @override
  String prettyFingerprint(
    Uint8List content, [
    String delimiter = CryptoService.defaultFingerprintDelimiter,
  ]) {
    final fingerprint = sodium.crypto.genericHash(
      message: content,
      outLen: CryptoManagerSync.hashSize,
    );

    /* We use 3 bytes each time to generate a 5 digit number - this means 10 pairs for bytes 0-29
     * We then use bytes 29-31 for another number, and then the 3 most significant bits of each first byte for the last.
     */
    final ret = StringBuffer();
    var lastNum = 0;
    for (var i = 0; i < 10; i++) {
      final suffix = (i % 4 == 3) ? '\n' : delimiter;
      ret
        ..write(_getEncodedChunk(fingerprint, i * 3))
        ..write(suffix);
      lastNum = (lastNum << 3) | ((fingerprint[i] & 0xE0) >>> 5);
    }
    ret
      ..write(_getEncodedChunk(fingerprint, 29))
      ..write(delimiter)
      ..write((lastNum % 100000).toString().padLeft(5, '0'));
    return ret.toString();
  }

  static String _getEncodedChunk(Uint8List content, int offset) {
    final num = ((content[offset] << 16) +
            (content[offset + 1] << 8) +
            content[offset + 2]) %
        100000;
    return num.toString().padLeft(5, '0');
  }

  int _getPadding(int length) {
    // Use the padme padding scheme for efficiently
    // https://www.petsymposium.org/2019/files/papers/issue4/popets-2019-0056.pdf

    // We want a minimum pad size of 4k
    if (length < (1 << 14)) {
      const size = (1 << 10) - 1;
      // We add 1 so we always have some padding
      return (length | size) + 1;
    }

    final e = _log2(length).floor();
    final s = _log2(e).floor() + 1;
    final lastBits = e - s;
    final bitMask = (math.pow(2, lastBits) - 1).toInt();
    return (length + bitMask) & ~bitMask;
  }

  double _logBase(num x, num base) => math.log(x) / math.log(base);

  double _log2(num x) => _logBase(x, 2);
}
