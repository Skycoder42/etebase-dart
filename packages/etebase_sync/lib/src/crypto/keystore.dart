import 'dart:async';

import 'package:sodium/sodium.dart';

abstract interface class Keystore {
  Future<SecureKey> loadStorageKey([String? prefix]);

  Future<void> saveStorageKey(SecureKey key, [String? prefix]);

  Future<void> deleteStorageKey([String? prefix]);
}
