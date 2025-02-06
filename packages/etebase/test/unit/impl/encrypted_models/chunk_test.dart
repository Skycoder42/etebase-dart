import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/impl/encrypted_models/chunk.dart';
import 'package:test/test.dart';

void main() {
  group('$Chunk', () {
    testData(
      'converts to and from json',
      [
        (const Chunk('uid1', null), ['uid1', null]),
        (
          Chunk('uid2', Uint8List.fromList([1, 2, 3])),
          [
            'uid2',
            Uint8List.fromList([1, 2, 3]),
          ]
        ),
      ],
      (fixture) {
        expect(fixture.$1.toJson(), fixture.$2);
        expect(Chunk.fromJson(fixture.$2), fixture.$1);
      },
    );
  });
}
