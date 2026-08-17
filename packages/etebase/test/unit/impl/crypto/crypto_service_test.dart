import 'dart:math';
import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/impl/crypto/account_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

class FakeAccountCryptoManager extends Fake implements AccountCryptoManager;

void main() {
  group('$CryptoService', () {
    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);

    late CryptoService sut;

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor.resetAndSetup();

      sut = CryptoService(mockCryptoExecutor);
    });

    test('dispose disposes the executor', () async {
      await sut.dispose();

      verify(mockCryptoExecutor.dispose());
    });

    test('keyDerivator returns instance with identical executor', () {
      final result = sut.keyDerivator;

      expect(result.executor, same(mockCryptoExecutor));
    });

    test('randomBytes allocates new random data', () {
      final testData = Uint8List.fromList([5, 3, 4, 2]);

      when(mockSodium.randombytes.buf(any)).thenReturn(testData);

      final result = sut.randomBytes(22);
      expect(result, testData);

      verifyInOrder([
        mockCryptoExecutor.execSync<Uint8List>(any),
        mockSodium.randombytes.buf(22),
      ]);
    });

    test('secureAlloc allocates new secure memory', () {
      final testKey = FakeSecureKey(21);

      when(mockSodium.secureAlloc(any)).thenReturn(testKey);

      final result = sut.secureAlloc(12);
      expect(result, testKey);

      verifyInOrder([
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.secureAlloc(12),
      ]);
    });

    test('secureRandom allocates new secure random data', () {
      final testKey = FakeSecureKey(21);

      when(mockSodium.secureRandom(any)).thenReturn(testKey);

      final result = sut.secureRandom(12);
      expect(result, testKey);

      verifyInOrder([
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.secureRandom(12),
      ]);
    });

    test('secureCopy creates secure memory copy of the data', () {
      final testData = Uint8List.fromList([5, 3, 4, 2]);
      final testKey = FakeSecureKey(21);

      when(mockSodium.secureCopy(any)).thenReturn(testKey);

      final result = sut.secureCopy(testData);
      expect(result, testKey);

      verifyInOrder([
        mockCryptoExecutor.execSync<SecureKey>(any),
        mockSodium.secureCopy(testData),
      ]);
    });

    test('bufferPadSmall pads data with minimal padding', () {
      final testData = Uint8List.fromList([5, 3, 4, 2]);
      final testPadded = Uint8List.fromList([5, 3, 4, 2, 5, 3]);

      when(mockSodium.pad(any, any)).thenReturn(testPadded);

      final result = sut.bufferPadSmall(testData);
      expect(result, testPadded);

      verifyInOrder([
        mockCryptoExecutor.execSync<Uint8List>(any),
        mockSodium.pad(testData, 5),
      ]);
    });

    group('bufferUnpadSmall', () {
      test('returns original data if empty', () {
        final testData = Uint8List(0);

        final result = sut.bufferUnpadSmall(testData);

        expect(result, same(testData));

        verifyZeroInteractions(mockCryptoExecutor);
        verifyZeroInteractions(mockSodium);
      });

      test('unpads data with minimal padding', () {
        final testData = Uint8List.fromList([5, 3, 4, 2]);
        final testPadded = Uint8List.fromList([5, 3, 4, 2, 5, 3]);

        when(mockSodium.unpad(any, any)).thenReturn(testData);

        final result = sut.bufferUnpadSmall(testPadded);
        expect(result, testData);

        verifyInOrder([
          mockCryptoExecutor.execSync<Uint8List>(any),
          mockSodium.unpad(testPadded, 6),
        ]);
      });
    });

    testData(
      'bufferPad pads data with dynamic padding',
      [
        // until we reach 1 << 14 (16383), the padding increases in chunks of
        // 1024 to always be at least 1 bigger then the current value
        (0, 1024),
        (1, 1024),
        (1023, 1024),
        (1024, 2048),
        (1025, 2048),
        (2047, 2048),
        (2048, 3072),
        (16383, 16384),
        // after this threshold, the padding algorithm changes
        (16384, 16384),
        (16385, 17408),
        (17408, 17408),
        (17409, 18432),
        (16777210, 16777216),
        // and so on
      ],
      (fixture) async {
        final testData = Uint8List.fromList(List.filled(fixture.$1, 0x42));
        final testPadding = Uint8List.fromList(List.filled(fixture.$2, 0xBA));

        when(mockSodium.pad(any, any)).thenReturn(testPadding);

        final result = await sut.bufferPad(testData);
        expect(result, testPadding);

        verifyInOrder([
          mockCryptoExecutor.exec<Uint8List>(any),
          mockSodium.pad(testData, fixture.$2),
        ]);
      },
    );

    group('bufferUnpad', () {
      test('returns original data if empty', () async {
        final testData = Uint8List(0);

        final result = await sut.bufferUnpad(testData);

        expect(result, same(testData));

        verifyZeroInteractions(mockCryptoExecutor);
        verifyZeroInteractions(mockSodium);
      });

      test('unpads data with minimal padding', () async {
        final testData = Uint8List.fromList([5, 3, 4, 2]);
        final testPadded = Uint8List.fromList([5, 3, 4, 2, 5, 3]);

        when(mockSodium.unpad(any, any)).thenReturn(testData);

        final result = await sut.bufferUnpad(testPadded);
        expect(result, testData);

        verifyInOrder([
          mockCryptoExecutor.exec<Uint8List>(any),
          mockSodium.unpad(testPadded, 6),
        ]);
      });
    });

    group('shuffle', () {
      final testRandom = Random(Random.secure().nextInt(1 << 30));

      setUp(() {
        when(mockSodium.randombytes.uniform(any)).thenAnswer(
          (i) => testRandom.nextInt(i.positionalArguments.single as int),
        );
      });

      testData(
        'randomizes the input list and returns indices of randomized data',
        List.generate(50, (i) => List.generate(i, (j) => j)),
        (fixture) {
          final indices = sut.shuffle(fixture);
          for (var i = 0; i < fixture.length; ++i) {
            expect(fixture[indices[i]], i);
          }

          verifyInOrder([
            mockCryptoExecutor.execSync<List<int>>(any),
            for (var i = 0; i < fixture.length; ++i)
              mockSodium.randombytes.uniform(fixture.length - i),
          ]);
        },
      );
    });

    group('prettyFingerprint', () {
      test('creates pretty fingerprint from raw data', () {
        final testFingerprint = Uint8List.fromList([4, 5, 2, 4, 1]);
        final testHash = Uint8List.fromList(List.generate(32, (i) => i));

        when(
          mockSodium.crypto.genericHash.call(
            message: anyNamed('message'),
            outLen: anyNamed('outLen'),
          ),
        ).thenReturn(testHash);

        final result = sut.prettyFingerprint(testFingerprint);

        expect(result, '''
00258   97637   95016   92395
89774   87153   84532   81911
79290   76669   08255   00000''');

        verifyInOrder([
          mockCryptoExecutor.execSync<String>(any),
          mockSodium.crypto.genericHash.call(
            message: testFingerprint,
            outLen: CryptoUtils.hashSize,
          ),
        ]);
      });

      test('creates pretty fingerprint with custom delimiter', () {
        final testFingerprint = Uint8List.fromList([4, 5, 2, 4, 1]);
        final testHash = Uint8List.fromList(List.generate(32, (i) => i));

        when(
          mockSodium.crypto.genericHash.call(
            message: anyNamed('message'),
            outLen: anyNamed('outLen'),
          ),
        ).thenReturn(testHash);

        final result = sut.prettyFingerprint(testFingerprint, '-');

        expect(result, '''
00258-97637-95016-92395
89774-87153-84532-81911
79290-76669-08255-00000''');
      });
    });

    group('createMainCryptoManager', () {
      final testKey = FakeSecureKey(13);

      test('creates crypto manager with default version', () {
        final result = sut.createMainCryptoManager(testKey);

        expect(result.executor, same(mockCryptoExecutor));
        expect(result.mainKey, testKey);
        expect(result.version, CryptoUtils.currentVersion);
      });

      test('creates crypto manager with custom version', () {
        final result = sut.createMainCryptoManager(testKey, version: 34);

        expect(result.executor, same(mockCryptoExecutor));
        expect(result.mainKey, testKey);
        expect(result.version, 34);
      });
    });

    test('createIdentityCryptoManager creates crypto manager with seed', () {
      final testSeed = FakeSecureKey(212);
      final testKeyPair = KeyPair(
        publicKey: Uint8List.fromList([4]),
        secretKey: FakeSecureKey(21),
      );

      when(mockSodium.crypto.box.seedKeyPair(any)).thenReturn(testKeyPair);

      final result = sut.createIdentityCryptoManager(testSeed);
      expect(result.executor, same(mockCryptoExecutor));
      expect(result.pubkey, testKeyPair.publicKey);
      expect(result.privkey, testKeyPair.secretKey);

      verify(mockSodium.crypto.box.seedKeyPair(testSeed));
    });

    group('createStorageCryptoManager', () {
      final testKey = FakeSecureKey(31);

      test('creates crypto manager with default version', () {
        final result = sut.createStorageCryptoManager(testKey);

        expect(result.executor, same(mockCryptoExecutor));
        expect(result.key, testKey);
        expect(result.version, CryptoUtils.currentVersion);
      });

      test('creates crypto manager with custom version', () {
        final result = sut.createStorageCryptoManager(testKey, version: 34);

        expect(result.executor, same(mockCryptoExecutor));
        expect(result.key, testKey);
        expect(result.version, 34);
      });
    });

    group('createCollectionItemCryptoManager', () {
      final testKey = FakeSecureKey(31);

      test('creates crypto manager with default version', () {
        final result = sut.createCollectionItemCryptoManager(testKey);

        expect(result.executor, same(mockCryptoExecutor));
        expect(result.key, testKey);
        expect(result.version, CryptoUtils.currentVersion);
      });

      test('creates crypto manager with custom version', () {
        final result = sut.createCollectionItemCryptoManager(
          testKey,
          version: 34,
        );

        expect(result.executor, same(mockCryptoExecutor));
        expect(result.key, testKey);
        expect(result.version, 34);
      });
    });

    group('createMinimalCollectionCryptoManager', () {
      final testKey = FakeSecureKey(31);

      test('creates crypto manager with default version', () {
        final result = sut.createMinimalCollectionCryptoManager(testKey);

        expect(result.executor, same(mockCryptoExecutor));
        expect(result.key, testKey);
        expect(result.version, CryptoUtils.currentVersion);
      });

      test('creates crypto manager with custom version', () {
        final result = sut.createMinimalCollectionCryptoManager(
          testKey,
          version: 34,
        );

        expect(result.executor, same(mockCryptoExecutor));
        expect(result.key, testKey);
        expect(result.version, 34);
      });
    });

    group('createCollectionCryptoManager', () {
      final testKey = FakeSecureKey(31);

      final fakeAccountCryptoManager = FakeAccountCryptoManager();

      test('creates crypto manager with default version', () {
        final result = sut.createCollectionCryptoManager(
          fakeAccountCryptoManager,
          testKey,
        );

        expect(result.executor, same(mockCryptoExecutor));
        expect(result.accountCryptoManager, same(fakeAccountCryptoManager));
        expect(result.key, testKey);
        expect(result.version, CryptoUtils.currentVersion);
      });

      test('creates crypto manager with custom version', () {
        final result = sut.createCollectionCryptoManager(
          fakeAccountCryptoManager,
          testKey,
          version: 34,
        );

        expect(result.executor, same(mockCryptoExecutor));
        expect(result.accountCryptoManager, same(fakeAccountCryptoManager));
        expect(result.key, testKey);
        expect(result.version, 34);
      });
    });
  });
}
