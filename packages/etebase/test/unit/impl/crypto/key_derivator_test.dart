import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:etebase/src/impl/crypto/key_derivator.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

void main() {
  group('$KeyDerivator', () {
    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);

    late KeyDerivator sut;

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor
        ..resetAndSetup()
        ..mockExecAsync<SecureKey>();

      sut = KeyDerivator(mockCryptoExecutor);
    });

    test('randomSalt generates new random salt bytes', () {
      final testSalt = Uint8List.fromList([2, 4, 3, 7, 0]);

      when(mockSodium.crypto.pwhash.saltBytes).thenReturn(testSalt.length);
      when(mockSodium.randombytes.buf(any)).thenReturn(testSalt);

      final result = sut.randomSalt();

      expect(result, testSalt);

      verifyInOrder([
        mockCryptoExecutor.execSync<Uint8List>(any),
        mockSodium.crypto.pwhash.saltBytes,
        mockSodium.randombytes.buf(testSalt.length),
      ]);
    });

    testData(
      'call generates secure key from salt, password and difficulty',
      [
        (KeyDerivationDifficulty.easy, 1),
        (KeyDerivationDifficulty.medium, 2),
        (KeyDerivationDifficulty.hard, 3),
      ],
      (fixture) async {
        final testSalt = Uint8List.fromList([2, 4, 3, 7, 0]);
        const testPassword = 'test-123';
        final testPasswordBytes = utf8.encode(testPassword).signedView();
        final testKey = FakeSecureKey(87);

        when(mockSodium.crypto.pwhash.opsLimitInteractive).thenReturn(1);
        when(mockSodium.crypto.pwhash.opsLimitModerate).thenReturn(2);
        when(mockSodium.crypto.pwhash.opsLimitSensitive).thenReturn(3);
        when(mockSodium.crypto.pwhash.memLimitModerate).thenReturn(4);
        when(
          mockSodium.crypto.pwhash.call(
            outLen: anyNamed('outLen'),
            password: anyNamed('password'),
            salt: anyNamed('salt'),
            opsLimit: anyNamed('opsLimit'),
            memLimit: anyNamed('memLimit'),
          ),
        ).thenReturn(testKey);

        final result = await sut.call(
          salt: testSalt,
          password: testPassword,
          difficulty: fixture.$1,
        );

        expect(result, testKey);

        verifyInOrder([
          mockCryptoExecutor.execAsync<SecureKey>(any),
          switch (fixture.$1) {
            KeyDerivationDifficulty.hard =>
              mockSodium.crypto.pwhash.opsLimitSensitive,
            KeyDerivationDifficulty.medium =>
              mockSodium.crypto.pwhash.opsLimitModerate,
            KeyDerivationDifficulty.easy =>
              mockSodium.crypto.pwhash.opsLimitInteractive,
          },
          mockSodium.crypto.pwhash.memLimitModerate,
          mockSodium.crypto.pwhash.call(
            outLen: CryptoUtils.symmetricKeySize,
            password: testPasswordBytes,
            salt: testSalt,
            opsLimit: fixture.$2,
            memLimit: 4,
          ),
        ]);
      },
    );
  });
}
