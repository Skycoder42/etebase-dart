import 'dart:typed_data';

// ignore: no_self_package_imports
import 'package:etebase/gen/package_metadata.dart' as pubspec;
import 'package:etebase/src/api/exceptions/api_missuse.dart';
import 'package:etebase/src/api/managers/crypto_executor.dart';
import 'package:etebase/src/api/models/item_metadata.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/managers/client_impl.dart';
import 'package:etebase/src/impl/online_managers/authenticator.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../crypto/crypto_mocks.dart' show FakeSecureKey;

// ignore: directives_ordering
import '../../test_helpers.dart';
@GenerateNiceMocks([
  MockSpec<http.Client>(as: #MockHttpClient),
  MockSpec<MessagePackConverter>(),
  MockSpec<CryptoService>(),
  MockSpec<CryptoExecutor>(),
])
import 'client_impl_test.mocks.dart';

class FakeMeta extends Fake implements ItemMetadata {}

void main() {
  group('$ClientImpl', () {
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
          () => ClientImpl(
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
          final sut = ClientImpl.create(mockCryptoExecutor, testName);

          expect(sut.httpClient, isA<http.Client>());
          expect(
            sut.userAgent,
            startsWith(
              '$testName (package:${pubspec.package}/${pubspec.version}',
            ),
          );
          expect(sut.converter, isA<MessagePackConverter>());
          expect(sut.baseUrl, ClientImpl.defaultUrl);
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

          final sut = ClientImpl.create(
            mockCryptoExecutor,
            testName,
            testOtherUrl,
          );

          expect(sut.baseUrl, testOtherUrl);
        });

        test('owns created client and disposes it', () async {
          final sut = ClientImpl.create(mockCryptoExecutor, testName);

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
      late ClientImpl sut;

      setUp(() {
        sut = ClientImpl(
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
          sut = ClientImpl(
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

      test('randombytes returns crypto randomBytes', () {
        const testSize = 12;
        final testBytes = Uint8List.fromList([43, 44, 1]);
        when(mockCryptoService.randomBytes(any)).thenReturn(testBytes);

        final result = sut.randombytes(testSize);

        expect(result, testBytes);

        verify(mockCryptoService.randomBytes(testSize)).called(1);
      });

      test('randomKey returns crypto secureRandom', () {
        const testSize = 12;
        final testKey = FakeSecureKey(22);
        when(mockCryptoService.secureRandom(any)).thenReturn(testKey);

        final result = sut.randomKey(testSize);

        expect(result, testKey);

        verify(mockCryptoService.secureRandom(testSize)).called(1);
      });

      test('prettyFingerprint returns crypto prettyFingerprint', () {
        final testBytes = Uint8List.fromList([43, 44, 1]);
        const testFingerprint = 'test-fingerprint';
        when(
          mockCryptoService.prettyFingerprint(any),
        ).thenReturn(testFingerprint);

        final result = sut.prettyFingerprint(testBytes);

        expect(result, testFingerprint);

        verify(mockCryptoService.prettyFingerprint(testBytes)).called(1);
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
