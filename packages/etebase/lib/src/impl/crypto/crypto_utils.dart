import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'crypto_service.dart';

@internal
abstract base class CryptoUtils {
  CryptoUtils._();

  static Uint8List concat(Iterable<Uint8List> chunks) {
    final buffer = BytesBuilder(copy: false);
    chunks.forEach(buffer.add);
    return buffer.takeBytes();
  }

  static SecureKey concatSecure(CryptoService crypto, List<SecureKey> keys) =>
      crypto.secureAlloc(keys.map((k) => k.length).sum)
        ..runUnlockedSync(writable: true, (resultBytes) {
          var offset = 0;
          for (final key in keys) {
            key.runUnlockedSync((keyBytes) {
              final end = offset + keyBytes.length;
              resultBytes.setRange(offset, end, keyBytes);
              offset = end;
            });
          }
        });

  static (Uint8List, Uint8List) split2(Uint8List data, int split) => (
        Uint8List.sublistView(data, 0, split),
        Uint8List.sublistView(data, split)
      );

  static (SecureKey, SecureKey) split2Secure(
    CryptoService service,
    SecureKey key,
    int split,
  ) =>
      key.runUnlockedSync(
        (data) => (
          service.secureCopy(Uint8List.sublistView(data, 0, split)),
          service.secureCopy(Uint8List.sublistView(data, split)),
        ),
      );

  static Uint8List uint32ToUint8List(int value) {
    final bd = ByteData(4)..setUint32(0, value, Endian.little);
    return bd.buffer.asUint8List();
  }

  static int uint8ListToUint32(Uint8List data) =>
      ByteData.sublistView(data).getUint32(0, Endian.little);
}
