import 'dart:typed_data';

import 'package:etebase/src/impl/crypto/main_crypto_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

void main() {
  group('$MainCryptoManager', () {
    const testVersion = 4566;
    final testKey = FakeSecureKey(985);

    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);

    late MainCryptoManager sut;

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor.resetAndSetup();

      sut = MainCryptoManager(mockCryptoExecutor, testKey, testVersion);
    });

    test('context returns Main', () {
      expect(sut.context, 'Main');
    });

    test('mainKey returns the primary key', () {
      expect(sut.mainKey, testKey);
    });

    test('createLoginCryptoManager creates crypto manager from key seed', () {
      final testKeyPair = KeyPair(
        publicKey: Uint8List.fromList([3, 3, 3]),
        secretKey: FakeSecureKey(333),
      );

      when(mockSodium.crypto.sign.seedKeyPair(any)).thenReturn(testKeyPair);

      final result = sut.createLoginCryptoManager();

      expect(result.executor, mockCryptoExecutor);
      expect(result.keyPair, testKeyPair);

      verifyInOrder([
        mockCryptoExecutor.execSync<KeyPair>(any),
        mockSodium.crypto.sign.seedKeyPair(argThat(isKey(3))),
      ]);
    });

    test('createAccountCryptoManager creates account crypto manager', () {
      final testPrivKey = FakeSecureKey(54);

      final result = sut.createAccountCryptoManager(testPrivKey);

      expect(result.executor, mockCryptoExecutor);
      expect(result.key, testPrivKey);
      expect(result.version, testVersion);
    });

    test(
        'createIdentityCryptoManager creates box manager with derived key pair',
        () {
      final testPrivKey = FakeSecureKey(54);
      final testPubKey = Uint8List.fromList([5, 4]);

      when(mockSodium.crypto.scalarmult.base(n: anyNamed('n')))
          .thenReturn(testPubKey);

      final result = sut.createIdentityCryptoManager(testPrivKey);

      expect(result.executor, mockCryptoExecutor);
      expect(result.privkey, testPrivKey);
      expect(result.pubkey, testPubKey);

      verifyInOrder([
        mockCryptoExecutor.execSync<KeyPair>(any),
        mockSodium.crypto.scalarmult.base(n: testPrivKey),
      ]);
    });
  });
}
