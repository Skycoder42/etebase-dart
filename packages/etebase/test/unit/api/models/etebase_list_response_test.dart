import 'package:etebase/src/api/models/etebase_list_response.dart';
import 'package:etebase/src/api/models/etebase_removed_collection.dart';
import 'package:test/test.dart';

void main() {
  group('$EtebaseListResponse', () {
    group('item', () {
      test('map creates item list response with mapped data', () {
        const original = EtebaseItemListResponse(
          data: [1, 2, 3],
          isDone: true,
          stoken: 'test_token',
        );

        final mapped = original.map((v) => v * 2);
        expect(mapped, isA<EtebaseItemListResponse>());
        expect(mapped.data, [2, 4, 6]);
        expect(mapped.isDone, original.isDone);
        expect(mapped.stoken, original.stoken);
      });
    });

    group('collection', () {
      test('map creates item collection response with mapped data', () {
        const original = EtebaseCollectionListResponse(
          data: [1, 2, 3],
          isDone: true,
          stoken: 'test_token',
          removedMemberships: [EtebaseRemovedCollection('test_removed')],
        );

        final mapped = original.map((v) => v * v);
        expect(mapped, isA<EtebaseCollectionListResponse>());
        expect(mapped.data, [1, 4, 9]);
        expect(mapped.isDone, original.isDone);
        expect(mapped.stoken, original.stoken);
        expect(mapped.removedMemberships, original.removedMemberships);
      });
    });

    group('iterator', () {
      test('map creates iterator list response with mapped data', () {
        const original = EtebaseIteratorListResponse(
          data: [1, 2, 3],
          isDone: true,
          iterator: 'test_iterator',
        );

        final mapped = original.map((v) => v + 10);
        expect(mapped, isA<EtebaseIteratorListResponse>());
        expect(mapped.data, [11, 12, 13]);
        expect(mapped.isDone, original.isDone);
        expect(mapped.iterator, original.iterator);
      });
    });
  });
}
