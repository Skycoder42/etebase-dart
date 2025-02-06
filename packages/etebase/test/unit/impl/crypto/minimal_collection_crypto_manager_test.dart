import 'package:etebase/src/impl/crypto/minimal_collection_crypto_manager.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

void main() {
  group('$MinimalCollectionCryptoManager', () {
    final testMasterKey = FakeSecureKey(212);

    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);

    late MinimalCollectionCryptoManager sut;

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor.resetAndSetup();

      sut = MinimalCollectionCryptoManager(
        mockCryptoExecutor,
        testMasterKey,
        23,
      );
    });

    test('sets correct context', () {
      expect(sut.context, 'Col');
    });
  });
}
