import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium.dart';

import 'crypto_manager_base.dart';

@internal
class CryptoArena {
  final _disposables = <FutureOr<void> Function()>[];

  T call<T>(T object) {
    switch (object) {
      case final SecureKey key:
        _disposables.add(key.dispose);
      case final CryptoManagerBase cm:
        _disposables.add(cm.dispose);
      default:
        throw UnsupportedError(
          'Cannot auto-dispose an instance of ${object.runtimeType}',
        );
    }
    return object;
  }

  Future<void> dispose() async {
    for (final disposable in _disposables) {
      await disposable();
    }
  }
}
