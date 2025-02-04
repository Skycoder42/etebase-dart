import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/impl/crypto/crypto_mac.dart';
import 'package:etebase/src/impl/crypto/crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:etebase/src/impl/crypto/rollsum.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

const testContext = 'testCtx';
const testContextPadded = 'testCtx  ';

class TestableCryptoManager extends CryptoManager {
  TestableCryptoManager(super.executor, super.key, super.version);

  @override
  String get context => testContext;
}

void main() {
  group('$CryptoManager', () {
    const testVersion = 13;
    final testMasterKey = FakeSecureKey(-111);

    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);

    late TestableCryptoManager sut;

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor.resetAndSetup();

      when(mockSodium.crypto.kdf.contextBytes)
          .thenReturn(testContextPadded.length);

      sut =
          TestableCryptoManager(mockCryptoExecutor, testMasterKey, testVersion);
    });

    group('key generation', () {
      test('generates keys as expected', () {
        expect(sut.cipherKey, isKey(1));
        expect(sut.macKey, isKey(2));
        expect(sut.asymmetricKeySeed, isKey(3));
        expect(sut.subDerivationKey, isKey(4));
        expect(sut.deterministicEncryptionKey, isKey(5));

        verifyInOrder([
          for (var i = 1; i <= 5; ++i) ...[
            mockCryptoExecutor.execSync<SecureKey>(any),
            mockSodium.crypto.kdf.contextBytes,
            mockSodium.crypto.kdf.deriveFromKey(
              masterKey: testMasterKey,
              context: testContextPadded,
              subkeyId: BigInt.from(i),
              subkeyLen: CryptoUtils.symmetricKeySize,
            ),
          ],
        ]);
        verifyNoMoreInteractions(mockSodium.crypto.kdf);
      });

      test('generates keys only once', () {
        expect(sut.cipherKey, isKey(1));
        expect(sut.macKey, isKey(2));
        expect(sut.asymmetricKeySeed, isKey(3));
        expect(sut.subDerivationKey, isKey(4));
        expect(sut.deterministicEncryptionKey, isKey(5));

        clearInteractions(mockSodium.crypto.kdf);

        expect(sut.cipherKey, isKey(1));
        expect(sut.macKey, isKey(2));
        expect(sut.asymmetricKeySeed, isKey(3));
        expect(sut.subDerivationKey, isKey(4));
        expect(sut.deterministicEncryptionKey, isKey(5));

        verifyZeroInteractions(mockSodium.crypto.kdf);
      });
    });

    group('dispose', () {
      test('disposes master key', () {
        sut.dispose();
        expect(testMasterKey.disposed, isTrue);
      });

      test('disposes only once', () {
        sut.dispose();
        expect(testMasterKey.disposed, isTrue);

        testMasterKey.disposed = false;
        sut.dispose();
        expect(testMasterKey.disposed, isFalse);
      });

      test('disposes all derived keys', () {
        final keys = [
          sut.cipherKey,
          sut.macKey,
          sut.asymmetricKeySeed,
          sut.subDerivationKey,
          sut.deterministicEncryptionKey,
        ];

        sut.dispose();

        expect(
          keys,
          everyElement(
            isA<FakeSecureKey>().having((m) => m.disposed, 'disposed', isTrue),
          ),
        );
      });
    });

    test('encrypt encrypts data with cipher key', () async {
      final testMessage = Uint8List.fromList([1, 2, 3, 4, 5]);
      final testAd = Uint8List.fromList([2, 3, 2]);
      final testNonce = Uint8List.fromList([4, 4, 3]);
      final testCipher = Uint8List.fromList([6, 55, 5]);

      when(mockSodium.randombytes.buf(any)).thenReturn(testNonce);
      when(mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes)
          .thenReturn(testNonce.length);
      when(
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
          message: anyNamed('message'),
          additionalData: anyNamed('additionalData'),
          nonce: anyNamed('nonce'),
          key: anyNamed('key'),
        ),
      ).thenReturn(testCipher);

      final result = await sut.encrypt(testMessage, testAd);

      expect(result, concatenated(testNonce, testCipher));

      verifyInOrder([
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: testContextPadded,
          subkeyId: BigInt.from(1),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockCryptoExecutor.exec<Uint8List>(
          any,
          secureKeys: argThat(equals([isKey(1)]), named: 'secureKeys'),
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
        mockSodium.randombytes.buf(testNonce.length),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
          message: testMessage,
          additionalData: testAd,
          nonce: testNonce,
          key: argThat(isKey(1), named: 'key'),
        ),
      ]);
    });

    test('decrypt decrypts data with cipher key', () async {
      final testMessage = Uint8List.fromList([1, 2, 3, 4, 5]);
      final testAd = Uint8List.fromList([2, 3, 2]);
      final testNonce = Uint8List.fromList([4, 4, 3]);
      final testCipher = Uint8List.fromList([6, 55, 5]);
      final testNonceCipher = Uint8List.fromList(testNonce + testCipher);

      when(mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes)
          .thenReturn(testNonce.length);
      when(
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
          cipherText: anyNamed('cipherText'),
          additionalData: anyNamed('additionalData'),
          nonce: anyNamed('nonce'),
          key: anyNamed('key'),
        ),
      ).thenReturn(testMessage);

      final result = await sut.decrypt(testNonceCipher, testAd);

      expect(result, testMessage);

      verifyInOrder([
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: testContextPadded,
          subkeyId: BigInt.from(1),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockCryptoExecutor.exec<Uint8List>(
          any,
          secureKeys: argThat(equals([isKey(1)]), named: 'secureKeys'),
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
          cipherText: testCipher,
          additionalData: testAd,
          nonce: testNonce,
          key: argThat(isKey(1), named: 'key'),
        ),
      ]);
    });

    test('encryptKey encrypts secure key with cipher key', () {
      final testKey = FakeSecureKey(33);
      final testAd = Uint8List.fromList([2, 3, 2]);
      final testNonce = Uint8List.fromList([4, 4, 3]);
      final testCipher = Uint8List.fromList([6, 55, 5]);

      when(mockSodium.randombytes.buf(any)).thenReturn(testNonce);
      when(mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes)
          .thenReturn(testNonce.length);
      when(
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
          message: anyNamed('message'),
          additionalData: anyNamed('additionalData'),
          nonce: anyNamed('nonce'),
          key: anyNamed('key'),
        ),
      ).thenReturn(testCipher);

      final result = sut.encryptKey(testKey, testAd);

      expect(result, concatenated(testNonce, testCipher));

      verifyInOrder([
        mockCryptoExecutor.execSync<Uint8List>(any),
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: testContextPadded,
          subkeyId: BigInt.from(1),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
        mockSodium.randombytes.buf(testNonce.length),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
          message: argThat(isUnlockedKey(33), named: 'message'),
          additionalData: testAd,
          nonce: testNonce,
          key: argThat(isKey(1), named: 'key'),
        ),
      ]);
    });

    testData('decryptKey decrypts secure key with cipher key', [null, 2],
        (fixture) {
      final testKey = FakeSecureKey(33);
      final testKeyBytes = Uint8List.fromList([1, 10, 100]);
      final testAd = Uint8List.fromList([2, 3, 2]);
      final testNonce = Uint8List.fromList([4, 4, 3]);
      final testCipher = Uint8List.fromList([6, 55, 5]);
      final testNonceCipher = Uint8List.fromList(testNonce + testCipher);

      when(mockSodium.secureCopy(any)).thenReturn(testKey);
      when(mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes)
          .thenReturn(testNonce.length);
      when(
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
          cipherText: anyNamed('cipherText'),
          additionalData: anyNamed('additionalData'),
          nonce: anyNamed('nonce'),
          key: anyNamed('key'),
        ),
      ).thenReturn(testKeyBytes);

      final result = sut.decryptKey(
        testNonceCipher,
        testAd,
        fixture,
      );

      expect(result, testKey);

      verifyInOrder([
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: testContextPadded,
          subkeyId: BigInt.from(1),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
          cipherText: testCipher,
          additionalData: testAd,
          nonce: testNonce,
          key: argThat(isKey(1), named: 'key'),
        ),
        if (fixture == null)
          mockSodium.secureCopy(testKeyBytes)
        else
          mockSodium.secureCopy(testKeyBytes.sublist(0, fixture)),
      ]);
    });

    test('encryptDetached encrypts data with cipher key', () async {
      final testMessage = Uint8List.fromList([1, 2, 3, 4, 5]);
      final testAd = Uint8List.fromList([2, 3, 2]);
      final testNonce = Uint8List.fromList([4, 4, 3]);
      final testCipher = Uint8List.fromList([6, 55, 5]);
      final testMac = Uint8List.fromList([7, 4, 9]);

      when(mockSodium.randombytes.buf(any)).thenReturn(testNonce);
      when(mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes)
          .thenReturn(testNonce.length);
      when(
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.encryptDetached(
          message: anyNamed('message'),
          additionalData: anyNamed('additionalData'),
          nonce: anyNamed('nonce'),
          key: anyNamed('key'),
        ),
      ).thenReturn(DetachedCipherResult(cipherText: testCipher, mac: testMac));

      final result = await sut.encryptDetached(testMessage, testAd);

      expect(result.nonceCipherText, concatenated(testNonce, testCipher));
      expect(result.mac, testMac);

      verifyInOrder([
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: testContextPadded,
          subkeyId: BigInt.from(1),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockCryptoExecutor.exec<Uint8List>(
          any,
          secureKeys: argThat(equals([isKey(1)]), named: 'secureKeys'),
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
        mockSodium.randombytes.buf(testNonce.length),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.encryptDetached(
          message: testMessage,
          additionalData: testAd,
          nonce: testNonce,
          key: argThat(isKey(1), named: 'key'),
        ),
      ]);
    });

    test('decryptDetached decrypts data with cipher key', () async {
      final testMessage = Uint8List.fromList([1, 2, 3, 4, 5]);
      final testAd = Uint8List.fromList([2, 3, 2]);
      final testNonce = Uint8List.fromList([4, 4, 3]);
      final testCipher = Uint8List.fromList([6, 55, 5]);
      final testNonceCipher = Uint8List.fromList(testNonce + testCipher);
      final testMac = Uint8List.fromList([7, 4, 9]);

      when(mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes)
          .thenReturn(testNonce.length);
      when(
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decryptDetached(
          cipherText: anyNamed('cipherText'),
          mac: anyNamed('mac'),
          additionalData: anyNamed('additionalData'),
          nonce: anyNamed('nonce'),
          key: anyNamed('key'),
        ),
      ).thenReturn(testMessage);

      final result = await sut.decryptDetached(
        testNonceCipher,
        testMac,
        testAd,
      );

      expect(result, testMessage);

      verifyInOrder([
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: testContextPadded,
          subkeyId: BigInt.from(1),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockCryptoExecutor.exec<Uint8List>(
          any,
          secureKeys: argThat(equals([isKey(1)]), named: 'secureKeys'),
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decryptDetached(
          cipherText: testCipher,
          mac: testMac,
          additionalData: testAd,
          nonce: testNonce,
          key: argThat(isKey(1), named: 'key'),
        ),
      ]);
    });

    test('verify decrypts data with cipher key, but only returns success',
        () async {
      final testAd = Uint8List.fromList([2, 3, 2]);
      final testNonce = Uint8List.fromList([4, 4, 3]);
      final testCipher = Uint8List.fromList([6, 55, 5]);
      final testNonceCipher = Uint8List.fromList(testNonce + testCipher);
      final testMac = Uint8List.fromList([7, 4, 9]);

      when(mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes)
          .thenReturn(testNonce.length);

      final result = await sut.verify(
        testNonceCipher,
        testMac,
        testAd,
      );

      expect(result, isTrue);

      verifyInOrder([
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: testContextPadded,
          subkeyId: BigInt.from(1),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockCryptoExecutor.exec<Uint8List>(
          any,
          secureKeys: argThat(equals([isKey(1)]), named: 'secureKeys'),
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decryptDetached(
          cipherText: testCipher,
          mac: testMac,
          additionalData: testAd,
          nonce: testNonce,
          key: argThat(isKey(1), named: 'key'),
        ),
      ]);
    });

    group('calculateMac', () {
      final testMessage = Uint8List.fromList([1, 2, 3, 4, 5]);
      final testMac = Uint8List.fromList([7, 4, 9]);

      setUp(() {
        when(
          mockSodium.crypto.genericHash.call(
            message: anyNamed('message'),
            key: anyNamed('key'),
            outLen: anyNamed('outLen'),
          ),
        ).thenReturn(testMac);
      });

      test('hashes the data with the macKey', () async {
        final result = await sut.calculateMac(testMessage);

        expect(result, testMac);

        verifyInOrder([
          mockCryptoExecutor.execSync<SecureKey>(any),
          mockSodium.crypto.kdf.contextBytes,
          mockSodium.crypto.kdf.deriveFromKey(
            masterKey: testMasterKey,
            context: testContextPadded,
            subkeyId: BigInt.from(2),
            subkeyLen: CryptoUtils.symmetricKeySize,
          ),
          mockCryptoExecutor.exec<Uint8List>(
            any,
            secureKeys: argThat(equals([isKey(2)]), named: 'secureKeys'),
          ),
          mockSodium.crypto.genericHash.call(
            message: testMessage,
            key: argThat(isKey(2), named: 'key'),
            outLen: CryptoUtils.hashSize,
          ),
        ]);
      });

      test('hashes the data without a key if specified', () async {
        final result = await sut.calculateMac(testMessage, withKey: false);

        expect(result, testMac);

        verifyInOrder([
          mockCryptoExecutor.exec<Uint8List>(
            any,
            secureKeys: argThat(isEmpty, named: 'secureKeys'),
          ),
          mockSodium.crypto.genericHash.call(
            message: testMessage,
            outLen: CryptoUtils.hashSize,
          ),
        ]);
        verifyZeroInteractions(mockSodium.crypto.kdf);
      });
    });

    group('getCryptoMac', () {
      test('returns a CryptoMac initialized with the macKey', () {
        final cryptoMac = sut.getCryptoMac();

        expect(cryptoMac, isA<CryptoMac>());

        verifyInOrder([
          mockCryptoExecutor.execSync<SecureKey>(any),
          mockSodium.crypto.kdf.contextBytes,
          mockSodium.crypto.kdf.deriveFromKey(
            masterKey: testMasterKey,
            context: testContextPadded,
            subkeyId: BigInt.from(2),
            subkeyLen: CryptoUtils.symmetricKeySize,
          ),
          mockCryptoExecutor.execSync<GenericHashConsumer>(any),
          mockSodium.crypto.genericHash.createConsumer(
            key: argThat(isKey(2), named: 'key'),
            outLen: CryptoUtils.hashSize,
          ),
        ]);
      });

      test('returns a CryptoMac initialized without a key if specified', () {
        final cryptoMac = sut.getCryptoMac(withKey: false);

        expect(cryptoMac, isA<CryptoMac>());

        verifyInOrder([
          mockCryptoExecutor.execSync<GenericHashConsumer>(any),
          mockSodium.crypto.genericHash.createConsumer(
            outLen: CryptoUtils.hashSize,
          ),
        ]);
        verifyZeroInteractions(mockSodium.crypto.kdf);
      });
    });

    test('getChunker returns a Rollsum instance', () {
      expect(sut.getChunker(), isA<Rollsum>());
    });

    group('deriveSubkey', () {
      test('derives a new key from the subDerivationKey and salt', () {
        final testSalt = Uint8List.fromList([7, 4, 4, 3]);
        final testSaltKey = FakeSecureKey(44);
        final testHashBytes = Uint8List.fromList([5, 3, 1, 8, 2]);
        final testHashKey = FakeSecureKey(55);

        when(mockSodium.secureCopy(testSalt)).thenReturn(testSaltKey);
        when(mockSodium.secureCopy(testHashBytes)).thenReturn(testHashKey);
        when(
          mockSodium.crypto.genericHash.call(
            message: anyNamed('message'),
            key: anyNamed('key'),
            outLen: anyNamed('outLen'),
          ),
        ).thenReturn(testHashBytes);

        final result = sut.deriveSubkey(testSalt);

        expect(result, testHashKey);
        expect(testHashKey.disposed, isFalse);
        expect(testSaltKey.disposed, isTrue);

        verifyInOrder([
          mockCryptoExecutor.execSync<SecureKey>(any),
          mockSodium.crypto.kdf.contextBytes,
          mockSodium.crypto.kdf.deriveFromKey(
            masterKey: testMasterKey,
            context: testContextPadded,
            subkeyId: BigInt.from(4),
            subkeyLen: CryptoUtils.symmetricKeySize,
          ),
          mockSodium.secureCopy(testSalt),
          mockSodium.crypto.genericHash.call(
            message: argThat(isUnlockedKey(4), named: 'message'),
            key: testSaltKey,
            outLen: CryptoUtils.symmetricKeySize,
          ),
          mockSodium.secureCopy(testHashBytes),
        ]);
      });

      test('disposes salt key if generic hash throws', () {
        final testSalt = Uint8List.fromList([7, 4, 4, 3]);
        final testSaltKey = FakeSecureKey(44);
        final testException = Exception('test');

        when(mockSodium.secureCopy(any)).thenReturn(testSaltKey);
        when(
          mockSodium.crypto.genericHash.call(
            message: anyNamed('message'),
            key: anyNamed('key'),
            outLen: anyNamed('outLen'),
          ),
        ).thenThrow(testException);

        expect(() => sut.deriveSubkey(testSalt), throwsA(testException));
        expect(testSaltKey.disposed, isTrue);
      });
    });

    test(
      'deterministicEncrypt encrypts data with deterministicEncryptionKey '
      'and calculated nonce',
      () {
        final testMessage = Uint8List.fromList([1, 2, 3, 4, 5]);
        final testAd = Uint8List.fromList([2, 3, 2]);
        final testHash = Uint8List.fromList([4, 4, 3, 6, 5, 7]);
        final testNonce = Uint8List.fromList([4, 4, 3]);
        final testCipher = Uint8List.fromList([6, 55, 5]);

        when(
          mockSodium.crypto.genericHash.call(
            message: anyNamed('message'),
            key: anyNamed('key'),
            outLen: anyNamed('outLen'),
          ),
        ).thenReturn(testHash);
        when(mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes)
            .thenReturn(testNonce.length);
        when(
          mockSodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
            message: anyNamed('message'),
            additionalData: anyNamed('additionalData'),
            nonce: anyNamed('nonce'),
            key: anyNamed('key'),
          ),
        ).thenReturn(testCipher);

        final result = sut.deterministicEncrypt(testMessage, testAd);

        expect(result, concatenated(testNonce, testCipher));

        verifyInOrder([
          mockCryptoExecutor.execSync<Uint8List>(any),
          mockCryptoExecutor.execSync<SecureKey>(any),
          mockSodium.crypto.kdf.contextBytes,
          mockSodium.crypto.kdf.deriveFromKey(
            masterKey: testMasterKey,
            context: testContextPadded,
            subkeyId: BigInt.from(2),
            subkeyLen: CryptoUtils.symmetricKeySize,
          ),
          mockSodium.crypto.genericHash.call(
            message: testMessage,
            key: argThat(isKey(2), named: 'key'),
            outLen: CryptoUtils.symmetricKeySize,
          ),
          mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
          mockCryptoExecutor.execSync<SecureKey>(any),
          mockSodium.crypto.kdf.contextBytes,
          mockSodium.crypto.kdf.deriveFromKey(
            masterKey: testMasterKey,
            context: testContextPadded,
            subkeyId: BigInt.from(5),
            subkeyLen: CryptoUtils.symmetricKeySize,
          ),
          mockSodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
            message: testMessage,
            additionalData: testAd,
            nonce: testNonce,
            key: argThat(isKey(5), named: 'key'),
          ),
        ]);
      },
    );

    test('deterministicDecrypt decrypts data with deterministicEncryptionKey',
        () {
      final testMessage = Uint8List.fromList([1, 2, 3, 4, 5]);
      final testAd = Uint8List.fromList([2, 3, 2]);
      final testNonce = Uint8List.fromList([4, 4, 3]);
      final testCipher = Uint8List.fromList([6, 55, 5]);
      final testNonceCipher = Uint8List.fromList(testNonce + testCipher);

      when(mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes)
          .thenReturn(testNonce.length);
      when(
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
          cipherText: anyNamed('cipherText'),
          additionalData: anyNamed('additionalData'),
          nonce: anyNamed('nonce'),
          key: anyNamed('key'),
        ),
      ).thenReturn(testMessage);

      final result = sut.deterministicDecrypt(testNonceCipher, testAd);

      expect(result, testMessage);

      verifyInOrder([
        mockCryptoExecutor.execSync<Uint8List>(any),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: testContextPadded,
          subkeyId: BigInt.from(5),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
          cipherText: testCipher,
          additionalData: testAd,
          nonce: testNonce,
          key: argThat(isKey(5), named: 'key'),
        ),
      ]);
    });
  });
}
