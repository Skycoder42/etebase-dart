import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../account_crypto_manager.dart';
import '../sync/account_crypto_manager_sync.dart';
import 'crypto_manager_async.dart';

@internal
final class AccountCryptoManagerAsync
    extends CryptoManagerAsync<AccountCryptoManagerSync>
    implements AccountCryptoManager {
  AccountCryptoManagerAsync(super.isolated, super.cmRef, super.version);

  @override
  Future<Uint8List> colTypeToUid(String colId) =>
      exec((cm, _, __) => cm.colTypeToUid(colId));

  @override
  Future<String> colTypeFromUid(Uint8List uid) =>
      exec((cm, _, __) => cm.colTypeFromUid(uid));
}
