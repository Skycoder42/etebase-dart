import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'account_crypto_manager.dart';
import 'crypto_manager.dart';
import 'crypto_manager_sync.dart';

@internal
final class AccountCryptoManagerSync extends CryptoManagerSync
    implements AccountCryptoManager {
  static const _colTypePadSize = 32;

  AccountCryptoManagerSync(super.sodium, super.key, super.version);

  @override
  Uint8List colTypeToUid(String colId) => deterministicEncrypt(null);

  @override
  String colTypeFromUid(Uint8List uid);
}
