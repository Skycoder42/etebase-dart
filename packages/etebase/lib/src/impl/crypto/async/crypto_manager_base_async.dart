import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:synchronized/synchronized.dart';

import '../crypto_manager_base.dart';
import 'isolated_crypto_manager.dart';

@internal
abstract base class CryptoManagerBaseAsync<
    TCryptoManager extends CryptoManagerBaseSync> implements CryptoManagerBase {
  @protected
  final IsolatedCryptoManager isolated;

  CryptoManagerRef<TCryptoManager>? _cmRef;
  final _cmRefLock = Lock();

  CryptoManagerBaseAsync(this.isolated);

  @protected
  Future<CryptoManagerRef<TCryptoManager>> get cmRef => _cmRefLock.synchronized(
        () async => _cmRef ??= await initSync(),
      );

  @override
  @mustCallSuper
  Future<void> dispose() => _cmRefLock.synchronized(() async {
        if (_cmRef case final CryptoManagerRef cmRef) {
          await isolated.disposeCryptoManager(cmRef);
        }
      });

  @visibleForOverriding
  Future<CryptoManagerRef<TCryptoManager>> initSync();

  @protected
  @nonVirtual
  @useResult
  Future<TResult> exec<TResult>(
    TResult Function(
      TCryptoManager cm,
      List<SecureKey> secureKey,
      List<KeyPair> keyPairs,
    ) callback, {
    List<SecureKey> secureKey = const [],
    List<KeyPair> keyPairs = const [],
  }) async =>
      isolated(
        await cmRef,
        callback,
        secureKeys: secureKey,
        keyPairs: keyPairs,
      );
}
