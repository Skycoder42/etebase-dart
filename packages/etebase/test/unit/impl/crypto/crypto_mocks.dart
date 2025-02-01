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
  MockSpec<CryptoExecutor>(as: #MockCryptoExecutorBase),
])
import 'crypto_mocks.mocks.dart';

export 'crypto_mocks.mocks.dart';

class FakeSecureKey extends Fake implements SecureKey {
  final int id;

  bool disposed = false;

  FakeSecureKey(this.id);

  @override
  void dispose() => disposed = true;

  @override
  T runUnlockedSync<T>(SecureCallbackFn<T> callback, {bool writable = false}) =>
      callback(
        Uint8List.fromList([
          // prefix
          0xDE, 0xAD, 0xBE, 0xEF,
          // id
          id,
          // writable
          if (writable) 1 else 0,
        ]),
      );

  @override
  FutureOr<T> runUnlockedAsync<T>(
    SecureCallbackFn<FutureOr<T>> callback, {
    bool writable = false,
  }) =>
      callback(
        Uint8List.fromList([
          // prefix
          0xDE, 0xAD, 0xBE, 0xAD,
          // id
          id,
          // writable
          if (writable) 1 else 0,
        ]),
      );

  @override
  String toString() => 'FakeSecureKey($id)';
}

class MockCrypto extends MockCryptoBase {
  @override
  final MockKdf kdf = MockKdf();

  @override
  final MockAead aeadXChaCha20Poly1305IETF = MockAead();

  void resetAll() {
    reset(kdf);
    reset(aeadXChaCha20Poly1305IETF);
    reset(this);
  }
}

class MockSodium extends MockSodiumBase {
  @override
  final MockRandombytes randombytes = MockRandombytes();

  @override
  final MockCrypto crypto = MockCrypto();

  void resetAll() {
    reset(randombytes);
    crypto.resetAll();
    reset(this);

    provideDummy<SecureKey>(FakeSecureKey(-1));
  }
}

class MockCryptoExecutor extends MockCryptoExecutorBase {
  final MockSodium _mockSodium;

  MockCryptoExecutor(this._mockSodium);

  void setupMocks() {
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
  bool writable = false,
  bool async = false,
}) =>
    allOf(
      isA<Uint8List>(),
      equals([
        // prefix
        0xDE, 0xAD, 0xBE, if (async) 0xAD else 0xEF,
        // id
        id,
        // writable
        if (writable) 1 else 0,
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
