// ignore_for_file: discarded_futures

import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/exceptions/conflict.dart';
import 'package:etebase/src/api/exceptions/connection_problem.dart';
import 'package:etebase/src/api/exceptions/http_error_content.dart';
import 'package:etebase/src/api/exceptions/http_failure.dart';
import 'package:etebase/src/api/exceptions/http_field_error.dart';
import 'package:etebase/src/api/exceptions/invalid_message_pack_data.dart';
import 'package:etebase/src/api/exceptions/not_found.dart';
import 'package:etebase/src/api/exceptions/permission_denied.dart';
import 'package:etebase/src/api/exceptions/server_problem.dart';
import 'package:etebase/src/api/exceptions/temporary_server_problem.dart';
import 'package:etebase/src/api/exceptions/unauthorized.dart';
import 'package:etebase/src/api/models/etebase_user.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/models/auth_token.dart';
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
import 'base_network_test.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy(const ByteStream(Stream.empty()));
    provideDummy(const HttpErrorContent());
    provideDummy(const EtebaseUser(username: '', email: ''));
  });

  group('$BaseNetwork', () {
    final testBaseUri = Uri.http('example.com', '/base', {'v': '1', 'x': 'a'});
    const testUserAgent = 'test/user-agent';
    const testPath = ['test', 'path'];

    final mockNetworkClient = MockNetworkClient();
    final mockConverter = MockMessagePackConverter();
    final mockClient = MockClient();

    late BaseNetwork sut;

    setUp(() {
      reset(mockNetworkClient);
      reset(mockConverter);
      reset(mockClient);

      when(mockNetworkClient.converter).thenReturn(mockConverter);
      when(mockNetworkClient.httpClient).thenReturn(mockClient);
      when(mockNetworkClient.baseUrl).thenReturn(testBaseUri);
      when(mockNetworkClient.userAgent).thenReturn(testUserAgent);

      sut = BaseNetwork(client: mockNetworkClient, path: testPath);
    });

    test('apiUrl returns constructed url', () {
      expect(
        sut.apiUrl,
        Uri.parse('http://example.com/base/test/path?v=1&x=a'),
      );
    });

    test('asserts if baseUrl ends with /', () {
      when(
        mockNetworkClient.baseUrl,
      ).thenReturn(Uri.https('test.com', '/base/'));

      expect(
        () => BaseNetwork(client: mockNetworkClient),
        throwsA(isA<AssertionError>()),
      );
    });

    group('invoke', () {
      group('(requests)', () {
        setUp(() {
          when(
            mockClient.send(any),
          ).thenReturnAsync(StreamedResponse(const Stream.empty(), 200));
        });

        test('sends basic request', () async {
          await sut.invoke<void>();

          final [Request request] =
              verify(mockClient.send(captureAny)).captured;

          expect(request.method, 'GET');
          expect(
            request.url,
            Uri.parse('http://example.com/base/test/path/?v=1&x=a'),
          );
          expect(request.headers, hasLength(2));
          expect(request.headers, containsPair('user-agent', testUserAgent));
          expect(
            request.headers,
            containsPair('accept', 'application/msgpack'),
          );
          expect(request.bodyBytes, isEmpty);
          expect(request.contentLength, 0);
          expect(request.followRedirects, isTrue);
        });

        test('builds customized request', () async {
          const testToken = AuthToken('test-token');

          await sut.invoke<void>(
            method: HttpMethod.patch,
            path: const ['custom', 'request'],
            query: {'b': 'aum', 'x': '42'},
            headers: {'X-Header': 'X-Value', 'AcCePt': 'Something'},
            authToken: testToken,
          );

          final [Request request] =
              verify(mockClient.send(captureAny)).captured;

          expect(request.method, 'PATCH');
          expect(
            request.url,
            Uri(
              scheme: 'http',
              host: 'example.com',
              path: '/base/test/path/custom/request/',
              query: 'v=1&x=42&b=aum',
            ),
          );
          expect(request.headers, hasLength(4));
          expect(request.headers, containsPair('user-agent', testUserAgent));
          expect(request.headers, containsPair('X-Header', 'X-Value'));
          expect(request.headers, containsPair('accept', 'Something'));
          expect(
            request.headers,
            isNot(containsPair('accept', 'application/msgpack')),
          );
          expect(
            request.headers,
            containsPair('authorization', testToken.header),
          );
          expect(request.bodyBytes, isEmpty);
          expect(request.contentLength, 0);
          expect(request.followRedirects, isTrue);
        });

        test('sets string as request body', () async {
          const testBody = 'test-body';

          await sut.invoke<void>(body: testBody);

          final [Request request] =
              verify(mockClient.send(captureAny)).captured;

          expect(request.body, testBody);
          expect(request.bodyBytes, utf8.encode(testBody));
          expect(request.encoding, same(utf8));
          expect(request.contentLength, testBody.length);
          expect(
            request.headers,
            containsPair('content-type', 'text/plain; charset=utf-8'),
          );
        });

        test('sets form fields as request body', () async {
          const testBody = {'field-1': 'value1', 'field-2': 'value2'};
          const testStrBody = 'field-1=value1&field-2=value2';

          await sut.invoke<void>(body: testBody);

          final [Request request] =
              verify(mockClient.send(captureAny)).captured;

          expect(request.bodyFields, testBody);
          expect(request.body, testStrBody);
          expect(request.bodyBytes, utf8.encode(testStrBody));
          expect(request.encoding, same(utf8));
          expect(request.contentLength, testStrBody.length);
          expect(
            request.headers,
            containsPair(
              'content-type',
              'application/x-www-form-urlencoded; charset=utf-8',
            ),
          );
        });

        test('sets binary data as request body', () async {
          final testBody = Uint8List.fromList([4, 1, 12, 41, 2]);

          await sut.invoke<void>(body: testBody);

          final [Request request] =
              verify(mockClient.send(captureAny)).captured;

          expect(request.bodyBytes, testBody);
          expect(request.contentLength, testBody.length);
          expect(
            request.headers,
            containsPair('content-type', 'application/octet-stream'),
          );
        });

        test('encodes other data as msgPack for request body', () async {
          const testBody = EtebaseUser(
            username: 'test-user',
            email: 'test-mail',
          );
          final testBodyBytes = Uint8List.fromList([5, 6, 22, 13]);

          when(mockConverter.encode(any)).thenReturn(testBodyBytes);

          await sut.invoke<void>(body: testBody);

          final [Request request] =
              verify(mockClient.send(captureAny)).captured;

          expect(request.bodyBytes, testBodyBytes);
          expect(request.contentLength, testBodyBytes.length);
          expect(
            request.headers,
            containsPair('content-type', 'application/msgpack'),
          );

          verify(mockConverter.encode(testBody));
          verifyNoMoreInteractions(mockConverter);
        });
      });

      group('(responses)', () {
        testData(
          'is successful for 2XX status codes',
          [200, 201, 202, 204, 299],
          (fixture) {
            when(
              mockClient.send(any),
            ).thenReturnAsync(StreamedResponse(const Stream.empty(), fixture));

            expect(sut.invoke<void>(), completes);
          },
        );

        testData(
          'returns plain body with correct encoding',
          [
            (latin1, 'text/plain'), // default because of historical reasons
            (utf8, 'text/plain; charset=utf-8'),
            (latin1, 'text/plain; charset=iso-8859-1'),
          ],
          (fixture) async {
            const testBody = 'teßt-bödy';
            when(mockClient.send(any)).thenReturnAsync(
              StreamedResponse(
                Stream.value(fixture.$1.encode(testBody)),
                200,
                headers: {'content-type': fixture.$2},
              ),
            );

            final result = await sut.invoke<String>();

            expect(result, testBody);
          },
        );

        test('returns binary body as is', () async {
          final testBody = Uint8List.fromList([4, 5, 11, 4, 23]);
          when(mockClient.send(any)).thenReturnAsync(
            StreamedResponse(
              Stream.value(testBody),
              200,
              headers: {'content-type': 'application/octet-stream'},
            ),
          );

          final result = await sut.invoke<Uint8List>();

          expect(result, testBody);
        });

        test('decodes msgPack data', () async {
          const testBody = EtebaseUser(
            username: 'test-user',
            email: 'test-mail',
          );
          final testBodyBytes = Uint8List.fromList([5, 6, 12, 13]);

          when(mockClient.send(any)).thenReturnAsync(
            StreamedResponse(
              Stream.value(testBodyBytes),
              200,
              headers: {'content-type': 'application/msgpack'},
            ),
          );

          when(mockConverter.decode<EtebaseUser>(any)).thenReturn(testBody);

          final result = await sut.invoke<EtebaseUser>();

          expect(result, testBody);

          verifyInOrder([
            mockClient.send(any),
            mockConverter.decode<EtebaseUser>(testBodyBytes),
          ]);
        });

        testData(
          'throws for other, unsupported content types',
          [null, 'application/json', 'text/xml'],
          (fixture) {
            when(mockClient.send(any)).thenReturnAsync(
              StreamedResponse(
                const Stream.empty(),
                200,
                headers: {if (fixture != null) 'content-type': fixture},
              ),
            );

            expect(
              () => sut.invoke<Uint8List>(),
              throwsA(
                isA<InvalidMessagePackData>().having(
                  (m) => m.message,
                  'message',
                  contains(fixture.toString()),
                ),
              ),
            );
          },
        );

        testData(
          'treats all non 2XX status codes as error',
          [
            100,
            101,
            199,
            300,
            301,
            399,
            400,
            401,
            403,
            404,
            499,
            500,
            501,
            502,
            599,
            600,
          ],
          (fixture) {
            when(
              mockClient.send(any),
            ).thenReturnAsync(StreamedResponse(const Stream.empty(), fixture));

            expect(() => sut.invoke<void>(), throwsA(isA<HttpFailure>()));
          },
        );

        testData(
          'uses body as message if body is any kind of text',
          ['text/plain', 'text/xml', 'text/custom'],
          (fixture) {
            const testMessage = 'test-error-message';
            when(mockClient.send(any)).thenReturnAsync(
              StreamedResponse(
                Stream.value(utf8.encode(testMessage)),
                400,
                headers: {'content-type': fixture},
              ),
            );

            expect(
              () => sut.invoke<void>(),
              throwsA(
                isA<HttpFailure>()
                    .having((m) => m.status, 'status', 400)
                    .having((m) => m.message, 'message', testMessage)
                    .having((m) => m.error, 'error', isNull),
              ),
            );
          },
        );

        test('returns decoded error object if body is msgPack', () async {
          const testError = HttpErrorContent(
            code: 'test-code-1',
            detail: 'test-detail-1',
            errors: [
              HttpFieldError(
                code: 'test-code-2',
                detail: 'test-detail-2',
                field: 'test-field',
              ),
            ],
          );
          final testMessageData = Uint8List.fromList([4, 12, 33, 51]);

          when(mockClient.send(any)).thenReturnAsync(
            StreamedResponse(
              Stream.value(testMessageData),
              400,
              headers: {'content-type': 'application/msgpack'},
            ),
          );
          when(
            mockConverter.decode<HttpErrorContent>(any),
          ).thenReturn(testError);

          await expectLater(
            () => sut.invoke<void>(),
            throwsA(
              isA<HttpFailure>()
                  .having((m) => m.status, 'status', 400)
                  .having(
                    (m) => m.message,
                    'message',
                    testError.toString(withErrors: false),
                  )
                  .having((m) => m.error, 'error', same(testError)),
            ),
          );

          verifyInOrder([
            mockClient.send(any),
            mockConverter.decode<HttpErrorContent>(testMessageData),
          ]);
        });

        test(
          'ignores exception and returns fallback message if decoding fails',
          () async {
            final testMessageData = Uint8List.fromList([4, 12, 33, 51]);

            when(mockClient.send(any)).thenReturnAsync(
              StreamedResponse(
                Stream.value(testMessageData),
                400,
                headers: {'content-type': 'application/msgpack'},
              ),
            );
            when(
              mockConverter.decode<HttpErrorContent>(any),
            ).thenThrow(Exception('test'));

            await expectLater(
              () => sut.invoke<void>(),
              throwsA(
                isA<HttpFailure>()
                    .having((m) => m.status, 'status', 400)
                    .having((m) => m.message, 'message', 'HTTP Error 400')
                    .having((m) => m.error, 'error', isNull),
              ),
            );

            verifyInOrder([
              mockClient.send(any),
              mockConverter.decode<HttpErrorContent>(testMessageData),
            ]);
          },
        );

        testData(
          'uses fallback message if response has no usable data',
          [
            (Uint8List(0), null),
            (Uint8List(0), 'text/plain'),
            (Uint8List(0), 'application/msgpack'),
            (utf8.encode('message'), null),
            (utf8.encode('message'), 'application/json'),
          ],
          (fixture) {
            when(mockClient.send(any)).thenReturnAsync(
              StreamedResponse(
                Stream.value(fixture.$1),
                412,
                headers: {
                  if (fixture.$2 case final String v) 'content-type': v,
                },
              ),
            );

            expect(
              () => sut.invoke<void>(),
              throwsA(
                isA<HttpFailure>()
                    .having((m) => m.status, 'status', 412)
                    .having((m) => m.message, 'message', 'HTTP Error 412')
                    .having((m) => m.error, 'error', isNull),
              ),
            );
          },
        );

        testData(
          'throws errors of correct type based on status code',
          [
            (400, isA<HttpFailure>(), HttpFailure),
            (401, isA<Unauthorized>(), Unauthorized),
            (402, isA<HttpFailure>(), HttpFailure),
            (403, isA<PermissionDenied>(), PermissionDenied),
            (404, isA<NotFound>(), NotFound),
            (405, isA<HttpFailure>(), HttpFailure),
            (408, isA<HttpFailure>(), HttpFailure),
            (409, isA<Conflict>(), Conflict),
            (410, isA<HttpFailure>(), HttpFailure),
            (499, isA<HttpFailure>(), HttpFailure),
            (500, isA<ServerProblem>(), ServerProblem),
            (501, isA<ServerProblem>(), ServerProblem),
            (502, isA<TemporaryServerProblem>(), TemporaryServerProblem),
            (503, isA<TemporaryServerProblem>(), TemporaryServerProblem),
            (504, isA<TemporaryServerProblem>(), TemporaryServerProblem),
            (505, isA<ServerProblem>(), ServerProblem),
            (513, isA<ServerProblem>(), ServerProblem),
            (599, isA<ServerProblem>(), ServerProblem),
          ],
          (fixture) {
            when(mockClient.send(any)).thenReturnAsync(
              StreamedResponse(const Stream.empty(), fixture.$1),
            );

            expect(
              () => sut.invoke<void>(),
              throwsA(
                allOf(
                  isA<HttpFailure>(),
                  fixture.$2,
                  predicate<Object>(
                    (o) => o.runtimeType == fixture.$3,
                    'Is exactly of type ${fixture.$3}',
                  ),
                ),
              ),
            );
          },
        );

        test('throws ConnectionProblem if sending the request fails', () {
          final testException = ClientException('test-error');
          when(mockClient.send(any)).thenThrow(testException);

          expect(
            () => sut.invoke<void>(),
            throwsA(
              isA<ConnectionProblem>().having(
                (m) => m.innerException,
                'innerException',
                testException,
              ),
            ),
          );
        });
      });
    });
  });
}
