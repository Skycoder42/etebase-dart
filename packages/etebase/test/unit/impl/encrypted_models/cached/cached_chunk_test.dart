import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_chunk.dart';
import 'package:test/test.dart';

void main() {
  group('$CachedChunk', () {
    testData(
      'correctly converts to and from json',
      [
        (
          CachedChunk(Uint8List.fromList([4, 1, 2])),
          [
            Uint8List.fromList([4, 1, 2]),
          ],
        ),
        (
          CachedChunk(
            Uint8List.fromList([4, 1, 2]),
            Uint8List.fromList([32, 9]),
          ),
          [
            Uint8List.fromList([4, 1, 2]),
            Uint8List.fromList([32, 9]),
          ],
        ),
      ],
      (fixture) {
        expect(fixture.$1.toJson(), fixture.$2);
        expect(CachedChunk.fromJson(fixture.$2), fixture.$1);
      },
    );

    test('can decode with null data', () {
      expect(
        CachedChunk.fromJson([
          Uint8List.fromList([4, 1, 2]),
          null,
        ]),
        CachedChunk(Uint8List.fromList([4, 1, 2])),
      );
    });
  });
}
