import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'collection_crypto_manager.dart';
import 'crypto_manager.dart';
import 'crypto_service.dart';

@internal
abstract interface class AccountCryptoManager implements CryptoManager {
  FutureOr<Uint8List> colTypeToUid(String colId); // TODO make sync

  FutureOr<String> colTypeFromUid(Uint8List uid); // TODO make sync

  CollectionCryptoManager createCollectionCryptoManager(
    SecureKey key, {
    int version = CryptoService.currentVersion,
  });
}
