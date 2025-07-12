import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';
import 'package:sodium/sodium.dart';

import '../exceptions/account_locked.dart';
import 'keystore.dart';

@internal
class KeyManager {
  static const accountKeyId = 1;

  final Keystore _keystore;
  final Client _client;
  final String? _prefix;

  SecureKey? _accountKey;

  KeyManager(this._keystore, this._client, [this._prefix]);

  SecureKey get accountKey => _accountKey!;

  Future<void> dispose() async {
    _accountKey?.dispose();
    await _keystore.dispose();
  }

  Future<void> createKey() async {
    await discardKey();

    final key = _client.randomKey(Account.cacheKeyLength);
    try {
      await _keystore.saveStorageKey(key, _prefix);
      _accountKey = key;
    } catch (_) {
      key.dispose();
      rethrow;
    }
  }

  Future<void> loadKey() async {
    _accountKey?.dispose();
    _accountKey = null;

    _accountKey = await _keystore.loadStorageKey(_prefix);
    if (_accountKey == null) {
      throw AccountLocked();
    }
  }

  Future<void> discardKey() async {
    _accountKey?.dispose();
    _accountKey = null;
    await _keystore.deleteStorageKey(_prefix);
  }
}
