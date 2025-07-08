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

  void dispose() {
    _accountKey?.dispose();
  }

  Future<void> createKey() async {
    await _keystore.deleteStorageKey(_prefix);
    dispose();

    final masterKey = _sodium.crypto.kdf.keygen();
    try {
      await _keystore.saveStorageKey(masterKey, _prefix);
      _deriveKeys(masterKey);
    } finally {
      masterKey.dispose();
    }
  }

  Future<void> loadKey() async {
    dispose();
    final masterKey = await _keystore.loadStorageKey(_prefix);
    try {
      _deriveKeys(masterKey);
    } finally {
      masterKey.dispose();
    }
  }

  Future<void> discardKey() async {
    dispose();
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
