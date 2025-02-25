// ignore_for_file: discarded_futures

import 'dart:typed_data';

import 'package:etebase/src/api/models/etebase_collection_access_level.dart';
import 'package:etebase/src/api/models/etebase_fetch_options.dart';
import 'package:etebase/src/api/models/etebase_list_response.dart';
import 'package:etebase/src/api/models/etebase_user_profile.dart';
import 'package:etebase/src/impl/models/auth_token.dart';
import 'package:etebase/src/impl/models/invitation_accept_request.dart';
import 'package:etebase/src/impl/models/signed_invitation.dart';
import 'package:etebase/src/impl/online_managers/base_network.dart';
import 'package:etebase/src/impl/online_managers/collection_invitation_manager_online.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'online_manager_mocks.dart';

void main() {
  group('$CollectionInvitationManagerOnline', () {
    const testAuthToken = AuthToken('test');
    const testOptions = EtebaseIteratorFetchOptions(limit: 1);
    const testQuery = {'limit': '1'};

    const testUserName = 'test-user-name';
    const testInvitationUid = 'test-uid';
    final testInvitation = SignedInvitationRead(
      uid: testInvitationUid,
      version: 23,
      username: 'test-username',
      collection: 'test-collection',
      accessLevel: EtebaseCollectionAccessLevel.readWrite,
      signedEncryptionKey: Uint8List(0),
      fromPubKey: Uint8List(1),
    );

    final mockBaseNetwork = MockBaseNetwork();
    final mockAuthTokenSource = MockAuthTokenSource();

    late CollectionInvitationManagerOnline sut;

    setUp(() {
      reset(mockBaseNetwork);
      reset(mockAuthTokenSource);

      when(mockAuthTokenSource.authToken).thenReturn(testAuthToken);

      sut = CollectionInvitationManagerOnline.fromNetwork(
        mockBaseNetwork,
        mockAuthTokenSource,
      );
    });

    test('constructs base network from client and base path', () {
      final testBaseUri = Uri.http('example.com', '/base');

      final mockNetworkClient = MockNetworkClient();
      when(mockNetworkClient.baseUrl).thenReturn(testBaseUri);

      final sut = CollectionInvitationManagerOnline(
        client: mockNetworkClient,
        authTokenSource: mockAuthTokenSource,
      );

      expect(sut.apiUrl, Uri.http('example.com', '/base/api/v1/invitation'));
      expect(sut.client, same(mockNetworkClient));
    });

    testInvoke(
      'listIncoming gets incoming endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: EtebaseIteratorListResponse(
        data: [testInvitation],
        isDone: true,
        iterator: 'iterator',
      ),
      call: (_) => sut.listIncoming(testOptions),
      authToken: testAuthToken,
      path: ['incoming'],
      query: testQuery,
    );

    testInvoke(
      'listOutgoing gets outgoing endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: EtebaseIteratorListResponse(
        data: [testInvitation],
        isDone: false,
        iterator: 'iterator-X',
      ),
      call: (_) => sut.listOutgoing(testOptions),
      authToken: testAuthToken,
      path: ['outgoing'],
      query: testQuery,
    );

    testInvoke<InvitationAcceptRequest, void>(
      'accept posts incoming accept endpoint',
      mock: mockBaseNetwork,
      request: InvitationAcceptRequest(
        collectionType: Uint8List(2),
        encryptionKey: Uint8List(3),
      ),
      response: null,
      call: (r) => sut.accept(testInvitation, r),
      method: HttpMethod.post,
      path: ['incoming', testInvitationUid, 'accept'],
      authToken: testAuthToken,
    );

    testInvoke<void, void>(
      'reject deletes incoming endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: null,
      call: (_) => sut.reject(testInvitation),
      method: HttpMethod.delete,
      path: ['incoming', testInvitationUid],
      authToken: testAuthToken,
    );

    testInvoke(
      'fetchUserProfile gets outgoing profile endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: EtebaseUserProfile(pubkey: Uint8List(4)),
      call: (_) => sut.fetchUserProfile(testUserName),
      path: ['outgoing', 'fetch_user_profile'],
      query: {'username': testUserName},
      authToken: testAuthToken,
    );

    testInvoke<SignedInvitationWrite, void>(
      'invite posts outgoing endpoint',
      mock: mockBaseNetwork,
      request: SignedInvitationWrite(
        uid: testInvitationUid,
        version: 33,
        username: 'testUsername',
        collection: 'testCollection',
        accessLevel: EtebaseCollectionAccessLevel.readOnly,
        signedEncryptionKey: Uint8List(5),
      ),
      response: null,
      call: (r) => sut.invite(r),
      method: HttpMethod.post,
      path: ['outgoing'],
      authToken: testAuthToken,
    );

    testInvoke<void, void>(
      'disinvite deletes outgoing endpoint',
      mock: mockBaseNetwork,
      request: null,
      response: null,
      call: (_) => sut.disinvite(testInvitation),
      method: HttpMethod.delete,
      path: ['outgoing', testInvitationUid],
      authToken: testAuthToken,
    );
  });
}
