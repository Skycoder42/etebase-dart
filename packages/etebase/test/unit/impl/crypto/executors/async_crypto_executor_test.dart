@TestOn('dart-vm')
library;

import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:etebase/src/api/exceptions/async_crypto_executor_isolate_failure.dart';
import 'package:etebase/src/api/exceptions/crypto_failure.dart';
import 'package:etebase/src/api/managers/crypto_executor.dart';
import 'package:etebase/src/impl/crypto/executors/async_crypto_executor.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([
  MockSpec<SodiumSumo>(),
])
import 'async_crypto_executor_test.mocks.dart';

class FakeSecureKey extends Fake implements SecureKey {
  final int id;
  bool disposed = false;

  FakeSecureKey(this.id);

  @override
  void dispose() => disposed = true;

  @override
  String toString() => 'FakeSecureKey($id, disposed:$disposed)';
}

class FakeTransferrableSecureKey extends Fake
    implements TransferrableSecureKey {
  final int id;

  FakeTransferrableSecureKey(this.id);
}

class FakeTransferrableKeyPair extends Fake implements TransferrableKeyPair {
  final Uint8List pub;
  final int priv;

  FakeTransferrableKeyPair(this.pub, this.priv);
}

void _createTransferMocks(MockSodiumSumo mockSodiumSumo) {
  provideDummy(
    KeyPair(publicKey: Uint8List(0), secretKey: FakeSecureKey(-1)),
  );

  when(mockSodiumSumo.createTransferrableSecureKey(any)).thenAnswer(
    (i) => FakeTransferrableSecureKey(
      (i.positionalArguments.single as FakeSecureKey).id,
    ),
  );
  when(mockSodiumSumo.createTransferrableKeyPair(any)).thenAnswer(
    (i) => FakeTransferrableKeyPair(
      (i.positionalArguments.single as KeyPair).publicKey,
      ((i.positionalArguments.single as KeyPair).secretKey as FakeSecureKey).id,
    ),
  );
  when(mockSodiumSumo.materializeTransferrableSecureKey(any)).thenAnswer(
    (i) => FakeSecureKey(
      (i.positionalArguments.single as FakeTransferrableSecureKey).id,
    ),
  );
  when(mockSodiumSumo.materializeTransferrableKeyPair(any)).thenAnswer(
    (i) => KeyPair(
      publicKey: (i.positionalArguments.single as FakeTransferrableKeyPair).pub,
      secretKey: FakeSecureKey(
        (i.positionalArguments.single as FakeTransferrableKeyPair).priv,
      ),
    ),
  );
}

