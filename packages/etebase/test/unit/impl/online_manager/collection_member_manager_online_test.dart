import 'package:etebase/src/api/models/collection_access_level.dart';
import 'package:etebase/src/api/models/collection_member.dart';
import 'package:etebase/src/api/models/fetch_options.dart';
import 'package:etebase/src/api/models/list_response.dart';
import 'package:etebase/src/impl/models/auth_token.dart';
import 'package:etebase/src/impl/models/modify_access_level_request.dart';
import 'package:etebase/src/impl/online_managers/base_network.dart';
import 'package:etebase/src/impl/online_managers/collection_member_manager_online.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'online_manager_mocks.dart';

void main() {
  group('$CollectionMemberManagerOnline', () {
    const testAuthToken = AuthToken('test');
    const testOptions = IteratorFetchOptions(limit: 1);
    const testQuery = {'limit': '1'};

    const testUsername = 'test-user';
    const testMember = CollectionMember(
      username: testUsername,
      accessLevel: CollectionAccessLevel.readWrite,
    );

    final mockBaseNetwork = MockBaseNetwork();
    final mockAuthTokenSource = MockAuthTokenSource();

    late CollectionMemberManagerOnline sut;

    setUpAll(() {
      provideDummy(testAuthToken);
    });

    setUp(() {
      reset(mockBaseNetwork);
      reset(mockAuthTokenSource);

      when(mockAuthTokenSource.authToken).thenReturn(testAuthToken);

      sut = CollectionMemberManagerOnline.fromNetwork(
        mockBaseNetwork,
        mockAuthTokenSource,
      );
    });

    test('constructs base network from client and base path', () {
      final testBaseUri = Uri.http('example.com', '/base');
      const testColUid = 'test-colUid';

      final mockNetworkClient = MockNetworkClient();
      when(mockNetworkClient.baseUrl).thenReturn(testBaseUri);

      final sut = CollectionMemberManagerOnline(
        client: mockNetworkClient,
        authTokenSource: mockAuthTokenSource,
        colUid: testColUid,
      );

      expect(
        sut.apiUrl,
        Uri.http('example.com', '/base/api/v1/collection/$testColUid/member'),
      );
      expect(sut.client, same(mockNetworkClient));
    });

    testInvoke(
      'list gets endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: const IteratorListResponse(
        data: [testMember],
        isDone: false,
        iterator: 'test-iter',
      ),
      call: (_) => sut.list(testOptions),
      query: testQuery,
      authToken: testAuthToken,
    );

    testInvoke<void, void>(
      'remove deletes user endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: null,
      call: (_) => sut.remove(testUsername),
      method: HttpMethod.delete,
      path: [testUsername],
      authToken: testAuthToken,
    );

    testInvoke<void, void>(
      'leave posts leave endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: null,
      call: (_) => sut.leave(),
      method: HttpMethod.post,
      path: ['leave'],
      authToken: testAuthToken,
    );

    testInvoke<ModifyAccessLevelRequest, void>(
      'modifyAccessLevel patches user endpoint',
      mock: mockBaseNetwork,
      request: const ModifyAccessLevelRequest(CollectionAccessLevel.readOnly),
      response: null,
      call: (_) =>
          sut.modifyAccessLevel(testUsername, CollectionAccessLevel.readOnly),
      method: HttpMethod.patch,
      path: [testUsername],
      authToken: testAuthToken,
    );
  });
}
