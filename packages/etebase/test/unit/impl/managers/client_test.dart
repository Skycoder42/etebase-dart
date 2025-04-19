import 'package:etebase/gen/package_metadata.dart' as pubspec;
import 'package:etebase/src/api/exceptions/api_missuse.dart';
import 'package:etebase/src/api/managers/crypto_executor.dart';
import 'package:etebase/src/api/models/etebase_item_metadata.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/managers/client.dart';
import 'package:etebase/src/impl/online_managers/authenticator.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// ignore: directives_ordering
import '../../test_helpers.dart';
@GenerateNiceMocks([
  MockSpec<http.Client>(as: #MockHttpClient),
  MockSpec<MessagePackConverter>(),
  MockSpec<CryptoService>(),
  MockSpec<CryptoExecutor>(),
])
import 'client_test.mocks.dart';

class FakeMeta extends Fake implements EtebaseItemMetadata {}

void main() {
  group('$Client', () {
    const testUserAgent = 'test-user-agent';
    final testBaseUrl = Uri.https('example.com', '/etebase');

    final mockHttpClient = MockHttpClient();
    final mockMessagePackConverter = MockMessagePackConverter();
    final mockCryptoService = MockCryptoService();

    setUp(() {
      reset(mockHttpClient);
      reset(mockMessagePackConverter);
      reset(mockCryptoService);
    });

    group('constructors', () {
      test('default throws if URL ends with /', () {
        expect(
          () => Client(
            mockHttpClient,
            testUserAgent,
            Uri.https('example.com', '/api/'),
            mockMessagePackConverter,
            mockCryptoService,
          ),
          throwsA(isA<ApiMissuse>()),
        );
      });

      group('create', () {
        const testName = 'test-name';

        final mockCryptoExecutor = MockCryptoExecutor();

        setUp(() {
          reset(mockCryptoExecutor);
        });

        test('constructs client from executor', () {
          final sut = Client.create(mockCryptoExecutor, testName);

          expect(sut.httpClient, isA<http.Client>());
          expect(
            sut.userAgent,
            startsWith(
              '$testName (package:${pubspec.package}/${pubspec.version}',
            ),
          );
          expect(sut.converter, isA<MessagePackConverter>());
          expect(sut.baseUrl, Client.defaultUrl);
          expect(
            sut.crypto,
            isA<CryptoService>().having(
              (m) => m.executor,
              'executor',
              same(mockCryptoExecutor),
            ),
          );
        });

        test('uses custom server url if given', () {
          final testOtherUrl = Uri.http('other.com');

          final sut = Client.create(mockCryptoExecutor, testName, testOtherUrl);

          expect(sut.baseUrl, testOtherUrl);
        });

        test('owns created client and disposes it', () async {
          final sut = Client.create(mockCryptoExecutor, testName);

          await sut.dispose();

          await expectLater(
            () => sut.httpClient.get(testBaseUrl),
            throwsA(
              isA<http.ClientException>().having(
                (m) => m.message,
                'message',
                contains('closed'),
              ),
            ),
          );

          verify(mockCryptoExecutor.dispose()).called(1);
        });
      });
    });

    group('members', () {
      late Client sut;

      setUp(() {
        sut = Client(
          mockHttpClient,
          testUserAgent,
          testBaseUrl,
          mockMessagePackConverter,
          mockCryptoService,
        );
      });

      test('authenticator create authenticator from this', () {
        final result = sut.authenticator;

        expect(
          result,
          isA<Authenticator>().having(
            (m) => m.apiUrl,
            'apiUrl',
            Uri.parse('https://example.com/etebase/api/v1/authentication'),
          ),
        );
      });

      group('dispose', () {
        test('only disposes crypto service by default', () async {
          await sut.dispose();

          verify(mockCryptoService.dispose()).called(1);
          verifyNever(mockHttpClient.close());
        });

        test('also disposes http client when owned', () async {
          sut = Client(
            mockHttpClient,
            testUserAgent,
            testBaseUrl,
            mockMessagePackConverter,
            mockCryptoService,
            ownedClient: true,
          );

          await sut.dispose();

          verify(mockHttpClient.close()).called(1);
          verify(mockCryptoService.dispose()).called(1);
        });
      });

      test('checkEtebaseServer calls isEtebase on authenticator', () async {
        final testResponse = http.StreamedResponse(const Stream.empty(), 200);
        when(mockHttpClient.send(any)).thenReturnAsync(testResponse);

        final result = await sut.checkEtebaseServer();

        expect(result, isTrue);

        verify(
          mockHttpClient.send(
            argThat(
              isA<http.Request>()
                  .having((m) => m.method, 'method', 'GET')
                  .having(
                    (m) => m.url,
                    'url',
                    Uri.parse(
                      'https://example.com/etebase/api/v1/authentication/is_etebase/',
                    ),
                  ),
            ),
          ),
        );
      });

      test('registerCustomMetadata registers converter', () {
        FakeMeta testFromJson(Map<String, dynamic> _) =>
            throw UnimplementedError();

        sut.registerCustomMetadata<FakeMeta>(testFromJson);

        verify(mockMessagePackConverter.addCustom<FakeMeta>(testFromJson));
      });
    });
  });
}
