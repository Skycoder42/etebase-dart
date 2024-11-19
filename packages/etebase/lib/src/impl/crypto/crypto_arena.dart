import 'package:meta/meta.dart';
import 'package:sodium/sodium.dart';

import 'crypto_manager_base.dart';

@internal
class CryptoArena {
  final _disposables = <Object, void Function()>{};

  T call<T>(T object) {
    switch (object) {
      case final SecureKey key:
        _disposables[object] = key.dispose;
      case (final SecureKey k1, final SecureKey k2):
        _disposables[object] = k1.dispose;
        _disposables[object] = k2.dispose;
      case final CryptoManagerBase cm:
        _disposables[object] = cm.dispose;
      default:
        throw UnsupportedError(
          'Cannot auto-dispose an instance of ${object.runtimeType}',
        );
    }
    return object;
  }

  T detach<T>(T object) {
    final removed = _disposables.remove(object);
    assert(removed != null, 'Tried to detach an unattached object');
    return object;
  }

  void dispose() {
    for (final disposable in _disposables.values) {
      disposable();
    }
    _disposables.clear();
  }
}
