import 'dart:typed_data';

import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

@GenerateNiceMocks([MockSpec<CryptoService>()])
import 'crypto_utils_test.mocks.dart';

void main() {
  group('$CryptoUtils', () {
    test('reports correct version and sizes', () {
      expect(CryptoUtils.currentVersion, 1);
      expect(CryptoUtils.symmetricKeySize, 32);
      expect(CryptoUtils.hashSize, 32);
    });

    test('concat combines multiple chunks into one', () {
      final c1 = Uint8List.fromList([1, 2]);
      final c2 = Uint8List.fromList([]);
      final c3 = Uint8List.fromList([2, 3, 2, 3]);
      final c4 = Uint8List.fromList([8, 9]);

      expect(CryptoUtils.concat([c1, c2, c3, c4]), [1, 2, 2, 3, 2, 3, 8, 9]);
    });

    test('concatSecure combines multiple secure keys into one', () {
      final mockCryptoService = MockCryptoService();

      final key1 = FakeSecureKey(1);
      final key2 = FakeSecureKey(2);
      final key3 = FakeSecureKey(3);
      final key4 = FakeSecureKey(4);
      final resultKey = FakeSecureKey(33)..writeBuffer = Uint8List(20);

      when(mockCryptoService.secureAlloc(any)).thenReturn(resultKey);

      expect(
        CryptoUtils.concatSecure(mockCryptoService, [key1, key2, key3, key4]),
        same(resultKey),
      );

      verify(mockCryptoService.secureAlloc(20));
      expect(resultKey.writeBuffer!.sublist(0, 5), isUnlockedKey(1));
      expect(resultKey.writeBuffer!.sublist(5, 10), isUnlockedKey(2));
      expect(resultKey.writeBuffer!.sublist(10, 15), isUnlockedKey(3));
      expect(resultKey.writeBuffer!.sublist(15), isUnlockedKey(4));
    });

    test('split2 splits data at given offset', () {
      final testData = Uint8List.fromList(List.generate(13, (i) => i));

      final (split1, split2) = CryptoUtils.split2(testData, 7);
      expect(split1, List.generate(7, (i) => i));
      expect(split2, List.generate(6, (i) => i + 7));
    });

    test('split2Secure splits key at given offset', () {
      final mockCryptoService = MockCryptoService();

      final testKey = FakeSecureKey(0x42);

      when(mockCryptoService.secureCopy(any)).thenAnswer(
        (i) =>
            FakeSecureKey(0)
              ..writeBuffer = i.positionalArguments.single as Uint8List,
      );

      final (split1, split2) = CryptoUtils.split2Secure(
        mockCryptoService,
        testKey,
        3,
      );
      expect(
        split1,
        isA<FakeSecureKey>().having((m) => m.writeBuffer, 'writeBuffer', [
          0xDE,
          0xAD,
          0xBE,
        ]),
      );
      expect(
        split2,
        isA<FakeSecureKey>().having((m) => m.writeBuffer, 'writeBuffer', [
          0xEF,
          0x42,
        ]),
      );
    });

    test('uint32ToUint8List converts 32 bit integer to little endian', () {
      const testInt = 0x12345678;

      expect(CryptoUtils.uint32ToUint8List(testInt), [0x78, 0x56, 0x34, 0x12]);
    });

    test('uint8ListToUint32 converts 32 bit integer from little endian', () {
      final testBytes = Uint8List.fromList([0x78, 0x56, 0x34, 0x12]);

      expect(CryptoUtils.uint8ListToUint32(testBytes), 0x12345678);
    });
  });
}
