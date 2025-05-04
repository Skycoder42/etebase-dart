// ignore_for_file: discarded_futures

import 'dart:typed_data';

import 'package:etebase/src/api/models/etebase_item_metadata.dart';
import 'package:etebase/src/impl/crypto/collection_item_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/minimal_collection_crypto_manager.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection_item.dart';
import 'package:etebase/src/impl/managers/client.dart';
import 'package:etebase/src/impl/managers/item_manager.dart';
import 'package:etebase/src/impl/online_managers/collection_item_manager_online.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// ignore: directives_ordering
import '../../test_helpers.dart';
@GenerateNiceMocks([
  MockSpec<Client>(),
  MockSpec<MinimalCollectionCryptoManager>(),
  MockSpec<CollectionItemCryptoManager>(),
  MockSpec<CollectionItemManagerOnline>(),
  MockSpec<EncryptedCollectionItem>(),
])
import 'item_manager_test.mocks.dart';

void main() {
  group('$ItemManager', () {
    const testUid = 'test-uid';
    const testMeta = EtebaseItemMetadata(name: 'test-item');
    final testContent = Uint8List.fromList([12, 4, 11, 3]);

    final mockClient = MockClient();
    final mockMinCollectionCM = MockMinimalCollectionCryptoManager();
    final mockCollectionItemCM = MockCollectionItemCryptoManager();
    final mockOnline = MockCollectionItemManagerOnline();
    final mockEncrypted = MockEncryptedCollectionItem();

    late ItemManager sut;

    setUp(() {
      reset(mockClient);
      reset(mockMinCollectionCM);
      reset(mockCollectionItemCM);
      reset(mockOnline);
      reset(mockEncrypted);

      when(
        mockClient.createEncryptedCollectionItem(any, any, any),
      ).thenReturnAsync((mockEncrypted, mockCollectionItemCM));

      sut = ItemManager(mockClient, mockMinCollectionCM, mockOnline, testUid);
    });

    test('dispose disposes the crypto manager', () {
      sut.dispose();

      verify(mockMinCollectionCM.dispose());
    });

    test('create creates new item', () async {
      final result = await sut.create(testMeta, testContent);

      expect(result.colUid, testUid);
      expect(result.encrypted, same(mockEncrypted));

      verifyInOrder([
        mockClient.createEncryptedCollectionItem(
          mockMinCollectionCM,
          testMeta,
          testContent,
        ),
      ]);
      verifyZeroInteractions(mockEncrypted);

      await result.verify();

      verify(mockEncrypted.verify(mockClient, mockCollectionItemCM));
    });

    test('fetch calls fetch on online and creates item', () async {
      final result = await sut.fetch(testItemUid);
    });
  });
}
