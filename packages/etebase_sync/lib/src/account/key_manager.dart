import 'package:etebase/etebase.dart';
import 'package:sodium/sodium.dart';

import 'keystore.dart';

class KeyManager {
  static const accountKeyId = 1;

  final Keystore _keystore;
  final Sodium _sodium;
  final String? _prefix;

  SecureKey? _accountKey;

  KeyManager(this._keystore, this._sodium, [this._prefix]);

  SecureKey get accountKey => _accountKey!;

  Future<void> dispose() async {
    _accountKey?.dispose();
    await _keystore.dispose();
  }

  Future<void> createKey() async {
    await discardKey();

    final masterKey = _sodium.crypto.kdf.keygen();
    try {
      await _keystore.saveStorageKey(masterKey, _prefix);
      _deriveKeys(masterKey);
    } finally {
      masterKey.dispose();
    }
  }

  Future<void> loadKey() async {
    _accountKey?.dispose();
    _accountKey = null;

    final masterKey = await _keystore.loadStorageKey(_prefix);
    if (masterKey == null) {
      throw UnimplementedError(); // TODO real exception
    }
    try {
      _deriveKeys(masterKey);
    } finally {
      masterKey.dispose();
    }
  }

  Future<void> discardKey() async {
    _accountKey?.dispose();
    _accountKey = null;
    await _keystore.deleteStorageKey(_prefix);
  }

  void _deriveKeys(SecureKey masterKey) {
    _accountKey = _subkey(masterKey, accountKeyId, Account.cacheKeyLength);
  }

  SecureKey _subkey(SecureKey masterKey, int keyId, int length) =>
      _sodium.crypto.kdf.deriveFromKey(
        masterKey: masterKey,
        context: 'etb_sync',
        subkeyId: BigInt.from(keyId),
        subkeyLen: length,
      );
}
