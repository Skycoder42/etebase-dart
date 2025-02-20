import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/models/login_response.dart';
import 'package:etebase/src/impl/models/signup_request.dart';
import 'package:etebase/src/impl/models/user.dart';
import 'package:etebase/src/impl/online_managers/authenticator.dart';
import 'package:etebase/src/impl/online_managers/base_network.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// ignore: directives_ordering
import '../../test_helpers.dart';
@GenerateNiceMocks([
  MockSpec<NetworkClient>(),
  MockSpec<MessagePackConverter>(),
  MockSpec<Client>(),
  MockSpec<StreamedResponse>(),
])
import 'authenticator_test.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy(const ByteStream(Stream.empty()));
  });

  group('$Authenticator', () {
    final testBaseUri = Uri.http('example.com', '/base');

    final mockNetworkClient = MockNetworkClient();
    final mockConverter = MockMessagePackConverter();
    final mockClient = MockClient();

    late Authenticator sut;

    setUp(() async {
      reset(mockNetworkClient);
      reset(mockConverter);
      reset(mockClient);

      when(mockNetworkClient.converter).thenReturn(mockConverter);
      when(mockNetworkClient.httpClient).thenReturn(mockClient);
      when(mockNetworkClient.baseUri).thenReturn(testBaseUri);

      sut = Authenticator(client: mockNetworkClient);
    });

    void setupResponse<T>(T response, [int status = 200]) {
      provideDummy(response);
      final testData =
          (ByteData(8)..setUint64(0, response.hashCode)).buffer.asUint8List();
      when(
        // ignore: discarded_futures
        mockClient.send(any),
      ).thenReturnAsync(
        StreamedResponse(
          Stream.value(testData),
          status,
          headers: {'content-type': 'application/msgpack'},
        ),
      );

      when(mockConverter.decode<T>(testData)).thenReturn(response);
    }

    Uint8List setupRequest<T>(T request) {
      final testData =
          (ByteData(8)..setUint64(0, request.hashCode)).buffer.asUint8List();
      when(mockConverter.encode(request)).thenReturn(testData);
      return testData;
    }

    Request verifySend() =>
        // ignore: discarded_futures
        verify(mockClient.send(captureAny)).captured.single as Request;

    group('isEtebase', () {
      test('returns true if server does not respond with an error', () async {
        setupResponse(null);

        final result = await sut.isEtebase();

        expect(result, isTrue);

        final request = verifySend();
        expect(
          request.url,
          Uri.http('example.com', '/base/api/v1/authentication/is_etebase/'),
        );
      });

      test('returns false if server returns not found', () async {
        setupResponse(null, 404);

        final result = await sut.isEtebase();

        expect(result, isFalse);
      });

      test('signup sends request to backend', () async {
        final testRequest = SignupRequest(
          user: const EtebaseUser(
            username: 'test-username',
            email: 'test-email',
          ),
          salt: Uint8List(1),
          loginPubkey: Uint8List(2),
          pubkey: Uint8List(3),
          encryptedContent: Uint8List(4),
        );
        final requestToken = setupRequest(testRequest);

        final testResponse = LoginResponse(
          token: 'test-token',
          user: User(
            username: 'test-username',
            email: 'test-email',
            pubkey: Uint8List(1),
            encryptedContent: Uint8List(2),
          ),
        );
        setupResponse(testResponse);

        final response = await sut.signup(testRequest);

        expect(response, testResponse);

        final request = verifySend();
        expect(request.method, 'POST');
        expect(
          request.url,
          Uri.http('example.com', '/base/api/v1/authentication/signup/'),
        );
        expect(request.bodyBytes, requestToken);
      });
    });
  });
}
