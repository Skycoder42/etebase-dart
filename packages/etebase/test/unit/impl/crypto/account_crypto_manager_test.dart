import 'dart:convert';
import 'dart:typed_data';

import 'package:etebase/src/impl/crypto/account_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

void main() {
  group('$AccountCryptoManager', () {
    const accountContextPadded = 'Acct    ';
    final testMasterKey = FakeSecureKey(121);

    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);

    late AccountCryptoManager sut;

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor.resetAndSetup();

      when(mockSodium.crypto.kdf.contextBytes)
          .thenReturn(accountContextPadded.length);

      sut = AccountCryptoManager(mockCryptoExecutor, testMasterKey, 23);
    });

    test('context returns Acct', () {
      expect(sut.context, 'Acct');
    });

    test('colTypeToUid encrypts collection id deterministically', () {
      const testColId = 'test-id';
      final testColIdBytes = utf8.encode(testColId);
      final testColIdBytesPadded = Uint8List.fromList([1, 2, 1]);
      final testHash = Uint8List.fromList([4, 4, 3, 6, 5, 7]);
      final testNonce = Uint8List.fromList([4, 4, 3]);
      final testCipher = Uint8List.fromList([6, 3, 8]);

      when(mockSodium.pad(any, any)).thenReturn(testColIdBytesPadded);
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
          nonce: anyNamed('nonce'),
          key: anyNamed('key'),
        ),
      ).thenReturn(testCipher);

      final result = sut.colTypeToUid(testColId);
      expect(result, concatenated(testNonce, testCipher));

      verifyInOrder([
        mockCryptoExecutor.execSync<Uint8List>(any),
        mockSodium.pad(testColIdBytes, 32),
        // deterministic encrypt
        mockCryptoExecutor.execSync<Uint8List>(any),
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: accountContextPadded,
          subkeyId: BigInt.from(2),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockSodium.crypto.genericHash.call(
          message: testColIdBytesPadded,
          key: argThat(isKey(2), named: 'key'),
          outLen: CryptoUtils.symmetricKeySize,
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: accountContextPadded,
          subkeyId: BigInt.from(5),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.encrypt(
          message: testColIdBytesPadded,
          nonce: testNonce,
          key: argThat(isKey(5), named: 'key'),
        ),
      ]);
    });

    test('colTypeFromUid decrypts collection id deterministically', () {
      const testColId = 'test-id';
      final testColIdBytes = utf8.encode(testColId);
      final testColIdBytesPadded = Uint8List.fromList([1, 2, 1]);
      final testNonce = Uint8List.fromList([4, 4, 3]);
      final testCipher = Uint8List.fromList([6, 55, 5]);
      final testNonceCipher = Uint8List.fromList(testNonce + testCipher);

      when(mockSodium.unpad(any, any)).thenReturn(testColIdBytes);
      when(mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes)
          .thenReturn(testNonce.length);
      when(
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
          cipherText: anyNamed('cipherText'),
          additionalData: anyNamed('additionalData'),
          nonce: anyNamed('nonce'),
          key: anyNamed('key'),
        ),
      ).thenReturn(testColIdBytesPadded);

      final result = sut.colTypeFromUid(testNonceCipher);

      expect(result, testColId);

      verifyInOrder([
        mockCryptoExecutor.execSync<Uint8List>(any),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.nonceBytes,
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.crypto.kdf.contextBytes,
        mockSodium.crypto.kdf.deriveFromKey(
          masterKey: testMasterKey,
          context: accountContextPadded,
          subkeyId: BigInt.from(5),
          subkeyLen: CryptoUtils.symmetricKeySize,
        ),
        mockSodium.crypto.aeadXChaCha20Poly1305IETF.decrypt(
          cipherText: testCipher,
          nonce: testNonce,
          key: argThat(isKey(5), named: 'key'),
        ),
        mockCryptoExecutor.execSync<String>(any),
        mockSodium.unpad(testColIdBytesPadded, 32),
      ]);
    });

    group('createCollectionCryptoManager', () {
      final testCmKey = FakeSecureKey(11);

      test('creates manager with current version', () {
        final cm = sut.createCollectionCryptoManager(testCmKey);

        expect(cm.executor, mockCryptoExecutor);
        expect(cm.accountCryptoManager, sut);
        expect(cm.key, testCmKey);
        expect(cm.version, sut.version);
      });

      test('creates manager with custom version', () {
        const testVersion = 4711;
        final cm = sut.createCollectionCryptoManager(
          testCmKey,
          version: testVersion,
        );

        expect(cm.executor, mockCryptoExecutor);
        expect(cm.accountCryptoManager, sut);
        expect(cm.key, testCmKey);
        expect(cm.version, testVersion);
      });
    });
  });
}
