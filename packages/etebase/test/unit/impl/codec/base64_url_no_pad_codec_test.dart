import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/impl/codec/base64_url_no_pad_codec.dart';
import 'package:test/test.dart';

void main() {
  group('base64UrlNoPad', () {
    testData(
      'converts from and to base64 url without padding',
      [
        (<int>[], ''),
        ([0x00], 'AA'),
        ([0xFA], '-g'),
        ([0xFF], '_w'),
        ([0x12], 'Eg'),
        ([0x12, 0x34], 'EjQ'),
        ([0x12, 0x34, 0x56], 'EjRW'),
        ([0x12, 0x34, 0x56, 0x78], 'EjRWeA'),
      ],
      (fixture) {
        expect(
          base64UrlNoPad.encode(Uint8List.fromList(fixture.$1)),
          fixture.$2,
        );
        expect(
          base64UrlNoPad.decode(fixture.$2),
          fixture.$1,
        );
      },
    );
  });

  group('msgPack64UrlNoPad', () {
    test(
      'converts from and to message pack in base64 url no pad format',
      () {
        expect(msgPack64UrlNoPad.encode(42), 'Kg');
        expect(msgPack64UrlNoPad.decode('Kg'), 42);
      },
    );
  });
}
