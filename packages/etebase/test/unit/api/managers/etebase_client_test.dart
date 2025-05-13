import 'package:etebase/src/api/managers/etebase_client.dart';
import 'package:etebase/src/impl/crypto/executors/async_crypto_executor.dart';
import 'package:etebase/src/impl/crypto/executors/sync_crypto_executor.dart';
import 'package:etebase/src/impl/managers/client.dart';
import 'package:test/test.dart';

import '../../impl/crypto/crypto_mocks.dart';

void main() {
  group('$EtebaseClient', () {
    const testClientName = 'test-client-name';
    final testBaseUrl = Uri.https('example.com', '/client-test');

    final mockSodium = MockSodium();

    test('static variables report correct values', () {
      expect(
        EtebaseClient.defaultServerUrl,
        Uri.parse('https://api.etebase.com'),
      );
      expect(EtebaseClient.currentVersion, 1);
    });

    test('create creates client with SyncCryptoExecutor', () {
      final sut = EtebaseClient.create(mockSodium, testClientName, testBaseUrl);
      addTearDown(sut.dispose);

      expect(
        sut,
        isA<Client>()
            .having(
              (m) => m.crypto.executor,
              'crypto.executor',
              isA<SyncCryptoExecutor>(),
            )
            .having((m) => m.userAgent, 'userAgent', contains(testClientName))
            .having((m) => m.baseUrl, 'baseUrl', testBaseUrl),
      );
    });

    test(
      'createAsync creates client with AsyncCryptoExecutor',
      testOn: 'dart-vm',
      () async {
        final sut = await EtebaseClient.createAsync(
          mockSodium,
          testClientName,
          testBaseUrl,
        );
        addTearDown(sut.dispose);

        expect(
          sut,
          isA<Client>()
              .having(
                (m) => m.crypto.executor,
                'crypto.executor',
                isA<AsyncCryptoExecutor>(),
              )
              .having((m) => m.userAgent, 'userAgent', contains(testClientName))
              .having((m) => m.baseUrl, 'baseUrl', testBaseUrl),
        );
      },
    );

    test('createCustom creates client with a custom executor', () {
      final testExecutor = MockCryptoExecutor(mockSodium);

      final sut = EtebaseClient.createCustom(
        testExecutor,
        testClientName,
        testBaseUrl,
      );
      addTearDown(sut.dispose);

      expect(
        sut,
        isA<Client>()
            .having((m) => m.crypto.executor, 'crypto.executor', testExecutor)
            .having((m) => m.userAgent, 'userAgent', contains(testClientName))
            .having((m) => m.baseUrl, 'baseUrl', testBaseUrl),
      );
    });
  });
}
