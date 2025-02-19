import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/etebase.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_collection_item.dart';
import 'package:test/test.dart';

void main() {
  group('$CachedCollectionItem', () {
    testData(
      'correctly converts to and from json',
      [
        (
          CachedCollectionItem(
            uid: Uint8List.fromList([8, 1, 2, 4, 1]),
            version: 3,
            encryptionKey: Uint8List.fromList([5, 11, 4, 12]),
            etag: Uint8List.fromList([9, 6, 21, 2]),
            revision: Uint8List.fromList([5, 5, 1, 3]),
          ),
          [
            CachedCollectionItem.cacheFormatVersion,
            Uint8List.fromList([8, 1, 2, 4, 1]),
            3,
            Uint8List.fromList([5, 11, 4, 12]),
            Uint8List.fromList([9, 6, 21, 2]),
            Uint8List.fromList([5, 5, 1, 3]),
          ],
        ),
        (
          CachedCollectionItem(
            uid: Uint8List.fromList([1]),
            version: 2,
            encryptionKey: null,
            etag: null,
            revision: Uint8List.fromList([3]),
          ),
          [
            CachedCollectionItem.cacheFormatVersion,
            Uint8List.fromList([1]),
            2,
            null,
            null,
            Uint8List.fromList([3]),
          ],
        ),
      ],
      (fixture) {
        expect(fixture.$1.toJson(), fixture.$2);
        expect(CachedCollectionItem.fromJson(fixture.$2), fixture.$1);
      },
    );

    test('throws if cache version is incorrect', () {
      const testVersion = 4711;
      expect(
        () => CachedCollectionItem.fromJson([
          testVersion,
          Uint8List.fromList([1]),
          2,
          null,
          null,
          Uint8List.fromList([3]),
        ]),
        throwsA(
          isA<ApiMissuse>().having(
            (m) => m.message,
            'message',
            contains('$testVersion'),
          ),
        ),
      );
    });
  });
}
