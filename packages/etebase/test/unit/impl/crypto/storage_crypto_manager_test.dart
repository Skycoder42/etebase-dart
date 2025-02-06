import 'package:etebase/src/impl/crypto/storage_crypto_manager.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

void main() {
  group('$StorageCryptoManager', () {
    final testMasterKey = FakeSecureKey(212);

    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);

    late StorageCryptoManager sut;

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor.resetAndSetup();

      sut = StorageCryptoManager(
        mockCryptoExecutor,
        testMasterKey,
        23,
      );
    });

    test('sets correct context', () {
      expect(sut.context, 'Stor');
    });
  });
}
