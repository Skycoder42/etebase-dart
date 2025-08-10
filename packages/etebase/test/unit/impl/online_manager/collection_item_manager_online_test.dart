import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/exceptions/api_missuse.dart';
import 'package:etebase/src/api/exceptions/connection_problem.dart';
import 'package:etebase/src/api/models/fetch_options.dart';
import 'package:etebase/src/api/models/list_response.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/encrypted_models/chunk.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection_item.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_revision.dart';
import 'package:etebase/src/impl/models/auth_token.dart';
import 'package:etebase/src/impl/models/collection_item_fetch_info.dart';
import 'package:etebase/src/impl/models/item_batch_request.dart';
import 'package:etebase/src/impl/models/web_socket_ticket_response.dart';
import 'package:etebase/src/impl/online_managers/base_network.dart';
import 'package:etebase/src/impl/online_managers/collection_item_manager_online.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../test_helpers.dart';
@GenerateNiceMocks([
  MockSpec<WebSocketChannel>(),
  MockSpec<WebSocketSink>(),
  MockSpec<MessagePackConverter>(),
])
import 'collection_item_manager_online_test.mocks.dart';
import 'online_manager_mocks.dart';

void main() {
  group('$CollectionItemManagerOnline', () {
    const testAuthToken = AuthToken('test');
    const testOptions = ItemFetchOptions(limit: 1);
    const testRevOptions = RevisionFetchOptions(limit: 2);
    const testQuery = {'limit': '1'};
    const testRevQuery = {'limit': '2'};

    const testItemUid = 'test-itemUid';
    const testRevUid = 'test-revisionUid';
    const testChunkUid = 'test-chunkUid';
    final testItem1 = EncryptedCollectionItem()
      ..uid = testItemUid
      ..content = (EncryptedRevision()..uid = testRevUid)
      ..markSaved();
    final testItem2 = EncryptedCollectionItem()
      ..uid = 'test-itemUid-2'
      ..content = (EncryptedRevision()..uid = 'test-revisionUid-2')
      ..markSaved();
    final testChunk = Chunk(testChunkUid, Uint8List.fromList([44, 23]));

    final mockBaseNetwork = MockBaseNetwork();
    final mockAuthTokenSource = MockAuthTokenSource();

    late CollectionItemManagerOnline sut;

    setUpAll(() {
      provideDummy(testAuthToken);
    });

    setUp(() {
      reset(mockBaseNetwork);
      reset(mockAuthTokenSource);

      when(mockAuthTokenSource.authToken).thenReturn(testAuthToken);

      sut = CollectionItemManagerOnline.fromNetwork(
        mockBaseNetwork,
        mockAuthTokenSource,
      );
    });

    test('constructs base network from client and base path', () {
      final testBaseUri = Uri.http('example.com', '/base');
      const testColUid = 'test-colUid';

      final mockNetworkClient = MockNetworkClient();
      when(mockNetworkClient.baseUrl).thenReturn(testBaseUri);

      final sut = CollectionItemManagerOnline(
        client: mockNetworkClient,
        authTokenSource: mockAuthTokenSource,
        colUid: testColUid,
      );

      expect(
        sut.apiUrl,
        Uri.http('example.com', '/base/api/v1/collection/$testColUid/item'),
      );
      expect(sut.client, same(mockNetworkClient));
    });

    testInvoke(
      'fetch gets item id endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: testItem1,
      call: (_) => sut.fetch(testItemUid, testOptions),
      path: [testItemUid],
      query: testQuery,
      authToken: testAuthToken,
    );

    testInvoke(
      'list gets item endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: ItemListResponse(data: [testItem1], isDone: true),
      call: (_) => sut.list(testOptions),
      query: testQuery,
      authToken: testAuthToken,
    );

    test('itemRevisions gets item id revisions endpoint '
        'and maps the result into the item', () async {
      final testRev1 = EncryptedRevision()..uid = 'content-1';
      final testRev2 = EncryptedRevision()..uid = 'content-2';

      whenInvoke<IteratorListResponse<EncryptedRevision>>(
        mockBaseNetwork,
      ).thenReturnAsync(
        IteratorListResponse(
          data: [testRev1, testRev2],
          isDone: true,
          iterator: 'test-iter',
        ),
      );

      final result = await sut.itemRevisions(testItem1, testRevOptions);

      expect(
        result,
        isA<IteratorListResponse<EncryptedCollectionItem>>()
            .having((m) => m.isDone, 'isDone', isTrue)
            .having((m) => m.iterator, 'iterator', 'test-iter')
            .having((m) => m.data, 'data', [
              isA<EncryptedCollectionItem>()
                  .having((m) => m.uid, 'uid', testItemUid)
                  .having((m) => m.content, 'content', same(testRev1)),
              isA<EncryptedCollectionItem>()
                  .having((m) => m.uid, 'uid', testItemUid)
                  .having((m) => m.content, 'content', same(testRev2)),
            ]),
      );

      verify(
        mockBaseNetwork.invoke<IteratorListResponse<EncryptedRevision>>(
          path: [testItemUid, 'revision'],
          query: testRevQuery,
          authToken: testAuthToken,
        ),
      );
    });

    testInvoke<EncryptedCollectionItem, void>(
      'create posts item endpoint',
      mock: mockBaseNetwork,
      request: testItem1,
      response: null,
      call: (r) => sut.create(r),
      method: HttpMethod.post,
      authToken: testAuthToken,
    );

    testData(
      'fetchUpdates posts item updates endpoint '
      'and maps the request fetch infos',
      [
        (
          null,
          const CollectionItemFetchInfo(testItemUid, etag: testRevUid),
          testQuery,
        ),
        (
          'test-token',
          const CollectionItemFetchInfo(testItemUid),
          {...testQuery, 'stoken': 'test-token'},
        ),
      ],
      (fixture) async {
        final testResponse = ItemListResponse(
          data: [testItem1],
          isDone: false,
          stoken: 'new-token',
        );

        whenInvoke<ItemListResponse<EncryptedCollectionItem>>(
          mockBaseNetwork,
        ).thenReturnAsync(testResponse);

        final result = await sut.fetchUpdates([
          testItem1,
        ], testOptions.copyWith(stoken: fixture.$1));

        expect(result, testResponse);

        verify(
          mockBaseNetwork.invoke<ItemListResponse<EncryptedCollectionItem>>(
            method: HttpMethod.post,
            path: ['fetch_updates'],
            query: fixture.$3,
            authToken: testAuthToken,
            body: [fixture.$2],
          ),
        );
      },
    );

    testInvoke(
      'fetchMulti posts fetch updates endpoint',
      mock: mockBaseNetwork,
      request: [const CollectionItemFetchInfo(testItemUid)],
      response: ItemListResponse(data: [testItem1], isDone: true),
      call: (_) => sut.fetchMulti([testItemUid], testOptions),
      method: HttpMethod.post,
      path: ['fetch_updates'],
      query: testQuery,
      authToken: testAuthToken,
    );

    testInvoke<ItemBatchRequest, void>(
      'batch posts batch endpoint',
      mock: mockBaseNetwork,
      request: ItemBatchRequest(
        items: [testItem2],
        deps: [const CollectionItemFetchInfo(testItemUid, etag: testRevUid)],
      ),
      response: null,
      call: (_) => sut.batch([testItem2], [testItem1], testOptions),
      method: HttpMethod.post,
      path: ['batch'],
      query: testQuery,
      authToken: testAuthToken,
    );

    testInvoke<ItemBatchRequest, void>(
      'transaction posts transaction endpoint',
      mock: mockBaseNetwork,
      request: ItemBatchRequest(
        items: [testItem2],
        deps: [const CollectionItemFetchInfo(testItemUid, etag: testRevUid)],
      ),
      response: null,
      call: (_) => sut.transaction([testItem2], [testItem1], testOptions),
      method: HttpMethod.post,
      path: ['transaction'],
      query: testQuery,
      authToken: testAuthToken,
    );

    group('chunkUpload', () {
      testInvoke<Uint8List, void>(
        'puts item chunk id endpoint',
        mock: mockBaseNetwork,
        request: testChunk.data!,
        response: null,
        call: (_) => sut.chunkUpload(testItem1, testChunk, testOptions),
        method: HttpMethod.put,
        path: [testItemUid, 'chunk', testChunkUid],
        query: testQuery,
        authToken: testAuthToken,
      );

      test('throws ApiMissuse if chunk has no data', () {
        expect(
          () =>
              sut.chunkUpload(testItem1, const Chunk(testChunkUid, null), null),
          throwsA(isA<ApiMissuse>()),
        );

        verifyZeroInteractions(mockBaseNetwork);
      });
    });

    testInvoke(
      'chunkDownload gets item chunk id download endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: testChunk.data!,
      call: (_) => sut.chunkDownload(testItem1, testChunkUid, testOptions),
      path: [testItemUid, 'chunk', testChunkUid, 'download'],
      query: testQuery,
      authToken: testAuthToken,
    );

    group('subscribeChanges', () {
      final testBaseUri = Uri.https('example.com', '/base', {
        'x': '42',
        'stoken': 'token-2',
      });
      const testTicket = 'test-ws-ticket';

      final mockClient = MockNetworkClient();
      final mockWebSocketChannel = MockWebSocketChannel();
      final mockWebSocketSink = MockWebSocketSink();
      final mockConverter = MockMessagePackConverter();

      setUp(() {
        reset(mockClient);
        reset(mockWebSocketChannel);
        reset(mockWebSocketSink);
        reset(mockConverter);

        when(mockBaseNetwork.client).thenReturn(mockClient);
        whenInvoke<WebSocketTicketResponse>(
          mockBaseNetwork,
        ).thenReturnAsync(const WebSocketTicketResponse(testTicket));

        when(mockClient.baseUrl).thenReturn(testBaseUri);
        when(mockClient.converter).thenReturn(mockConverter);
        when(mockClient.connectWebSocket(any)).thenReturn(mockWebSocketChannel);

        when(mockWebSocketChannel.stream).thenStream(const Stream.empty());
        when(mockWebSocketChannel.sink).thenReturn(mockWebSocketSink);
      });

      test('opens channel with ticket', () async {
        final result = sut.subscribeChanges(
          const ItemFetchOptions(limit: 5, stoken: 'token-1'),
        );

        await expectLater(result, emitsDone);

        verifyInOrder([
          mockBaseNetwork.invoke<WebSocketTicketResponse>(
            method: HttpMethod.post,
            path: ['subscription-ticket'],
            authToken: testAuthToken,
          ),
          mockClient.connectWebSocket(
            Uri(
              scheme: 'wss',
              host: 'example.com',
              path: '/base/api/v1/ws/$testTicket/',
              queryParameters: {'x': '42', 'stoken': 'token-1', 'limit': '5'},
            ),
          ),
          mockWebSocketChannel.ready,
          mockWebSocketChannel.stream,
          mockWebSocketChannel.sink,
          mockWebSocketSink.close(1000),
        ]);
      });

      test('maps binary messages to result model', () async {
        final testMsgData1 = Uint8List.fromList([1]);
        final testMsg1 = ItemListResponse(data: [testItem1], isDone: false);
        final testMsgData2 = Uint8List.fromList([2]);
        final testMsg2 = ItemListResponse(
          data: [testItem2],
          isDone: false,
          stoken: 'token1',
        );
        final testMsgData3 = Uint8List.fromList([3]);
        const testMsg3 = ItemListResponse<EncryptedCollectionItem>(
          data: [],
          isDone: true,
          stoken: 'token2',
        );

        provideDummy(testMsg1);

        when(
          mockConverter.decode<ItemListResponse<EncryptedCollectionItem>>(
            testMsgData1,
          ),
        ).thenReturn(testMsg1);
        when(
          mockConverter.decode<ItemListResponse<EncryptedCollectionItem>>(
            testMsgData2,
          ),
        ).thenReturn(testMsg2);
        when(
          mockConverter.decode<ItemListResponse<EncryptedCollectionItem>>(
            testMsgData3,
          ),
        ).thenReturn(testMsg3);

        when(mockWebSocketChannel.stream).thenStream(
          Stream<dynamic>.fromIterable([
            testMsgData1,
            testMsgData2,
            testMsgData3,
          ]),
        );

        final result = sut.subscribeChanges(null);

        await expectLater(
          result,
          emitsInOrder([testMsg1, testMsg2, testMsg3, emitsDone]),
        );

        verifyInOrder([
          mockConverter.decode<ItemListResponse<EncryptedCollectionItem>>(
            testMsgData1,
          ),
          mockConverter.decode<ItemListResponse<EncryptedCollectionItem>>(
            testMsgData2,
          ),
          mockConverter.decode<ItemListResponse<EncryptedCollectionItem>>(
            testMsgData3,
          ),
          mockWebSocketSink.close(1000),
        ]);
      });

      test(
        'closes sink if websocket connection throws and wraps error',
        () async {
          final testException = Exception('test');
          when(mockWebSocketChannel.ready).thenThrow(testException);

          await expectLater(
            sut.subscribeChanges(null),
            emitsError(
              isA<ConnectionProblem>().having(
                (m) => m.innerException,
                'innerException',
                testException,
              ),
            ),
          );

          verify(mockWebSocketSink.close(1000));
        },
      );
    });
  });
}
