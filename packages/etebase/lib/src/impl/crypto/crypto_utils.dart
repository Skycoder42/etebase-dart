import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

@internal
abstract base class CryptoUtils {
  CryptoUtils._();

  static Uint8List concat(List<Uint8List> chunks) {
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

  static (Uint8List, Uint8List) split2(Uint8List data, int split) => (
        Uint8List.sublistView(data, 0, split),
        Uint8List.sublistView(data, split)
      );

  static Uint8List uint32ToUint8List(int value) {
    final bd = ByteData(4)..setUint32(0, value, Endian.little);
    return bd.buffer.asUint8List();
  }

  static int uint8ListToUint32(Uint8List data) =>
      ByteData.sublistView(data).getUint32(0, Endian.little);
}
