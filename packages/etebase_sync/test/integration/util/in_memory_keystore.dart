import 'package:etebase_sync/etebase_sync.dart';
import 'package:sodium/sodium_sumo.dart';

class InMemoryKeystore implements Keystore {
  SecureKey? _key;

  @override
  Future<void> dispose() => Future.sync(() => _key?.dispose());

  @override
  Future<void> deleteStorageKey([String? prefix]) => Future.sync(() {
    _key?.dispose();
    _key = null;
  });

  @override
  Future<SecureKey?> loadStorageKey([String? prefix]) => Future.value(_key);

  @override
  Future<void> saveStorageKey(SecureKey key, [String? prefix]) =>
      Future.sync(() => _key = key);
}
