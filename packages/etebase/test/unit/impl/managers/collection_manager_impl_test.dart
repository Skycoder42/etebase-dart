// ignore_for_file: discarded_futures

import 'dart:typed_data';

import 'package:etebase/src/api/models/fetch_options.dart';
import 'package:etebase/src/api/models/item_metadata.dart';
import 'package:etebase/src/api/models/list_response.dart';
import 'package:etebase/src/api/models/removed_collection.dart';
import 'package:etebase/src/impl/crypto/account_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/collection_crypto_manager.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection_item.dart';
import 'package:etebase/src/impl/managers/client_impl.dart';
import 'package:etebase/src/impl/managers/collection_impl.dart';
import 'package:etebase/src/impl/managers/collection_manager_impl.dart';
import 'package:etebase/src/impl/online_managers/base_manager.dart';
import 'package:etebase/src/impl/online_managers/collection_item_manager_online.dart';
import 'package:etebase/src/impl/online_managers/collection_manager_online.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// ignore: directives_ordering
import '../../test_helpers.dart';
@GenerateNiceMocks([
  MockSpec<ClientImpl>(),
  MockSpec<AccountCryptoManager>(),
  MockSpec<CollectionManagerOnline>(),
  MockSpec<EncryptedCollection>(),
  MockSpec<CollectionCryptoManager>(),
  MockSpec<CollectionItemManagerOnline>(),
])
import 'collection_manager_impl_test.mocks.dart';

class FakeEncryptedCollectionItem extends Fake
    implements EncryptedCollectionItem {}

class FakeAuthTokenSource extends Fake implements AuthTokenSource {}

