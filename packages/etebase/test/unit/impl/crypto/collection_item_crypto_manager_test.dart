import 'package:etebase/src/impl/crypto/collection_item_crypto_manager.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

void main() {
  group('$CollectionItemCryptoManager', () {
    final testMasterKey = FakeSecureKey(121);

    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);

    late CollectionItemCryptoManager sut;

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor.resetAndSetup();

      sut = CollectionItemCryptoManager(
        mockCryptoExecutor,
        testMasterKey,
        23,
      );
    });

    test('sets correct context', () {
      expect(sut.context, 'ColItem');
    });
  });
}
