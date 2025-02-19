import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_chunk.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_revision.dart';
import 'package:test/test.dart';

void main() {
  group('$CachedRevision', () {
    testData(
      'correctly converts to and from json',
      [
        (
          CachedRevision(
            uid: Uint8List.fromList([9, 5, 1, 2, 33]),
            meta: Uint8List.fromList([5, 23, 24, 4]),
            deleted: true,
            chunks: [
              CachedChunk(Uint8List.fromList([1])),
              CachedChunk(Uint8List.fromList([2]), Uint8List.fromList([3])),
            ],
          ),
          [
            Uint8List.fromList([9, 5, 1, 2, 33]),
            Uint8List.fromList([5, 23, 24, 4]),
            true,
            [
              [
                Uint8List.fromList([1]),
              ],
              [
                Uint8List.fromList([2]),
                Uint8List.fromList([3]),
              ],
            ],
          ],
        ),
        (
          CachedRevision(
            uid: Uint8List.fromList([1]),
            meta: Uint8List.fromList([2]),
            deleted: false,
            chunks: [],
          ),
          [
            Uint8List.fromList([1]),
            Uint8List.fromList([2]),
            false,
            <dynamic>[],
          ],
        ),
      ],
      (fixture) {
        expect(fixture.$1.toJson(), fixture.$2);
        expect(CachedRevision.fromJson(fixture.$2), fixture.$1);
      },
    );
  });
}
