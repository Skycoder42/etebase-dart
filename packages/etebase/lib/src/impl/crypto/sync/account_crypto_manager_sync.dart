import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../account_crypto_manager.dart';
import '../crypto_service.dart';
import 'collection_crypto_manager_sync.dart';
import 'crypto_manager_sync.dart';

@internal
final class AccountCryptoManagerSync extends CryptoManagerSync
    implements AccountCryptoManager {
  static const _colTypePadSize = 32;

  AccountCryptoManagerSync(super.sodium, super.key, super.version);

  @override
  String get context => 'Acct';

  @override
  Uint8List colTypeToUid(String colId) => deterministicEncrypt(
        sodium.pad(colId.toCharArray().unsignedView(), _colTypePadSize),
      );

  @override
  String colTypeFromUid(Uint8List uid) => sodium
      .unpad(deterministicDecrypt(uid), _colTypePadSize)
      .signedView()
      .toDartString();

  @override
  CollectionCryptoManagerSync createCollectionCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  }) =>
      CollectionCryptoManagerSync(sodium, this, key, version);
}