void main() {
  group('$AsyncCryptoExecutor', () {
    final mockSodiumSumo = MockSodiumSumo();

    late AsyncCryptoExecutor sut;

    setUp(() {
      reset(mockSodiumSumo);

      _createTransferMocks(mockSodiumSumo);
      when(mockSodiumSumo.isolateFactory).thenReturn(() async {
        final mock = MockSodiumSumo();
        _createTransferMocks(mock);
        return mock;
      });

      sut = AsyncCryptoExecutor(mockSodiumSumo);
    });

    test('initialize spawns isolate with correct error handling', () async {
      Object? error;
      StackTrace? stackTrace;
      await runZonedGuarded(
        () async {
          await sut.initialize();
          await sut.execAsync<void>((_, __, ___) {
            scheduleMicrotask(() {
              throw Exception('Test Exception');
            });
          });
          await Future<void>.delayed(const Duration(seconds: 1));
        },
        (e, s) {
          error = e;
          stackTrace = s;
        },
      );

      expect(
        error,
        isA<AsyncCryptoExecutorIsolateFailure>().having(
          (m) => m.originalMessage,
          'originalMessage',
          contains('Test Exception'),
        ),
      );
      expect(stackTrace, isNotNull);
    });

    test('dispose stops isolate and waits for finish', () async {
      await sut.initialize();

      await sut.execAsync((_, __, ___) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => throw Exception('Isolate not disposed!'),
        );
      });

      await sut.dispose();

      await Future<void>.delayed(const Duration(seconds: 1));

      expect(
        () => sut.execAsync((_, __, ___) => false),
        throwsA(isStateError),
      );
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
        await sut.initialize();
      });

      tearDown(() async {
        await sut.dispose();
      });

      test('runs callback on different isolate', () async {
        int callback(SodiumSumo sodium, _, __) {
          if (sodium is MockSodiumSumo) {
            return Isolate.current.hashCode;
          } else {
            throw Exception('sodium instance is not identical');
          }
        }

        final future = sut.execAsync<int>(callback);

        expect(future, completion(isNot(Isolate.current.hashCode)));
      });

      test('runs multiple invocations on same isolate', () async {
        int callback(SodiumSumo sodium, _, __) {
          if (sodium is MockSodiumSumo) {
            return Isolate.current.hashCode;
          } else {
            throw Exception('sodium instance is not identical');
          }
        }

        final results = await Future.wait([
          for (var i = 0; i < 5; ++i) sut.execAsync<int>(callback),
        ]);

        final first = results.removeAt(0);
        expect(results, everyElement(first));
      });

      test('runs correct result for every invocation', () async {
        AsyncCallback<int> createCb(int ctr) => (sodium, _, __) => ctr;

        final results = <Future<int>>[];
        for (var i = 0; i < 5; ++i) {
          final value = i;

          results.add(sut.execAsync(createCb(value)));
        }

        expect(Future.wait(results), completion([0, 1, 2, 3, 4]));
      });

      test('runs callback with keys and key pairs', () async {
        bool callback(
          SodiumSumo sodium,
          List<SecureKey> sk,
          List<KeyPair> kp,
        ) {
          // ensure keys get disposed
          scheduleMicrotask(() {
            final allKeys = sk
                .followedBy(kp.map((kp) => kp.secretKey))
                .cast<FakeSecureKey>();
            for (final key in allKeys) {
              if (!key.disposed) {
                throw Exception('Key $key was not disposed!');
              }
            }
          });

          if (sk
              case [
                FakeSecureKey(id: 1, disposed: false),
                FakeSecureKey(id: 2, disposed: false)
              ]) {
            // ok
          } else {
            throw Exception('Unexpected value for sk: $sk');
          }

          if (kp
              case [
                KeyPair(
                  publicKey: [3],
                  secretKey: FakeSecureKey(id: 4, disposed: false)
                ),
                KeyPair(
                  publicKey: [5],
                  secretKey: FakeSecureKey(id: 6, disposed: false)
                ),
              ]) {
            // ok
          } else {
            throw Exception('Unexpected value for kp: $kp');
          }

          return true;
        }

        final secureKeys = [FakeSecureKey(1), FakeSecureKey(2)];
        final keyPairs = [
          KeyPair(
            publicKey: Uint8List.fromList([3]),
            secretKey: FakeSecureKey(4),
          ),
          KeyPair(
            publicKey: Uint8List.fromList([5]),
            secretKey: FakeSecureKey(6),
          ),
        ];

        final future = sut.execAsync<bool>(
          callback,
          secureKeys: secureKeys,
          keyPairs: keyPairs,
        );

        expect(future, completion(isTrue));

        // return to event loop for errors from isolate to propagate
        await Future<void>.delayed(Duration.zero);

        for (final k in secureKeys) {
          expect(k.disposed, isFalse);
        }
        for (final k in keyPairs) {
          expect((k.secretKey as FakeSecureKey).disposed, isFalse);
        }
      });

      test('returns copy of byte arrays', () async {
        Uint8List callback(SodiumSumo sodium, _, __) =>
            Uint8List.fromList([47, 11]);

        final result = await sut.execAsync(callback);

        expect(result, [47, 11]);
      });

      test('returns secure key as transferrable key', () async {
        SecureKey callback(SodiumSumo sodium, _, __) {
          final key = FakeSecureKey(42);
          // ensure key gets disposed
          scheduleMicrotask(() {
            if (!key.disposed) {
              throw Exception('Key $key was not disposed!');
            }
          });
          return key;
        }

        final result = await sut.execAsync(callback);

        // return to event loop for errors from isolate to propagate
        await Future<void>.delayed(Duration.zero);

        expect(
          result,
          isA<FakeSecureKey>()
              .having((m) => m.id, 'id', 42)
              .having((m) => m.disposed, 'disposed', isFalse),
        );
      });

      test('returns key pair as transferrable key pair', () async {
        KeyPair callback(SodiumSumo sodium, _, __) {
          final key = KeyPair(
            publicKey: Uint8List.fromList([1, 21]),
            secretKey: FakeSecureKey(11),
          );
          // ensure key gets disposed
          scheduleMicrotask(() {
            if (!(key.secretKey as FakeSecureKey).disposed) {
              throw Exception('Key $key was not disposed!');
            }
          });
          return key;
        }

        final result = await sut.execAsync(callback);

        // return to event loop for errors from isolate to propagate
        await Future<void>.delayed(Duration.zero);

        expect(
          result,
          isA<KeyPair>()
              .having(
                (m) => m.publicKey,
                'publicKey',
                equals([1, 21]),
              )
              .having(
                (m) => m.secretKey,
                'secretKey',
                isA<FakeSecureKey>()
                    .having((m) => m.id, 'id', 11)
                    .having((m) => m.disposed, 'disposed', isFalse),
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
      setUp(() async {
        await sut.initialize();
      });

      tearDown(() async {
        await sut.dispose();
      });

      test('runs callback on different isolate', () async {
        int callback(SodiumSumo sodium, _, __) {
          if (sodium is MockSodiumSumo) {
            return Isolate.current.hashCode;
          } else {
            throw Exception('sodium instance is not identical');
          }
        }

        final future = sut.exec<int>(callback);

        expect(future, completion(isNot(Isolate.current.hashCode)));
      });

      test('runs multiple invocations on same isolate', () async {
        int callback(SodiumSumo sodium, _, __) {
          if (sodium is MockSodiumSumo) {
            return Isolate.current.hashCode;
          } else {
            throw Exception('sodium instance is not identical');
          }
        }

        final results = await Future.wait([
          for (var i = 0; i < 5; ++i) sut.exec<int>(callback),
        ]);

        final first = results.removeAt(0);
        expect(results, everyElement(first));
      });

      test('runs correct result for every invocation', () async {
        AsyncCallback<int> createCb(int ctr) => (sodium, _, __) => ctr;

        final results = <Future<int>>[];
        for (var i = 0; i < 5; ++i) {
          final value = i;

          results.add(sut.exec(createCb(value)));
        }

        expect(Future.wait(results), completion([0, 1, 2, 3, 4]));
      });

      test('runs callback with keys and key pairs', () async {
        bool callback(
          SodiumSumo sodium,
          List<SecureKey> sk,
          List<KeyPair> kp,
        ) {
          // ensure keys get disposed
          scheduleMicrotask(() {
            final allKeys = sk
                .followedBy(kp.map((kp) => kp.secretKey))
                .cast<FakeSecureKey>();
            for (final key in allKeys) {
              if (!key.disposed) {
                throw Exception('Key $key was not disposed!');
              }
            }
          });

          if (sk
              case [
                FakeSecureKey(id: 1, disposed: false),
                FakeSecureKey(id: 2, disposed: false)
              ]) {
            // ok
          } else {
            throw Exception('Unexpected value for sk: $sk');
          }

          if (kp
              case [
                KeyPair(
                  publicKey: [3],
                  secretKey: FakeSecureKey(id: 4, disposed: false)
                ),
                KeyPair(
                  publicKey: [5],
                  secretKey: FakeSecureKey(id: 6, disposed: false)
                ),
              ]) {
            // ok
          } else {
            throw Exception('Unexpected value for kp: $kp');
          }

          return true;
        }

        final secureKeys = [FakeSecureKey(1), FakeSecureKey(2)];
        final keyPairs = [
          KeyPair(
            publicKey: Uint8List.fromList([3]),
            secretKey: FakeSecureKey(4),
          ),
          KeyPair(
            publicKey: Uint8List.fromList([5]),
            secretKey: FakeSecureKey(6),
          ),
        ];

        final future = sut.exec<bool>(
          callback,
          secureKeys: secureKeys,
          keyPairs: keyPairs,
        );

        expect(future, completion(isTrue));

        // return to event loop for errors from isolate to propagate
        await Future<void>.delayed(Duration.zero);

        for (final k in secureKeys) {
          expect(k.disposed, isFalse);
        }
        for (final k in keyPairs) {
          expect((k.secretKey as FakeSecureKey).disposed, isFalse);
        }
      });

      test('returns copy of byte arrays', () async {
        Uint8List callback(SodiumSumo sodium, _, __) =>
            Uint8List.fromList([47, 11]);

        final result = await sut.execAsync(callback);

        expect(result, [47, 11]);
      });

      test('returns secure key as transferrable key', () async {
        SecureKey callback(SodiumSumo sodium, _, __) {
          final key = FakeSecureKey(42);
          // ensure key gets disposed
          scheduleMicrotask(() {
            if (!key.disposed) {
              throw Exception('Key $key was not disposed!');
            }
          });
          return key;
        }

        final result = await sut.exec(callback);

        // return to event loop for errors from isolate to propagate
        await Future<void>.delayed(Duration.zero);

        expect(
          result,
          isA<FakeSecureKey>()
              .having((m) => m.id, 'id', 42)
              .having((m) => m.disposed, 'disposed', isFalse),
        );
      });

      test('returns key pair as transferrable key pair', () async {
        KeyPair callback(SodiumSumo sodium, _, __) {
          final key = KeyPair(
            publicKey: Uint8List.fromList([1, 21]),
            secretKey: FakeSecureKey(11),
          );
          // ensure key gets disposed
          scheduleMicrotask(() {
            if (!(key.secretKey as FakeSecureKey).disposed) {
              throw Exception('Key $key was not disposed!');
            }
          });
          return key;
        }

        final result = await sut.exec(callback);

        // return to event loop for errors from isolate to propagate
        await Future<void>.delayed(Duration.zero);

        expect(
          result,
          isA<KeyPair>()
              .having(
                (m) => m.publicKey,
                'publicKey',
                equals([1, 21]),
              )
              .having(
                (m) => m.secretKey,
                'secretKey',
                isA<FakeSecureKey>()
                    .having((m) => m.id, 'id', 11)
                    .having((m) => m.disposed, 'disposed', isFalse),
              ),
        );
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
