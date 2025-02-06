import 'dart:typed_data';

import 'package:etebase/src/impl/crypto/login_crypto_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

void main() {
  group('$LoginCryptoManager', () {
    final testPubKey = Uint8List.fromList([5, 6, 8, 1]);
    final testSecKey = FakeSecureKey(23);
    final testKeyPair = KeyPair(publicKey: testPubKey, secretKey: testSecKey);

    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);

    late LoginCryptoManager sut;

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor.resetAndSetup();

      sut = LoginCryptoManager(mockCryptoExecutor, testKeyPair);
    });

    test('pubkey returns key pair public key', () {
      expect(sut.pubkey, testPubKey);
    });

    group('dispose', () {
      test('disposes key pair', () {
        sut.dispose();

        expect(testSecKey.disposed, isTrue);
      });

      test('disposes only once', () {
        sut.dispose();

        expect(testSecKey.disposed, isTrue);

        testSecKey.disposed = false;
        sut.dispose();

        expect(testSecKey.disposed, isFalse);
      });
    });

    test('signDetached creates signature for message', () async {
      final testMessage = Uint8List.fromList([5, 4, 5, 6, 3]);
      final testSignature = Uint8List.fromList([9, 3, 8, 6]);

      when(
        mockSodium.crypto.sign.detached(
          message: anyNamed('message'),
          secretKey: anyNamed('secretKey'),
        ),
      ).thenReturn(testSignature);

      final result = await sut.signDetached(testMessage);

      expect(result, testSignature);

      verifyInOrder([
        mockCryptoExecutor.exec<Uint8List>(
          any,
          secureKeys: argThat(contains(testSecKey), named: 'secureKeys'),
        ),
        mockSodium.crypto.sign.detached(
          message: testMessage,
          secretKey: testSecKey,
        ),
      ]);
    });

    test('verifyDetached validates signature for message', () async {
      final testMessage = Uint8List.fromList([5, 4, 5, 6, 3]);
      final testSignature = Uint8List.fromList([9, 3, 8, 6]);
      final testOtherPubKey = Uint8List.fromList([22, 56]);

      when(
        mockSodium.crypto.sign.verifyDetached(
          message: anyNamed('message'),
          publicKey: anyNamed('publicKey'),
          signature: anyNamed('signature'),
        ),
      ).thenReturn(true);

      final result = await sut.verifyDetached(
        message: testMessage,
        signature: testSignature,
        pubkey: testOtherPubKey,
      );

      expect(result, isTrue);

      verifyInOrder([
        mockCryptoExecutor.exec<bool>(any),
        mockSodium.crypto.sign.verifyDetached(
          message: testMessage,
          signature: testSignature,
          publicKey: testOtherPubKey,
        ),
      ]);
    });
  });
}
