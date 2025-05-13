import 'dart:typed_data';

import 'package:etebase/src/api/managers/etebase_utils.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/managers/client.dart';
import 'package:etebase/src/impl/managers/utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../impl/crypto/crypto_mocks.dart';

// ignore: directives_ordering
@GenerateNiceMocks([MockSpec<Client>(), MockSpec<CryptoService>()])
import 'etebase_utils_test.mocks.dart';

void main() {
  group('$Utils', () {
    final mockClient = MockClient();
    final mockCryptoService = MockCryptoService();

    setUp(() {
      reset(mockClient);
      reset(mockCryptoService);

      when(mockClient.crypto).thenReturn(mockCryptoService);
    });

    test('randombytes returns crypto randomBytes', () {
      const testSize = 12;
      final testBytes = Uint8List.fromList([43, 44, 1]);
      when(mockCryptoService.randomBytes(any)).thenReturn(testBytes);

      final result = EtebaseUtils.randombytes(mockClient, testSize);

      expect(result, testBytes);

      verify(mockCryptoService.randomBytes(testSize)).called(1);
    });

    test('randomKey returns crypto secureRandom', () {
      const testSize = 12;
      final testKey = FakeSecureKey(22);
      when(mockCryptoService.secureRandom(any)).thenReturn(testKey);

      final result = EtebaseUtils.randomKey(mockClient, testSize);

      expect(result, testKey);

      verify(mockCryptoService.secureRandom(testSize)).called(1);
    });

    test('prettyFingerprint returns crypto prettyFingerprint', () {
      final testBytes = Uint8List.fromList([43, 44, 1]);
      const testFingerprint = 'test-fingerprint';
      when(
        mockCryptoService.prettyFingerprint(any),
      ).thenReturn(testFingerprint);

      final result = EtebaseUtils.prettyFingerprint(mockClient, testBytes);

      expect(result, testFingerprint);

      verify(mockCryptoService.prettyFingerprint(testBytes)).called(1);
    });
  });
}
