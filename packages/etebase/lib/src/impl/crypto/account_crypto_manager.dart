import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'collection_crypto_manager.dart';
import 'crypto_manager.dart';

@internal
class AccountCryptoManager extends CryptoManager {
  static const _colTypePadSize = 32;

  AccountCryptoManager(super.executor, super.key, super.version);

  @override
  @visibleForOverriding
  @visibleForTesting
  String get context => 'Acct';

  Uint8List colTypeToUid(String colId) => deterministicEncrypt(
    executor.execSync(
      (sodium) =>
          sodium.pad(colId.toCharArray().unsignedView(), _colTypePadSize),
    ),
  );

  String colTypeFromUid(Uint8List uid) {
    final paddedColType = deterministicDecrypt(uid);
    return executor.execSync(
      (sodium) =>
          sodium
              .unpad(paddedColType, _colTypePadSize)
              .signedView()
              .toDartString(),
    );
  }

  CollectionCryptoManager createCollectionCryptoManager(
    SecureKey key, {
    int? version,
  }) => CollectionCryptoManager(executor, this, key, version ?? this.version);
}
