import 'package:etebase/src/impl/encrypted_models/encrypted_collection_item.dart';
import 'package:etebase/src/impl/models/collection_item_fetch_info.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class FakeEncryptedCollectionItem extends Fake
    implements EncryptedCollectionItem {
  @override
  final String uid;

  @override
  final String? lastEtag;

  new(this.uid, this.lastEtag);
}

void main() {
  group('CollectionItemFetchInfoFromListX', () {
    final testItems = [
      FakeEncryptedCollectionItem('test-id1', null),
      FakeEncryptedCollectionItem('test-id2', 'test-etag-2'),
    ];

    test('maps list of items to fetch model without etag', () {
      final result = testItems.toFetchInfo(wantEtag: false);

      expect(result, [
        const CollectionItemFetchInfo('test-id1'),
        const CollectionItemFetchInfo('test-id2'),
      ]);
    });

    test('maps list of items to fetch model with etag', () {
      final result = testItems.toFetchInfo(wantEtag: true);

      expect(result, [
        const CollectionItemFetchInfo('test-id1'),
        const CollectionItemFetchInfo('test-id2', etag: 'test-etag-2'),
      ]);
    });
  });
}
