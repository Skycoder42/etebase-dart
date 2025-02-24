// ignore_for_file: discarded_futures

import 'dart:async';
import 'dart:typed_data';

import 'package:etebase/src/api/exceptions/not_found.dart';
import 'package:etebase/src/api/models/etebase_user.dart';
import 'package:etebase/src/impl/models/auth_token.dart';
import 'package:etebase/src/impl/models/challenge_request.dart';
import 'package:etebase/src/impl/models/dashboard_url.dart';
import 'package:etebase/src/impl/models/login_challenge.dart';
import 'package:etebase/src/impl/models/login_request.dart';
import 'package:etebase/src/impl/models/login_response.dart';
import 'package:etebase/src/impl/models/signup_request.dart';
import 'package:etebase/src/impl/models/user.dart';
import 'package:etebase/src/impl/online_managers/authenticator.dart';
import 'package:etebase/src/impl/online_managers/base_network.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// ignore: directives_ordering
import '../../test_helpers.dart';
@GenerateNiceMocks([MockSpec<BaseNetwork>(), MockSpec<NetworkClient>()])
import 'authenticator_test.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy(const ByteStream(Stream.empty()));
  });

  group('$Authenticator', () {
    final testBaseUri = Uri.http('example.com', '/base');

    final mockNetwork = MockBaseNetwork();

    late Authenticator sut;

    setUp(() {
      reset(mockNetwork);

      sut = Authenticator.fromNetwork(mockNetwork);
    });

    PostExpectation<Future<T>> whenInvoke<T>() => when(
      mockNetwork.invoke<T>(
        method: anyNamed('method'),
        path: anyNamed('path'),
        headers: anyNamed('headers'),
        query: anyNamed('query'),
        body: anyNamed('body'),
        authToken: anyNamed('authToken'),
      ),
    );

    @isTest
    void testInvoke<TReq, TRes>(
      String description, {
      required TReq request,
      required TRes response,
      required Future<TRes> Function(TReq r) call,
      HttpMethod method = HttpMethod.get,
      List<String> path = const [],
      Map<String, String> headers = const {},
      Map<String, String> query = const {},
      AuthToken? authToken,
    }) => test(description, () async {
      whenInvoke<TRes>().thenReturnAsync(response);

      final result = await call(request);

      expect(result, response);

      verify(
        mockNetwork.invoke<TRes>(
          method: method,
          path: path,
          headers: headers,
          query: query,
          body: request,
          authToken: authToken,
        ),
      );
    });

    test('constructs base network from client and base path', () {
      final mockNetworkClient = MockNetworkClient();
      when(mockNetworkClient.baseUrl).thenReturn(testBaseUri);

      final sut = Authenticator(mockNetworkClient);

      expect(
        sut.apiUrl,
        Uri.http('example.com', '/base/api/v1/authentication'),
      );
    });

    group('isEtebase', () {
      test('returns true if server does not respond with an error', () async {
        final result = await sut.isEtebase();

        expect(result, isTrue);

        verify(mockNetwork.invoke<void>(path: ['is_etebase']));
      });

      test('returns false if server returns not found', () async {
        whenInvoke<void>().thenThrow(NotFound('test'));

        final result = await sut.isEtebase();

        expect(result, isFalse);
      });
    });

    testInvoke(
      'signup sends request to backend',
      request: SignupRequest(
        user: const EtebaseUser(username: 'test-username', email: 'test-email'),
        salt: Uint8List(1),
        loginPubkey: Uint8List(2),
        pubkey: Uint8List(3),
        encryptedContent: Uint8List(4),
      ),
      response: LoginResponse(
        token: 'test-token',
        user: User(
          username: 'test-username',
          email: 'test-email',
          pubkey: Uint8List(1),
          encryptedContent: Uint8List(2),
        ),
      ),
      call: (r) => sut.signup(r),
      method: HttpMethod.post,
      path: ['signup'],
    );

    testInvoke(
      'loginChallenge sends request to backend',
      request: const ChallengeRequest(username: 'username'),
      response: LoginChallenge(
        challenge: Uint8List(1),
        salt: Uint8List(2),
        version: 1,
      ),
      call: (r) => sut.loginChallenge(r),
      method: HttpMethod.post,
      path: ['login_challenge'],
    );

    testInvoke(
      'login sends request to backend',
      request: LoginRequest(response: Uint8List(1), signature: Uint8List(2)),
      response: LoginResponse(
        token: 'test-token',
        user: User(
          username: 'test-username',
          email: 'test-email',
          pubkey: Uint8List(1),
          encryptedContent: Uint8List(2),
        ),
      ),
      call: (r) => sut.login(r),
      method: HttpMethod.post,
      path: ['login'],
    );

    testInvoke<void, void>(
      'logout sends request to backend with auth token',
      request: null,
      response: null,
      call: (r) => sut.logout(const AuthToken('test')),
      method: HttpMethod.post,
      path: ['logout'],
      authToken: const AuthToken('test'),
    );

    testInvoke<LoginRequest, void>(
      'changePassword sends request to backend with auth token',
      request: LoginRequest(response: Uint8List(1), signature: Uint8List(2)),
      response: null,
      call: (r) => sut.changePassword(const AuthToken('test'), r),
      method: HttpMethod.post,
      path: ['change_password'],
      authToken: const AuthToken('test'),
    );
    test('getDashboardUrl sends request to backend with auth token', () async {
      final response = DashboardUrl(Uri.parse('http://example.com/dash'));
      whenInvoke<DashboardUrl>().thenReturnAsync(response);

      final result = await sut.getDashboardUrl(const AuthToken('test'));

      expect(result, response.url);

      verify(
        mockNetwork.invoke<DashboardUrl>(
          method: HttpMethod.post,
          path: ['dashboard_url'],
          authToken: const AuthToken('test'),
        ),
      );
    });
  });
}
