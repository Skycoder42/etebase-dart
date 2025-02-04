import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/crypto_executor.dart';
import 'account_crypto_manager.dart';
import 'box_crypto_manager.dart';
import 'collection_crypto_manager.dart';
import 'collection_item_crypto_manager.dart';
import 'crypto_utils.dart';
import 'key_derivator.dart';
import 'main_crypto_manager.dart';
import 'minimal_collection_crypto_manager.dart';
import 'storage_crypto_manager.dart';

@internal
class CryptoService {
  static const defaultFingerprintDelimiter = '   ';

  final CryptoExecutor _executor;

  CryptoService(this._executor);

  FutureOr<void> dispose() => _executor.dispose();

  KeyDerivator get keyDerivator => KeyDerivator(_executor);

  Uint8List randomBytes(int length) =>
      _executor.execSync((sodium) => sodium.randombytes.buf(length));

  SecureKey secureAlloc(int length) =>
      _executor.execSync((sodium) => sodium.secureAlloc(length));

  SecureKey secureRandom(int length) =>
      _executor.execSync((sodium) => sodium.secureRandom(length));

  SecureKey secureCopy(Uint8List bytes) =>
      _executor.execSync((sodium) => sodium.secureCopy(bytes));

  Uint8List bufferPadSmall(Uint8List buffer) =>
      _executor.execSync((sodium) => sodium.pad(buffer, buffer.length + 1));

  Uint8List bufferUnpadSmall(Uint8List buffer) => buffer.isEmpty
      ? buffer
      : _executor.execSync((sodium) => sodium.unpad(buffer, buffer.length));

  FutureOr<Uint8List> bufferPad(Uint8List buffer) => _executor.exec(
        (sodium, _, __) => sodium.pad(buffer, _getPadding(buffer.length)),
      );

  FutureOr<Uint8List> bufferUnpad(Uint8List buffer) => buffer.isEmpty
      ? buffer
      : _executor.exec((sodium, _, __) => sodium.unpad(buffer, buffer.length));

  List<int> shuffle<T>(List<T> list) => _executor.execSync((sodium) {
        final len = list.length;
        final shuffledIndices = List.generate(len, (i) => i);

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
      });

  String prettyFingerprint(
    Uint8List content, [
    String delimiter = defaultFingerprintDelimiter,
  ]) =>
      _executor.execSync((sodium) {
        final fingerprint = sodium.crypto.genericHash(
          message: content,
          outLen: CryptoUtils.hashSize,
        );

        // We use 3 bytes each time to generate a 5 digit number - this means
        // 10 pairs for bytes 0-29. We then use bytes 29-31 for another number,
        // and then the 3 most significant bits of each first byte for the last.
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
      });

  MainCryptoManager createMainCryptoManager(
    SecureKey key, {
    int version = CryptoUtils.currentVersion,
  }) =>
      MainCryptoManager(_executor, key, version);

  BoxCryptoManager createIdentityCryptoManager([SecureKey? seed]) =>
      BoxCryptoManager.fromSeed(_executor, seed);

  StorageCryptoManager createStorageCryptoManager(
    SecureKey key, {
    int version = CryptoUtils.currentVersion,
  }) =>
      StorageCryptoManager(_executor, key, version);

  CollectionItemCryptoManager createCollectionItemCryptoManager(
    SecureKey key, {
    int version = CryptoUtils.currentVersion,
  }) =>
      CollectionItemCryptoManager(_executor, key, version);

  MinimalCollectionCryptoManager createMinimalCollectionCryptoManager(
    SecureKey key, {
    int version = CryptoUtils.currentVersion,
  }) =>
      MinimalCollectionCryptoManager(_executor, key, version);

  CollectionCryptoManager createCollectionCryptoManager(
    AccountCryptoManager parentCryptoManager,
    SecureKey key, {
    int version = CryptoUtils.currentVersion,
  }) =>
      CollectionCryptoManager(_executor, parentCryptoManager, key, version);

  static int _getPadding(int length) {
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
    final z = e - s;
    final m = (1 << z) - 1;
    return (length + m) & ~m;
  }

  static String _getEncodedChunk(Uint8List content, int offset) {
    final num = ((content[offset] << 16) +
            (content[offset + 1] << 8) +
            content[offset + 2]) %
        100000;
    return num.toString().padLeft(5, '0');
  }
}

double _logBase(num x, num base) => math.log(x) / math.log(base);

double _log2(num x) => _logBase(x, 2);
