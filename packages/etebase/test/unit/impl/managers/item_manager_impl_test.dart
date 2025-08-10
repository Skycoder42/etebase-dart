import 'dart:async';
import 'dart:typed_data';

import 'package:dart_test_tools/test.dart' hide MockCallable2;
import 'package:etebase/src/api/exceptions/api_missuse.dart';
import 'package:etebase/src/api/exceptions/conflict.dart';
import 'package:etebase/src/api/models/fetch_options.dart';
import 'package:etebase/src/api/models/item_metadata.dart';
import 'package:etebase/src/api/models/list_response.dart';
import 'package:etebase/src/impl/crypto/collection_item_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/minimal_collection_crypto_manager.dart';
import 'package:etebase/src/impl/encrypted_models/chunk.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection_item.dart';
import 'package:etebase/src/impl/managers/client_impl.dart';
import 'package:etebase/src/impl/managers/item_impl.dart';
import 'package:etebase/src/impl/managers/item_manager_impl.dart';
import 'package:etebase/src/impl/online_managers/collection_item_manager_online.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';
@GenerateNiceMocks([
  MockSpec<ClientImpl>(),
  MockSpec<MinimalCollectionCryptoManager>(),
  MockSpec<CollectionItemCryptoManager>(),
  MockSpec<CollectionItemManagerOnline>(),
  MockSpec<EncryptedCollectionItem>(),
  // ignore: strict_raw_type
  MockSpec<Callable2>(),
])
import 'item_manager_impl_test.mocks.dart';

