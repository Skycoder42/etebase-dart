import 'package:etebase/src/api/managers/crypto_executor.dart';
import 'package:etebase/src/impl/crypto/executors/async_crypto_executor.dart';
import 'package:etebase/src/impl/crypto/executors/sync_crypto_executor.dart';
import 'package:test/test.dart';

import '../../impl/crypto/crypto_mocks.dart';

void main() {
  group('$CryptoExecutor', () {
    final mockSodium = MockSodium();

    test('sync creates a SyncCryptoExecutor', () {
      final sut = CryptoExecutor.sync(mockSodium);

      expect(sut, isA<SyncCryptoExecutor>());
    });

    test(
      'async creates an AsyncCryptoExecutor and initializes it',
      testOn: 'dart-vm',
      () async {
        final sut = await CryptoExecutor.async(mockSodium);
        addTearDown(sut.dispose);

        expect(sut, isA<AsyncCryptoExecutor>());

        final result = await sut.execAsync((_, _, _) => true);
        expect(result, isTrue);
      },
    );
  });
}
