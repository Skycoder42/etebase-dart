import 'dart:typed_data';

import 'package:etebase/src/impl/crypto/crypto_arena.dart';
import 'package:etebase/src/impl/crypto/crypto_manager_base.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium.dart';
import 'package:test/test.dart';

import 'crypto_mocks.dart';

// ignore: directives_ordering
@GenerateNiceMocks([MockSpec<CryptoManagerBase>()])
import 'crypto_arena_test.mocks.dart';

void main() {
  group('$CryptoArena', () {
    late CryptoArena sut;

    setUp(() {
      sut = CryptoArena();
    });

    group('attached entities are disposed', () {
      test('secure key', () {
        final key = FakeSecureKey(1);

        expect(sut(key), same(key));
        expect(key.disposed, isFalse);

        sut.dispose();
        expect(key.disposed, isTrue);
      });

      test('key pair', () {
        final secretKey = FakeSecureKey(1);
        final keyPair = KeyPair(publicKey: Uint8List(0), secretKey: secretKey);

        expect(sut(keyPair), same(keyPair));
        expect(secretKey.disposed, isFalse);

        sut.dispose();
        expect(secretKey.disposed, isTrue);
      });

      test('secure key tuple', () {
        final key1 = FakeSecureKey(1);
        final key2 = FakeSecureKey(2);

        expect(sut((key1, key2)), (key1, key2));
        expect(key1.disposed, isFalse);
        expect(key2.disposed, isFalse);

        sut.dispose();
        expect(key1.disposed, isTrue);
        expect(key1.disposed, isTrue);
      });

      test('crypto manager', () {
        final manager = MockCryptoManagerBase();

        expect(sut(manager), same(manager));
        verifyZeroInteractions(manager);

        sut.dispose();
        verify(manager.dispose());
      });

      test('throws for unknown type', () {
        expect(() => sut(42), throwsA(isUnsupportedError));
      });

      test('can handle multiple different attachments', () {
        final key1 = FakeSecureKey(1);
        final key2 = FakeSecureKey(2);
        final key3 = FakeSecureKey(3);

        sut(key1);
        sut(key2);
        sut(KeyPair(publicKey: Uint8List(0), secretKey: key3));

        sut.dispose();

        expect(key1.disposed, isTrue);
        expect(key2.disposed, isTrue);
        expect(key3.disposed, isTrue);
      });

      test('disposes only once', () {
        final key = FakeSecureKey(1);

        sut(key);
        sut.dispose();

        expect(key.disposed, isTrue);

        key.disposed = false;
        sut.dispose();

        expect(key.disposed, isFalse);
      });
    });

    group('detach', () {
      test('removes previously attached entities', () {
        final key = FakeSecureKey(1);

        sut(key);
        expect(sut.detach(key), same(key));
        sut.dispose();

        expect(key.disposed, isFalse);
      });

      test('asserts when trying to detach something that is not attached', () {
        expect(
          () => sut.detach(FakeSecureKey(22)),
          throwsA(isA<AssertionError>()),
        );
      });
    });
  });
}
