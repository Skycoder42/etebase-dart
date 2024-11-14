import 'dart:io';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/managers/etebase_account.dart';
import '../../api/managers/etebase_cache.dart';
import '../../api/managers/etebase_client.dart';
import '../../api/managers/etebase_collection_manager.dart';
import '../../api/managers/etebase_item_manager.dart';
import '../../api/models/etebase_collection.dart';
import '../../api/models/etebase_item.dart';

@internal
class FileSystemCache implements EtebaseCache {
  final Directory _cacheDir = Directory.systemTemp;

  FileSystemCache(this._cacheDir);

  @override
  Future<void> clearUser() {
    // TODO: implement clearUser
    throw UnimplementedError();
  }

  @override
  Future<EtebaseCollection> collectionGet(
    EtebaseCollectionManager colMgr,
    String colUid,
  ) {
    // TODO: implement collectionGet
    throw UnimplementedError();
  }

  @override
  Future<String?> collectionLoadStoken(String colUid) {
    // TODO: implement collectionLoadStoken
    throw UnimplementedError();
  }

  @override
  Future<void> collectionSaveStoken(String colUid, String stoken) {
    // TODO: implement collectionSaveStoken
    throw UnimplementedError();
  }

  @override
  Future<void> collectionSet(
    EtebaseCollectionManager colMgr,
    EtebaseCollection col,
  ) {
    // TODO: implement collectionSet
    throw UnimplementedError();
  }

  @override
  Future<void> collectionUnset(EtebaseCollectionManager colMgr, String colUid) {
    // TODO: implement collectionUnset
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  @override
  Future<EtebaseItem> itemGet(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  ) {
    // TODO: implement itemGet
    throw UnimplementedError();
  }

  @override
  Future<void> itemSet(
    EtebaseItemManager itemMgr,
    String colUid,
    EtebaseItem item,
  ) {
    // TODO: implement itemSet
    throw UnimplementedError();
  }

  @override
  Future<void> itemUnset(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  ) {
    // TODO: implement itemUnset
    throw UnimplementedError();
  }

  @override
  Future<EtebaseAccount> loadAccount(
    EtebaseClient client, [
    Uint8List? encryptionKey,
  ]) {
    // TODO: implement loadAccount
    throw UnimplementedError();
  }

  @override
  Future<String?> loadStoken() {
    // TODO: implement loadStoken
    throw UnimplementedError();
  }

  @override
  Future<void> saveAccount(EtebaseAccount etebase, [Uint8List? encryptionKey]) {
    // TODO: implement saveAccount
    throw UnimplementedError();
  }

  @override
  Future<void> saveStoken(String stoken) {
    // TODO: implement saveStoken
    throw UnimplementedError();
  }
}