void main() {
  group('$CollectionManagerImpl', () {
    const testColType = 'test-collection-type';
    const testMeta = ItemMetadata(name: 'test');
    final testContent = Uint8List.fromList([213, 3, 22]);
    const testUid = 'test-collection-id';
    const testOptions = FetchOptions(limit: 12);

    final mockClient = MockClientImpl();
    final mockAccountCM = MockAccountCryptoManager();
    final mockOnline = MockCollectionManagerOnline();
    final mockEncryptedCollection = MockEncryptedCollection();
    final mockCollectionCM = MockCollectionCryptoManager();
    final mockItemOnline = MockCollectionItemManagerOnline();

    final testCollection = CollectionImpl(
      mockClient,
      mockCollectionCM,
      mockEncryptedCollection,
    );

    late CollectionManagerImpl sut;

    setUp(() {
      reset(mockClient);
      reset(mockAccountCM);
      reset(mockOnline);
      reset(mockEncryptedCollection);
      reset(mockCollectionCM);
      reset(mockItemOnline);

      when(
        mockClient.createEncryptedCollection(any, any, any, any),
      ).thenReturnAsync((mockEncryptedCollection, mockCollectionCM));

      when(
        mockEncryptedCollection.getCryptoManager(any, any),
      ).thenReturn(mockCollectionCM);

      when(mockOnline.itemManager(any)).thenReturn(mockItemOnline);

      sut = CollectionManagerImpl(mockClient, mockAccountCM, mockOnline);
    });

    test('create creates new collection', () async {
      final result = await sut.create(testColType, testMeta, testContent);

      expect(result.encrypted, mockEncryptedCollection);

      verify(
        mockClient.createEncryptedCollection(
          mockAccountCM,
          testColType,
          testMeta,
          testContent,
        ),
      );

      result.dispose();

      verify(mockCollectionCM.dispose());
    });

    test('fetch fetches collection from remote', () async {
      when(mockOnline.fetch(any, any)).thenReturnAsync(mockEncryptedCollection);

      final result = await sut.fetch(testUid, testOptions);

      expect(result.encrypted, mockEncryptedCollection);

      verifyInOrder([
        mockOnline.fetch(testUid, testOptions),
        mockEncryptedCollection.getCryptoManager(mockClient, mockAccountCM),
      ]);
    });

    test('list fetches single collection type', () async {
      final testUid = Uint8List.fromList([33, 0]);

      final mockOtherEncryptedCollection = MockEncryptedCollection();
      final testResponse = CollectionListResponse(
        data: [mockEncryptedCollection, mockOtherEncryptedCollection],
        isDone: true,
        stoken: 'test-stoken',
        removedMemberships: [const RemovedCollection('test-rm')],
      );

      when(mockAccountCM.colTypeToUid(any)).thenReturnInOrder([testUid]);
      when(mockOnline.list(any, any)).thenReturnAsync(testResponse);
      when(
        mockEncryptedCollection.getCryptoManager(any, any),
      ).thenReturn(mockCollectionCM);

      final result = await sut.list(testColType, testOptions);

      expect(result.data, hasLength(2));
      expect(result.data[0].encrypted, mockEncryptedCollection);
      expect(result.data[1].encrypted, mockOtherEncryptedCollection);
      expect(result.isDone, isTrue);
      expect(result.stoken, testResponse.stoken);
      expect(result.removedMemberships, testResponse.removedMemberships);

      verifyInOrder([
        mockAccountCM.colTypeToUid(testColType),
        mockOnline.list([testUid], testOptions),
        mockEncryptedCollection.getCryptoManager(mockClient, mockAccountCM),
        mockOtherEncryptedCollection.getCryptoManager(
          mockClient,
          mockAccountCM,
        ),
      ]);
    });

    test('listMulti fetches all collections for the given types', () async {
      const testOtherType = 'other-type';
      final testUid1 = Uint8List.fromList([33, 1]);
      final testUid2 = Uint8List.fromList([33, 2]);

      final mockOtherEncryptedCollection = MockEncryptedCollection();
      final testResponse = CollectionListResponse(
        data: [mockEncryptedCollection, mockOtherEncryptedCollection],
        isDone: true,
        stoken: 'test-stoken',
        removedMemberships: [const RemovedCollection('test-rm')],
      );

      when(
        mockAccountCM.colTypeToUid(any),
      ).thenReturnInOrder([testUid1, testUid2]);
      when(mockOnline.list(any, any)).thenReturnAsync(testResponse);
      when(
        mockEncryptedCollection.getCryptoManager(any, any),
      ).thenReturn(mockCollectionCM);

      final result = await sut.listMulti([
        testColType,
        testOtherType,
      ], testOptions);

      expect(result.data, hasLength(2));
      expect(result.data[0].encrypted, mockEncryptedCollection);
      expect(result.data[1].encrypted, mockOtherEncryptedCollection);
      expect(result.isDone, isTrue);
      expect(result.stoken, testResponse.stoken);
      expect(result.removedMemberships, testResponse.removedMemberships);

      verifyInOrder([
        mockAccountCM.colTypeToUid(testColType),
        mockAccountCM.colTypeToUid(testOtherType),
        mockOnline.list([testUid1, testUid2], testOptions),
        mockEncryptedCollection.getCryptoManager(mockClient, mockAccountCM),
        mockOtherEncryptedCollection.getCryptoManager(
          mockClient,
          mockAccountCM,
        ),
      ]);
    });

    group('upload', () {
      test('invokes create for newly created collection', () async {
        await sut.upload(testCollection, testOptions);

        verifyInOrder([
          mockEncryptedCollection.lastEtag,
          mockOnline.create(mockEncryptedCollection, testOptions),
          mockEncryptedCollection.markSaved(),
        ]);
      });

      test('invokes batch on item manager for existing collections', () async {
        const testEtag = 'test-etag';
        final testItem = FakeEncryptedCollectionItem();

        when(mockEncryptedCollection.uid).thenReturn(testUid);
        when(mockEncryptedCollection.lastEtag).thenReturn(testEtag);
        when(mockEncryptedCollection.item).thenReturn(testItem);

        await sut.upload(testCollection, testOptions);

        verifyInOrder([
          mockEncryptedCollection.lastEtag,
          mockEncryptedCollection.uid,
          mockOnline.itemManager(testUid),
          mockEncryptedCollection.item,
          mockItemOnline.batch([testItem], null, testOptions.asItemOptions()),
          mockEncryptedCollection.markSaved(),
        ]);
      });
    });

    group('transaction', () {
      test('invokes create for newly created collection', () async {
        await sut.transaction(testCollection, testOptions);

        verifyInOrder([
          mockEncryptedCollection.lastEtag,
          mockOnline.create(mockEncryptedCollection, testOptions),
          mockEncryptedCollection.markSaved(),
        ]);
      });

      test('invokes batch on item manager for existing collections', () async {
        const testEtag = 'test-etag';
        final testItem = FakeEncryptedCollectionItem();

        when(mockEncryptedCollection.uid).thenReturn(testUid);
        when(mockEncryptedCollection.lastEtag).thenReturn(testEtag);
        when(mockEncryptedCollection.item).thenReturn(testItem);

        await sut.transaction(testCollection, testOptions);

        verifyInOrder([
          mockEncryptedCollection.lastEtag,
          mockEncryptedCollection.uid,
          mockOnline.itemManager(testUid),
          mockEncryptedCollection.item,
          mockItemOnline.transaction(
            [testItem],
            null,
            testOptions.asItemOptions(),
          ),
          mockEncryptedCollection.markSaved(),
        ]);
      });
    });

    test('cacheSave saves collection to bytes', () {
      final testBytes = Uint8List.fromList([12, 32, 1]);

      when(
        mockEncryptedCollection.cacheSave(
          any,
          saveContent: anyNamed('saveContent'),
        ),
      ).thenReturn(testBytes);

      final result = sut.cacheSave(testCollection);

      expect(result, testBytes);

      verify(mockEncryptedCollection.cacheSave(mockClient, saveContent: true));
    });

    test('cacheLoad loads collection from bytes', () {
      final testBytes = Uint8List.fromList([12, 32, 4]);

      when(
        mockClient.cacheLoadEncryptedCollection(any),
      ).thenReturn(mockEncryptedCollection);
      when(
        mockEncryptedCollection.getCryptoManager(any, any),
      ).thenReturn(mockCollectionCM);

      final result = sut.cacheLoad(testBytes);
      expect(result.encrypted, same(mockEncryptedCollection));

      verifyInOrder([
        mockClient.cacheLoadEncryptedCollection(testBytes),
        mockEncryptedCollection.getCryptoManager(mockClient, mockAccountCM),
      ]);
    });

    test('getItemManager creates item manager', () {
      final testBaseUrl = Uri.http('example.com', 'test');
      final testAuthTokenSource = FakeAuthTokenSource();

      when(mockClient.baseUrl).thenReturn(testBaseUrl);

      when(mockOnline.authTokenSource).thenReturn(testAuthTokenSource);

      when(mockEncryptedCollection.uid).thenReturn(testUid);
      when(
        mockEncryptedCollection.getCryptoManager(any, any),
      ).thenReturn(mockCollectionCM);

      final result = sut.getItemManager(testCollection);

      expect(result.client, same(mockClient));
      expect(result.cryptoManager, same(mockCollectionCM));
      expect(
        result.online.apiUrl,
        Uri.parse('http://example.com/test/api/v1/collection/$testUid/item'),
      );
      expect(result.online.authTokenSource, same(testAuthTokenSource));
      expect(result.colUid, testUid);

      verifyInOrder([
        mockEncryptedCollection.getCryptoManager(mockClient, mockAccountCM),
        mockEncryptedCollection.uid,
        mockEncryptedCollection.uid,
      ]);
    });

    test('getMemberManager creates member manager', () {
      final testBaseUrl = Uri.http('example.com', 'test');
      final testAuthTokenSource = FakeAuthTokenSource();

      when(mockClient.baseUrl).thenReturn(testBaseUrl);

      when(mockOnline.authTokenSource).thenReturn(testAuthTokenSource);

      when(mockEncryptedCollection.uid).thenReturn(testUid);

      final result = sut.getMemberManager(testCollection);

      expect(
        result.online.apiUrl,
        Uri.parse('http://example.com/test/api/v1/collection/$testUid/member'),
      );
      expect(result.online.authTokenSource, same(testAuthTokenSource));

      verify(mockEncryptedCollection.uid).called(1);
    });
  });
}
