// ignore_for_file: discarded_futures

import 'dart:async';
import 'dart:typed_data';

import 'package:etebase/src/api/managers/crypto_executor.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([
  MockSpec<SodiumSumo>(as: #MockSodiumBase),
  MockSpec<Randombytes>(),
  MockSpec<CryptoSumo>(as: #MockCryptoBase),
  MockSpec<Kdf>(),
  MockSpec<Aead>(),
  MockSpec<GenericHash>(),
  MockSpec<Box>(),
  MockSpec<CryptoExecutor>(as: #MockCryptoExecutorBase),
])
import 'crypto_mocks.mocks.dart';

export 'crypto_mocks.mocks.dart';

class FakeGenericHashConsumer extends Fake implements GenericHashConsumer {}

class FakeSecureKey extends Fake implements SecureKey {
  final int id;

  bool disposed = false;
  Uint8List? writeBuffer;

  FakeSecureKey(this.id);

  @override
  void dispose() => disposed = true;

  @override
  int get length => 5;

  @override
  T runUnlockedSync<T>(SecureCallbackFn<T> callback, {bool writable = false}) {
    if (writable) {
      return callback(writeBuffer!);
    } else {
      return callback(
        Uint8List.fromList([
          // prefix
          0xDE, 0xAD, 0xBE, 0xEF,
          // id
          id,
        ]),
      );
    }
  }

  @override
  FutureOr<T> runUnlockedAsync<T>(
    SecureCallbackFn<FutureOr<T>> callback, {
    bool writable = false,
  }) {
    if (writable) {
      return callback(writeBuffer!);
    } else {
      return callback(
        Uint8List.fromList([
          // prefix
          0xDE, 0xAD, 0xBE, 0xAD,
          // id
          id,
        ]),
      );
    }
  }

  @override
  String toString() => 'FakeSecureKey($id)';
}

class MockCrypto extends MockCryptoBase {
  @override
  final MockKdf kdf = MockKdf();

  @override
  final MockAead aeadXChaCha20Poly1305IETF = MockAead();

  @override
  final MockGenericHash genericHash = MockGenericHash();

  @override
  final MockBox box = MockBox();

  void resetAll() {
    reset(kdf);
    reset(aeadXChaCha20Poly1305IETF);
    reset(genericHash);
    reset(box);
    reset(this);
  }
}

class MockSodium extends MockSodiumBase {
  @override
  final MockRandombytes randombytes = MockRandombytes();

  @override
  final MockCrypto crypto = MockCrypto();

  void resetAndSetup() {
    reset(randombytes);
    crypto.resetAll();
    reset(this);

    provideDummy<SecureKey>(FakeSecureKey(-1));
    provideDummy<KeyPair>(
      KeyPair(publicKey: Uint8List(0), secretKey: FakeSecureKey(-1)),
    );
    provideDummy(
      DetachedCipherResult(cipherText: Uint8List(0), mac: Uint8List(0)),
    );
    provideDummy<GenericHashConsumer>(FakeGenericHashConsumer());

    when(
      crypto.kdf.deriveFromKey(
        masterKey: anyNamed('masterKey'),
        context: anyNamed('context'),
        subkeyId: anyNamed('subkeyId'),
        subkeyLen: anyNamed('subkeyLen'),
      ),
    ).thenAnswer((i) {
      final {#subkeyId: BigInt subkeyId} = i.namedArguments;
      return FakeSecureKey(subkeyId.toInt());
    });
  }
}

class MockCryptoExecutor extends MockCryptoExecutorBase {
  final MockSodium _mockSodium;

  MockCryptoExecutor(this._mockSodium);

  void resetAndSetup() {
    reset(this);

    when(execSync<dynamic>(any)).thenAnswer((i) {
      final [SyncCallback<dynamic> cb] = i.positionalArguments;
      return cb(_mockSodium);
    });

    when(
      execAsync<dynamic>(
        any,
        secureKeys: anyNamed('secureKeys'),
        keyPairs: anyNamed('keyPairs'),
      ),
    ).thenAnswer((i) {
      final [AsyncCallback<dynamic> cb] = i.positionalArguments;
      final {
        #secureKeys: List<SecureKey> secureKeys,
        #keyPairs: List<KeyPair> keyPairs,
      } = i.namedArguments;
      return Future.value(cb(_mockSodium, secureKeys, keyPairs));
    });

    when(
      exec<dynamic>(
        any,
        secureKeys: anyNamed('secureKeys'),
        keyPairs: anyNamed('keyPairs'),
      ),
    ).thenAnswer((i) {
      final [AsyncCallback<dynamic> cb] = i.positionalArguments;
      final {
        #secureKeys: List<SecureKey> secureKeys,
        #keyPairs: List<KeyPair> keyPairs,
      } = i.namedArguments;
      return cb(_mockSodium, secureKeys, keyPairs);
    });
  }
}

TypeMatcher<FakeSecureKey> isKey(dynamic id, {dynamic disposed}) {
  var matcher = isA<FakeSecureKey>().having((m) => m.id, 'id', id);
  if (disposed != null) {
    matcher = matcher.having((m) => m.disposed, 'disposed', disposed);
  }
  return matcher;
}

Matcher isUnlockedKey(
  dynamic id, {
  bool async = false,
}) =>
    allOf(
      isA<Uint8List>(),
      equals([
        // prefix
        0xDE, 0xAD, 0xBE, if (async) 0xAD else 0xEF,
        // id
        id,
      ]),
    );

Matcher concatenated(List<int> first, List<int> second) => allOf(
      isA<Uint8List>().having(
        (m) => m.length,
        'length',
        first.length + second.length,
      ),
      equals([...first, ...second]),
    );
