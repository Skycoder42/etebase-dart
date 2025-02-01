import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/impl/crypto/crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
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
      mockSodium.resetAll();
      reset(mockCryptoExecutor);

      when(mockSodium.crypto.kdf.contextBytes)
          .thenReturn(testContextPadded.length);
      when(
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: anyNamed('masterKey'),
          context: anyNamed('context'),
          subkeyId: anyNamed('subkeyId'),
          subkeyLen: anyNamed('subkeyLen'),
        ),
      ).thenAnswer((i) {
        final {#subkeyId: BigInt subkeyId} = i.namedArguments;
        return FakeSecureKey(subkeyId.toInt());
      });

      mockCryptoExecutor.setupMocks();

      sut =
          TestableCryptoManager(mockCryptoExecutor, testMasterKey, testVersion);
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
  });
}
