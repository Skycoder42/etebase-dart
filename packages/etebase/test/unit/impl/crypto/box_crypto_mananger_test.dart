import 'dart:typed_data';

import 'package:etebase/src/impl/crypto/box_crypto_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

void main() {
  group('$BoxCryptoManager', () {
    final testPubKey = Uint8List.fromList([5, 4, 3, 4]);
    final testSecKey = FakeSecureKey(23);
    final testKeyPair = KeyPair(publicKey: testPubKey, secretKey: testSecKey);

    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor.resetAndSetup();
    });

    group('members', () {
      late BoxCryptoManager sut;

      setUp(() {
        sut = BoxCryptoManager(mockCryptoExecutor, testKeyPair);
      });

      test('pubkey and privkey returns values of key pair', () {
        expect(sut.pubkey, testPubKey);
        expect(sut.privkey, testSecKey);
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

      test('encrypt encrypts data with crypto box easy', () async {
        final testMessage = Uint8List.fromList([1, 2, 2]);
        final testOtherPubKey = Uint8List.fromList([4, 8, 3, 1]);
        final testNonce = Uint8List.fromList([3, 3]);
        final testCipher = Uint8List.fromList([9, 4, 8, 7]);

        when(mockSodium.randombytes.buf(any)).thenReturn(testNonce);
        when(mockSodium.crypto.box.nonceBytes).thenReturn(testNonce.length);
        when(
          mockSodium.crypto.box.easy(
            message: anyNamed('message'),
            nonce: anyNamed('nonce'),
            publicKey: anyNamed('publicKey'),
            secretKey: anyNamed('secretKey'),
          ),
        ).thenReturn(testCipher);

        final result = await sut.encrypt(
          message: testMessage,
          pubkey: testOtherPubKey,
        );

        expect(result, concatenated(testNonce, testCipher));

        verifyInOrder([
          mockCryptoExecutor.exec<Uint8List>(
            any,
            secureKeys: argThat(contains(testSecKey), named: 'secureKeys'),
          ),
          mockSodium.crypto.box.nonceBytes,
          mockSodium.randombytes.buf(testNonce.length),
          mockSodium.crypto.box.easy(
            message: testMessage,
            nonce: testNonce,
            publicKey: testOtherPubKey,
            secretKey: testSecKey,
          ),
        ]);
      });

      test('decrypt decrypts data with crypto box easy', () async {
        final testMessage = Uint8List.fromList([1, 2, 2]);
        final testOtherPubKey = Uint8List.fromList([4, 8, 3, 1]);
        final testNonce = Uint8List.fromList([3, 3]);
        final testCipher = Uint8List.fromList([9, 4, 8, 7]);
        final testNonceCipher = Uint8List.fromList(testNonce + testCipher);

        when(mockSodium.crypto.box.nonceBytes).thenReturn(testNonce.length);
        when(
          mockSodium.crypto.box.openEasy(
            cipherText: anyNamed('cipherText'),
            nonce: anyNamed('nonce'),
            publicKey: anyNamed('publicKey'),
            secretKey: anyNamed('secretKey'),
          ),
        ).thenReturn(testMessage);

        final result = await sut.decrypt(
          nonceCipherText: testNonceCipher,
          pubkey: testOtherPubKey,
        );

        expect(result, testMessage);

        verifyInOrder([
          mockCryptoExecutor.exec<Uint8List>(
            any,
            secureKeys: argThat(contains(testSecKey), named: 'secureKeys'),
          ),
          mockSodium.crypto.box.nonceBytes,
          mockSodium.crypto.box.openEasy(
            cipherText: testCipher,
            nonce: testNonce,
            publicKey: testOtherPubKey,
            secretKey: testSecKey,
          ),
        ]);
      });
    });

    group('constructors', () {
      group('fromSeed', () {
        test('creates box with random key pair', () {
          when(mockSodium.crypto.box.keyPair()).thenReturn(testKeyPair);

          final result = BoxCryptoManager.fromSeed(mockCryptoExecutor);

          expect(result.executor, mockCryptoExecutor);
          expect(result.pubkey, testPubKey);
          expect(result.privkey, testSecKey);

          verifyInOrder([
            mockCryptoExecutor.execSync<KeyPair>(any),
            mockSodium.crypto.box.keyPair(),
          ]);
        });

        test('creates box with seeded key pair', () {
          final testSeed = FakeSecureKey(87);
          when(mockSodium.crypto.box.seedKeyPair(any)).thenReturn(testKeyPair);

          final result = BoxCryptoManager.fromSeed(
            mockCryptoExecutor,
            testSeed,
          );

          expect(result.executor, mockCryptoExecutor);
          expect(result.pubkey, testPubKey);
          expect(result.privkey, testSecKey);

          expect(testSeed.disposed, isTrue);

          verifyInOrder([
            mockCryptoExecutor.execSync<KeyPair>(any),
            mockSodium.crypto.box.seedKeyPair(testSeed),
          ]);
        });
      });
    });
  });
}
