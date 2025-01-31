import 'dart:typed_data';

import 'package:etebase/src/impl/codec/byte_array_converter.dart';
import 'package:test/test.dart';

void main() {
  group('$ByteArrayConverter', () {
    test('keeps bytearray as is', () {
      final data = Uint8List(0);
      expect(msgPackBytes.toJson(data), same(data));
      expect(msgPackBytes.fromJson(data), same(data));
    });
  });
}
