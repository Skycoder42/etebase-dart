import 'dart:async';
import 'dart:typed_data';

import 'package:etebase/src/api/exceptions/crypto_failure.dart';
import 'package:etebase/src/api/managers/crypto_executor.dart';
import 'package:etebase/src/impl/crypto/executors/sync_crypto_executor.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<SodiumSumo>()])
import 'sync_crypto_executor_test.mocks.dart';

class FakeSecureKey extends Fake implements SecureKey {}

void main() {
  group('$SyncCryptoExecutor', () {
    final mockSodiumSumo = MockSodiumSumo();

    late SyncCryptoExecutor sut;

    setUp(() {
      reset(mockSodiumSumo);

      sut = SyncCryptoExecutor(mockSodiumSumo);
    });

    test('dispose does nothing', () {
      sut.dispose();

      verifyZeroInteractions(mockSodiumSumo);
    });

    group('execSync', () {
      test('runs callback synchronously', () {
        final result = sut.execSync((sodium) {
          expect(sodium, same(mockSodiumSumo));
          return true;
        });

        expect(result, isTrue);

        verifyZeroInteractions(mockSodiumSumo);
      });

      test('wraps sodium exception as crypto failure', () {
        expect(
          () => sut.execSync((_) => throw SodiumException()),
          throwsA(isA<CryptoFailure>()),
        );
      });
    });

    group('execAsync', () {
      setUp(() async {
        when(
          mockSodiumSumo.runIsolated<bool>(
            any,
            secureKeys: anyNamed('secureKeys'),
            keyPairs: anyNamed('keyPairs'),
          ),
        ).thenAnswer(
          (i) async => Future(
            () => (i.positionalArguments.single as AsyncCallback<bool>).call(
              mockSodiumSumo,
              i.namedArguments[#secureKeys] as List<SecureKey>,
              i.namedArguments[#keyPairs] as List<KeyPair>,
            ),
          ),
        );
      });

      test('runs callback asynchronously', () async {
        var isInvokedLater = false;

        bool callback(SodiumSumo sodium, _, __) {
          expect(sodium, same(mockSodiumSumo));
          return isInvokedLater;
        }

        final future = sut.execAsync<bool>(callback);

        verify(mockSodiumSumo.runIsolated<bool>(callback));

        expect(future, completion(isTrue));
        isInvokedLater = true;
      });

      test('runs callback asynchronously with keys and key pairs', () async {
        final secureKeys = [FakeSecureKey(), FakeSecureKey()];
        final keyPairs = [
          KeyPair(publicKey: Uint8List(0), secretKey: FakeSecureKey()),
          KeyPair(publicKey: Uint8List(1), secretKey: FakeSecureKey()),
        ];

        bool callback(SodiumSumo sodium, List<SecureKey> sk, List<KeyPair> kp) {
          expect(sk, secureKeys);
          expect(kp, keyPairs);
          return true;
        }

        final future = sut.execAsync<bool>(
          callback,
          secureKeys: secureKeys,
          keyPairs: keyPairs,
        );
        expect(future, completion(isTrue));

        verify(
          mockSodiumSumo.runIsolated<bool>(
            callback,
            secureKeys: secureKeys,
            keyPairs: keyPairs,
          ),
        );
      });

      test('wraps sodium exception as crypto failure', () async {
        expect(
          () => sut.execAsync<bool>((_, __, ___) => throw SodiumException()),
          throwsA(isA<CryptoFailure>()),
        );
      });
    });

    group('exec', () {
      test('runs callback synchronously', () async {
        var isInvokedLater = false;

        bool callback(SodiumSumo sodium, _, __) {
          expect(sodium, same(mockSodiumSumo));
          return isInvokedLater;
        }

        final result = sut.exec<bool>(callback);
        isInvokedLater = true;

        verifyZeroInteractions(mockSodiumSumo);

        expect(result, isFalse);
      });

      test('runs callback synchronously with keys and key pairs', () async {
        final secureKeys = [FakeSecureKey(), FakeSecureKey()];
        final keyPairs = [
          KeyPair(publicKey: Uint8List(0), secretKey: FakeSecureKey()),
          KeyPair(publicKey: Uint8List(1), secretKey: FakeSecureKey()),
        ];

        bool callback(SodiumSumo sodium, List<SecureKey> sk, List<KeyPair> kp) {
          expect(sk, secureKeys);
          expect(kp, keyPairs);
          return true;
        }

        final result = sut.exec<bool>(
          callback,
          secureKeys: secureKeys,
          keyPairs: keyPairs,
        );
        expect(result, isTrue);

        verifyZeroInteractions(mockSodiumSumo);
      });

      test('wraps sodium exception as crypto failure', () async {
        expect(
          () => sut.exec<bool>((_, __, ___) => throw SodiumException()),
          throwsA(isA<CryptoFailure>()),
        );
      });
    });
  });
}
