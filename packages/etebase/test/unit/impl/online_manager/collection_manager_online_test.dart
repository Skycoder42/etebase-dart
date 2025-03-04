// ignore_for_file: discarded_futures

import 'dart:typed_data';

import 'package:etebase/src/api/models/etebase_fetch_options.dart';
import 'package:etebase/src/api/models/etebase_list_response.dart';
import 'package:etebase/src/api/models/etebase_removed_collection.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection.dart';
import 'package:etebase/src/impl/models/auth_token.dart';
import 'package:etebase/src/impl/models/collection_list_request.dart';
import 'package:etebase/src/impl/online_managers/base_network.dart';
import 'package:etebase/src/impl/online_managers/collection_manager_online.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'online_manager_mocks.dart';

void main() {
  group('$CollectionManagerOnline', () {
    const testAuthToken = AuthToken('test');
    const testOptions = EtebaseFetchOptions(limit: 1);
    const testQuery = {'limit': '1'};

    const testCollectionUid = 'test-collectionUid';
    final testCollectionType = Uint8List.fromList([4, 2, 3]);
    final testCollection = EncryptedCollection();

    final mockBaseNetwork = MockBaseNetwork();
    final mockAuthTokenSource = MockAuthTokenSource();

    late CollectionManagerOnline sut;

    setUpAll(() {
      provideDummy(testAuthToken);
    });

    setUp(() {
      reset(mockBaseNetwork);
      reset(mockAuthTokenSource);

      when(mockAuthTokenSource.authToken).thenReturn(testAuthToken);

      sut = CollectionManagerOnline.fromNetwork(
        mockBaseNetwork,
        mockAuthTokenSource,
      );
    });

    test('constructs base network from client and base path', () {
      final testBaseUri = Uri.http('example.com', '/base');

      final mockNetworkClient = MockNetworkClient();
      when(mockNetworkClient.baseUrl).thenReturn(testBaseUri);

      final sut = CollectionManagerOnline(
        client: mockNetworkClient,
        authTokenSource: mockAuthTokenSource,
      );

      expect(sut.apiUrl, Uri.http('example.com', '/base/api/v1/collection'));
      expect(sut.client, same(mockNetworkClient));
    });

    test('itemManager creates item manager instance', () {
      final testBaseUri = Uri.http('example.com', '/base');
      const testColUid = 'test-colUid';

      final mockNetworkClient = MockNetworkClient();
      when(mockNetworkClient.baseUrl).thenReturn(testBaseUri);
      when(mockBaseNetwork.client).thenReturn(mockNetworkClient);

      final result = sut.itemManager(testColUid);

      expect(
        result.apiUrl,
        Uri.http('example.com', '/base/api/v1/collection/$testColUid/item'),
      );
      expect(result.client, same(mockNetworkClient));
    });

    testInvoke(
      'fetch gets collection id endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: testCollection,
      call: (_) => sut.fetch(testCollectionUid, testOptions),
      path: [testCollectionUid],
      query: testQuery,
      authToken: testAuthToken,
    );

    testInvoke(
      'list posts list multi endpoint',
      mock: mockBaseNetwork,
      request: CollectionListRequest([testCollectionType]),
      response: EtebaseCollectionListResponse(
        data: [testCollection],
        isDone: false,
        stoken: 'token',
        removedMemberships: [const EtebaseRemovedCollection('rm-1')],
      ),
      call: (_) => sut.list([testCollectionType], testOptions),
      method: HttpMethod.post,
      path: ['list_multi'],
      query: testQuery,
      authToken: testAuthToken,
    );

    testInvoke<EncryptedCollection, void>(
      'create posts endpoint',
      mock: mockBaseNetwork,
      request: testCollection,
      response: null,
      call: (r) => sut.create(r, testOptions),
      method: HttpMethod.post,
      query: testQuery,
      authToken: testAuthToken,
    );
  });
}
