import 'dart:typed_data';

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

  static Uint8List concatSecure(Iterable<SecureKey> keys) {
    final buffer = BytesBuilder();
    for (final key in keys) {
      key.runUnlockedSync(buffer.add);
    }
    return buffer.takeBytes();
  }

  static (Uint8List, Uint8List) split2(Uint8List data, int split) => (
        Uint8List.sublistView(data, 0, split),
        Uint8List.sublistView(data, split)
      );

  static (SecureKey, SecureKey) split2Secure(
    CryptoService service,
    Uint8List data,
    int split,
  ) =>
      (
        service.secureCopy(Uint8List.sublistView(data, 0, split)),
        service.secureCopy(Uint8List.sublistView(data, split)),
      );

  static Uint8List uint32ToUint8List(int value) {
    final bd = ByteData(4)..setUint32(0, value, Endian.little);
    return bd.buffer.asUint8List();
  }

  static int uint8ListToUint32(Uint8List data) =>
      ByteData.sublistView(data).getUint32(0, Endian.little);
}