void main() {
  group('$ItemManagerImpl', () {
    const testColUid = 'test-col-uid';
    const testItemUid = 'test-item-uid';
    const testMeta = ItemMetadata(name: 'test-item');
    final testContent = Uint8List.fromList([12, 4, 11, 3]);
    const testOptions = ItemFetchOptions(limit: 22);
    const testRevOptions = RevisionFetchOptions(limit: 33);
    const testStoken = 'test-stoken';
    const testIterator = 'test-iterator';

    final mockClient = MockClientImpl();
    final mockCollectionCM = MockMinimalCollectionCryptoManager();
    final mockItemCM = MockCollectionItemCryptoManager();
    final mockOnline = MockCollectionItemManagerOnline();
    final mockEncrypted = MockEncryptedCollectionItem();

    final testItem = ItemImpl(
      mockClient,
      mockItemCM,
      mockEncrypted,
      testColUid,
    );

    late ItemManagerImpl sut;

    setUp(() {
      reset(mockClient);
      reset(mockCollectionCM);
      reset(mockItemCM);
      reset(mockOnline);
      reset(mockEncrypted);

      when(
        mockClient.createEncryptedCollectionItem(any, any, any),
      ).thenReturnAsync((mockEncrypted, mockItemCM));

      when(mockEncrypted.getCryptoManager(any, any)).thenReturn(mockItemCM);

      sut = ItemManagerImpl(
        mockClient,
        mockCollectionCM,
        mockOnline,
        testColUid,
      );
    });

    test('dispose disposes the crypto manager', () {
      sut.dispose();

      verify(mockCollectionCM.dispose());
    });

    test('create creates new item', () async {
      final result = await sut.create(testMeta, testContent);

      expect(result.colUid, testColUid);
      expect(result.encrypted, same(mockEncrypted));

      verifyInOrder([
        mockClient.createEncryptedCollectionItem(
          mockCollectionCM,
          testMeta,
          testContent,
        ),
      ]);
      verifyZeroInteractions(mockEncrypted);

      await result.verify();

      verify(mockEncrypted.verify(mockClient, mockItemCM));
    });

    test('fetch calls fetch on online and creates item', () async {
      when(mockOnline.fetch(any, any)).thenReturnAsync(mockEncrypted);

      final result = await sut.fetch(testItemUid, testOptions);

      expect(result.colUid, testColUid);
      expect(result.encrypted, same(mockEncrypted));

      verifyInOrder([
        mockOnline.fetch(testItemUid, testOptions),
        mockEncrypted.getCryptoManager(mockClient, mockCollectionCM),
      ]);
    });

    test('list returns list of items from online manager', () async {
      final otherItem = MockEncryptedCollectionItem();

      when(mockOnline.list(any)).thenReturnAsync(
        ItemListResponse(
          data: [mockEncrypted, otherItem],
          isDone: false,
          stoken: testStoken,
        ),
      );

      final result = await sut.list(testOptions);
      expect(result.data, hasLength(2));
      expect(result.data[0].encrypted, same(mockEncrypted));
      expect(result.data[1].encrypted, same(otherItem));
      expect(result.isDone, isFalse);
      expect(result.stoken, testStoken);

      verifyInOrder([
        mockOnline.list(testOptions),
        mockEncrypted.getCryptoManager(mockClient, mockCollectionCM),
        otherItem.getCryptoManager(mockClient, mockCollectionCM),
      ]);
    });

    test('itemRevisions returns list of items from online manager', () async {
      final otherItem = MockEncryptedCollectionItem();

      when(mockOnline.itemRevisions(any, any)).thenReturnAsync(
        IteratorListResponse(
          data: [mockEncrypted, otherItem],
          isDone: true,
          iterator: testIterator,
        ),
      );

      final result = await sut.itemRevisions(testItem, testRevOptions);
      expect(result.data, hasLength(2));
      expect(result.data[0].encrypted, same(mockEncrypted));
      expect(result.data[1].encrypted, same(otherItem));
      expect(result.isDone, isTrue);
      expect(result.iterator, testIterator);

      verifyInOrder([
        mockOnline.itemRevisions(mockEncrypted, testRevOptions),
        mockEncrypted.getCryptoManager(mockClient, mockCollectionCM),
        otherItem.getCryptoManager(mockClient, mockCollectionCM),
      ]);
    });

    group('fetchUpdates', () {
      test('fetches new versions of items from online manager', () async {
        final otherItem = MockEncryptedCollectionItem();

        when(mockOnline.fetchUpdates(any, any)).thenReturnAsync(
          ItemListResponse(
            data: [mockEncrypted, otherItem],
            isDone: true,
            stoken: testStoken,
          ),
        );

        final result = await sut.fetchUpdates([testItem], testOptions);
        expect(result.data, hasLength(2));
        expect(result.data[0].encrypted, same(mockEncrypted));
        expect(result.data[1].encrypted, same(otherItem));
        expect(result.isDone, isTrue);
        expect(result.stoken, testStoken);

        verifyInOrder([
          mockOnline.fetchUpdates([mockEncrypted], testOptions),
          mockEncrypted.getCryptoManager(mockClient, mockCollectionCM),
          otherItem.getCryptoManager(mockClient, mockCollectionCM),
        ]);
      });

      test('throws if item does not belong to collection', () async {
        const testOtherId = 'other-col-uid';

        await expectLater(
          () => sut.fetchUpdates([
            testItem,
            ItemImpl(mockClient, mockItemCM, mockEncrypted, testOtherId),
          ]),
          throwsA(
            isA<ApiMissuse>().having(
              (m) => m.message,
              'message',
              allOf(contains(testColUid), contains(testOtherId)),
            ),
          ),
        );
      });
    });

    test('fetchMulti fetches multiple items', () async {
      const testOtherItemUid = 'other-item-uid';

      final otherItem = MockEncryptedCollectionItem();

      when(mockOnline.fetchMulti(any, any)).thenReturnAsync(
        ItemListResponse(
          data: [mockEncrypted, otherItem],
          isDone: false,
          stoken: testStoken,
        ),
      );

      final result = await sut.fetchMulti([
        testItemUid,
        testOtherItemUid,
      ], testOptions);
      expect(result.data, hasLength(2));
      expect(result.data[0].encrypted, same(mockEncrypted));
      expect(result.data[1].encrypted, same(otherItem));
      expect(result.isDone, isFalse);
      expect(result.stoken, testStoken);

      verifyInOrder([
        mockOnline.fetchMulti([testItemUid, testOtherItemUid], testOptions),
        mockEncrypted.getCryptoManager(mockClient, mockCollectionCM),
        otherItem.getCryptoManager(mockClient, mockCollectionCM),
      ]);
    });

    group('batch', () {
      final otherEncItem = MockEncryptedCollectionItem();
      final otherItem = ItemImpl(
        mockClient,
        mockItemCM,
        otherEncItem,
        testColUid,
      );

      setUp(() {
        reset(otherEncItem);
      });

      test('uploads items via online manager', () async {
        await sut.batch([testItem, otherItem], options: testOptions);

        verifyInOrder([
          mockOnline.batch([mockEncrypted, otherEncItem], null, testOptions),
          mockEncrypted.markSaved(),
          otherEncItem.markSaved(),
        ]);
      });

      test('adds dependencies if given', () async {
        await sut.batch([testItem], deps: [otherItem], options: testOptions);

        verifyInOrder([
          mockOnline.batch([mockEncrypted], [otherEncItem], testOptions),
          mockEncrypted.markSaved(),
        ]);
        verifyNever(otherEncItem.markSaved());
      });

      test('throws if item does not belong to collection', () async {
        const testOtherId = 'other-col-uid';
        final otherItem = ItemImpl(
          mockClient,
          mockItemCM,
          otherEncItem,
          testOtherId,
        );

        await expectLater(
          () => sut.batch([otherItem]),
          throwsA(
            isA<ApiMissuse>().having(
              (m) => m.message,
              'message',
              allOf(contains(testColUid), contains(testOtherId)),
            ),
          ),
        );
      });

      test('throws if dependency does not belong to collection', () async {
        const testOtherId = 'other-col-uid';
        final otherItem = ItemImpl(
          mockClient,
          mockItemCM,
          otherEncItem,
          testOtherId,
        );

        await expectLater(
          () => sut.batch([testItem], deps: [otherItem]),
          throwsA(
            isA<ApiMissuse>().having(
              (m) => m.message,
              'message',
              allOf(contains(testColUid), contains(testOtherId)),
            ),
          ),
        );
      });
    });

    group('transaction', () {
      final otherEncItem = MockEncryptedCollectionItem();
      final otherItem = ItemImpl(
        mockClient,
        mockItemCM,
        otherEncItem,
        testColUid,
      );

      setUp(() {
        reset(otherEncItem);
      });

      test('uploads items via online manager', () async {
        await sut.transaction([testItem, otherItem], options: testOptions);

        verifyInOrder([
          mockOnline.transaction(
            [mockEncrypted, otherEncItem],
            null,
            testOptions,
          ),
          mockEncrypted.markSaved(),
          otherEncItem.markSaved(),
        ]);
      });

      test('adds dependencies if given', () async {
        await sut.transaction(
          [testItem],
          deps: [otherItem],
          options: testOptions,
        );

        verifyInOrder([
          mockOnline.transaction([mockEncrypted], [otherEncItem], testOptions),
          mockEncrypted.markSaved(),
        ]);
        verifyNever(otherEncItem.markSaved());
      });

      test('throws if item does not belong to collection', () async {
        const testOtherId = 'other-col-uid';
        final otherItem = ItemImpl(
          mockClient,
          mockItemCM,
          otherEncItem,
          testOtherId,
        );

        await expectLater(
          () => sut.transaction([otherItem]),
          throwsA(
            isA<ApiMissuse>().having(
              (m) => m.message,
              'message',
              allOf(contains(testColUid), contains(testOtherId)),
            ),
          ),
        );
      });

      test('throws if dependency does not belong to collection', () async {
        const testOtherId = 'other-col-uid';
        final otherItem = ItemImpl(
          mockClient,
          mockItemCM,
          otherEncItem,
          testOtherId,
        );

        await expectLater(
          () => sut.transaction([testItem], deps: [otherItem]),
          throwsA(
            isA<ApiMissuse>().having(
              (m) => m.message,
              'message',
              allOf(contains(testColUid), contains(testOtherId)),
            ),
          ),
        );
      });
    });

    group('uploadContent', () {
      final testChunk1 = Chunk('chunk-1', Uint8List.fromList([1]));
      final testChunk2 = Chunk('chunk-2', Uint8List.fromList([2]));

      setUp(() {
        when(mockEncrypted.pendingChunks).thenReturn([testChunk1, testChunk2]);
      });

      test('uploads encrypted item chunks', () async {
        await sut.uploadContent(testItem);

        verifyInOrder([
          mockEncrypted.pendingChunks,
          mockOnline.chunkUpload(mockEncrypted, testChunk1, null),
          mockOnline.chunkUpload(mockEncrypted, testChunk2, null),
        ]);
      });

      test('reports progress', () async {
        final onProgress = MockCallable2<void, int, int>();

        await sut.uploadContent(testItem, onProgress: onProgress.call);

        verifyInOrder([
          onProgress.call(0, 2),
          onProgress.call(1, 2),
          onProgress.call(2, 2),
        ]);
      });

      test('ignores conflict exceptions', () async {
        final testException = Conflict('test');
        when(mockOnline.chunkUpload(any, any, any)).thenThrow(testException);

        await sut.uploadContent(testItem);

        verifyInOrder([
          mockEncrypted.pendingChunks,
          mockOnline.chunkUpload(mockEncrypted, testChunk1, null),
          mockOnline.chunkUpload(mockEncrypted, testChunk2, null),
        ]);
      });

      test('throws if item does not belong to collection', () async {
        const testOtherId = 'other-col-uid';

        await expectLater(
          () => sut.uploadContent(
            ItemImpl(mockClient, mockItemCM, mockEncrypted, testOtherId),
          ),
          throwsA(
            isA<ApiMissuse>().having(
              (m) => m.message,
              'message',
              allOf(contains(testColUid), contains(testOtherId)),
            ),
          ),
        );
      });
    });

    group('downloadContent', () {
      const testChunk1 = Chunk('chunk-1', null);
      const testChunk2 = Chunk('chunk-2', null);
      final testData1 = Uint8List.fromList([1]);
      final testData2 = Uint8List.fromList([2]);

      setUp(() {
        when(mockEncrypted.missingChunks).thenReturn([testChunk1, testChunk2]);

        when(
          mockOnline.chunkDownload(any, testChunk1.uid, any),
        ).thenReturnAsync(testData1);
        when(
          mockOnline.chunkDownload(any, testChunk2.uid, any),
        ).thenReturnAsync(testData2);
      });

      test('downloads encrypted item chunks', () async {
        await sut.downloadContent(testItem);

        verifyInOrder([
          mockEncrypted.missingChunks,
          mockOnline.chunkDownload(mockEncrypted, testChunk1.uid, null),
          mockEncrypted.updateChunk(Chunk(testChunk1.uid, testData1)),
          mockOnline.chunkDownload(mockEncrypted, testChunk2.uid, null),
          mockEncrypted.updateChunk(Chunk(testChunk2.uid, testData2)),
        ]);
      });

      test('reports progress', () async {
        final onProgress = MockCallable2<void, int, int>();

        await sut.downloadContent(testItem, onProgress: onProgress.call);

        verifyInOrder([
          onProgress.call(0, 2),
          onProgress.call(1, 2),
          onProgress.call(2, 2),
        ]);
      });

      test('throws if item does not belong to collection', () async {
        const testOtherId = 'other-col-uid';

        await expectLater(
          () => sut.downloadContent(
            ItemImpl(mockClient, mockItemCM, mockEncrypted, testOtherId),
          ),
          throwsA(
            isA<ApiMissuse>().having(
              (m) => m.message,
              'message',
              allOf(contains(testColUid), contains(testOtherId)),
            ),
          ),
        );
      });
    });

    test('cacheSave converts item to byte array', () {
      final testData = Uint8List.fromList([4, 5, 11]);

      when(
        mockEncrypted.cacheSave(any, saveContent: anyNamed('saveContent')),
      ).thenReturn(testData);

      final result = sut.cacheSave(testItem);
      expect(result, testData);

      verify(mockEncrypted.cacheSave(mockClient, saveContent: true)).called(1);
    });

    test('cacheLoad converts byte array to item', () {
      final testData = Uint8List.fromList([4, 5, 11]);

      when(
        mockClient.cacheLoadEncryptedCollectionItem(any),
      ).thenReturn(mockEncrypted);

      final result = sut.cacheLoad(testData);

      expect(result.colUid, testColUid);
      expect(result.encrypted, same(mockEncrypted));

      verifyInOrder([
        mockClient.cacheLoadEncryptedCollectionItem(testData),
        mockEncrypted.getCryptoManager(mockClient, mockCollectionCM),
      ]);
    });

    test('subscribeChanges subscribes via online manager', () {
      final testError = Exception('test');
      final testController =
          StreamController<ItemListResponse<EncryptedCollectionItem>>()
            ..add(
              ItemListResponse(
                data: [mockEncrypted],
                isDone: false,
                stoken: testStoken,
              ),
            )
            ..addError(testError)
            ..add(const ItemListResponse(data: [], isDone: true));

      when(mockOnline.subscribeChanges(any)).thenStream(testController.stream);

      final result = sut.subscribeChanges(testOptions);

      expect(
        result,
        emitsInOrder([
          isA<ItemListResponse<ItemImpl>>()
              .having(
                (m) => m.data,
                'data',
                orderedEquals([
                  isA<ItemImpl>()
                      .having((m) => m.colUid, 'colUid', testColUid)
                      .having((m) => m.encrypted, 'encrypted', mockEncrypted),
                ]),
              )
              .having((m) => m.isDone, 'isDone', isFalse)
              .having((m) => m.stoken, 'stoken', testStoken),
          emitsError(testError),
          const ItemListResponse<ItemImpl>(data: [], isDone: true),
          emitsDone,
        ]),
      );

      verify(mockOnline.subscribeChanges(testOptions));

      expect(testController.close(), completes);
    });
  });
}
