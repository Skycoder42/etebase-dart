import 'dart:typed_data';

import 'package:etebase/src/api/exceptions/crypto_failure.dart';
import 'package:etebase/src/impl/crypto/crypto_mac.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';
import 'crypto_mocks.dart';

// ignore: directives_ordering
@GenerateNiceMocks([MockSpec<GenericHashConsumer>()])
import 'crypto_mac_test.mocks.dart';

void main() {
  group('$CryptoMac', () {
    final mockSodium = MockSodium();
    final mockCryptoExecutor = MockCryptoExecutor(mockSodium);
    final mockGenericHashConsumer = MockGenericHashConsumer();

    setUp(() {
      mockSodium.resetAndSetup();
      mockCryptoExecutor.resetAndSetup();
      reset(mockGenericHashConsumer);

      when(
        mockSodium.crypto.genericHash.createConsumer(
          outLen: anyNamed('outLen'),
          key: anyNamed('key'),
        ),
      ).thenReturn(mockGenericHashConsumer);
    });

    group('constructor ', () {
      test('initializes consumer with default parameters', () {
        CryptoMac(mockCryptoExecutor);

        verifyInOrder([
          mockCryptoExecutor.execSync<GenericHashConsumer>(any),
          mockSodium.crypto.genericHash.createConsumer(
            outLen: CryptoUtils.hashSize,
          ),
        ]);
      });

      test('initializes consumer with custom parameters', () {
        final testKey = FakeSecureKey(21);
        const testLength = 11;

        CryptoMac(mockCryptoExecutor, key: testKey, length: testLength);

        verifyInOrder([
          mockCryptoExecutor.execSync<GenericHashConsumer>(any),
          mockSodium.crypto.genericHash.createConsumer(
            key: testKey,
            outLen: testLength,
          ),
        ]);
      });
    });

    group('members', () {
      late CryptoMac sut;

      setUp(() {
        sut = CryptoMac(mockCryptoExecutor);
      });

      test('update adds data to consumer', () {
        final testData = Uint8List.fromList([5, 4, 55]);

        sut.update(testData);

        verify(mockGenericHashConsumer.add(testData));
      });

      test('updateWithLenPrefix adds data to consumer with data length', () {
        final testData = Uint8List.fromList([5, 4, 55]);

        sut.updateWithLenPrefix(testData);

        verifyInOrder([
          mockGenericHashConsumer.add(Uint8List.fromList([3, 0, 0, 0])),
          mockGenericHashConsumer.add(testData),
        ]);
      });

      group('finalize', () {
        test('returns hash result', () async {
          final testResult = Uint8List.fromList([3, 2, 3]);

          when(mockGenericHashConsumer.close()).thenReturnAsync(testResult);

          expect(sut.finalize(), completion(testResult));
        });

        test('wrap exception if close throws', () async {
          when(mockGenericHashConsumer.close()).thenThrow(SodiumException());

          expect(() => sut.finalize(), throwsA(isA<CryptoFailure>()));
        });
      });
    });
  });
}
