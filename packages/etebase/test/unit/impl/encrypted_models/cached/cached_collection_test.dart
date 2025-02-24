import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/exceptions/api_missuse.dart';
import 'package:etebase/src/api/models/etebase_collection_access_level.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_collection.dart';
import 'package:test/test.dart';

void main() {
  group('$CachedCollection', () {
    testData(
      'correctly converts to and from json',
      [
        (
          CachedCollection(
            collectionKey: Uint8List.fromList([99, 4, 1]),
            accessLevel: EtebaseCollectionAccessLevel.admin,
            stoken: 'test-stoken',
            item: Uint8List.fromList([9, 3, 1, 22]),
            collectionType: Uint8List.fromList([76, 3, 11]),
          ),
          [
            CachedCollection.cacheFormatVersion,
            Uint8List.fromList([99, 4, 1]),
            EtebaseCollectionAccessLevel.admin.value,
            'test-stoken',
            Uint8List.fromList([9, 3, 1, 22]),
            Uint8List.fromList([76, 3, 11]),
          ],
        ),
        (
          CachedCollection(
            collectionKey: Uint8List.fromList([1]),
            accessLevel: EtebaseCollectionAccessLevel.readOnly,
            stoken: null,
            item: Uint8List.fromList([2]),
            collectionType: Uint8List.fromList([3]),
          ),
          [
            CachedCollection.cacheFormatVersion,
            Uint8List.fromList([1]),
            EtebaseCollectionAccessLevel.readOnly.value,
            null,
            Uint8List.fromList([2]),
            Uint8List.fromList([3]),
          ],
        ),
      ],
      (fixture) {
        expect(fixture.$1.toJson(), fixture.$2);
        expect(CachedCollection.fromJson(fixture.$2), fixture.$1);
      },
    );

    test('throws if cache version is incorrect', () {
      const testVersion = 4711;
      expect(
        () => CachedCollection.fromJson([
          testVersion,
          Uint8List.fromList([1]),
          EtebaseCollectionAccessLevel.readOnly.value,
          null,
          Uint8List.fromList([2]),
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
