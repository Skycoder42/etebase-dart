import 'dart:convert';
import 'dart:typed_data';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';
import 'package:sodium/sodium.dart';

import '../../api/managers/etebase_account.dart';
import '../../api/managers/etebase_cache.dart';
import '../../api/managers/etebase_client.dart';
import '../../api/managers/etebase_collection_manager.dart';
import '../../api/managers/etebase_item_manager.dart';
import '../../api/models/etebase_collection.dart';
import '../../api/models/etebase_item.dart';

@internal
class HiveCache implements EtebaseCache {
  static const _accountBoxName = 'account';
  static const _collectionBoxName = 'collection';

  static const _accountDataKey = 'account.data';
  static const _accountStokenKey = 'account.stoken';

  final HiveInterface _hive;
  final String _encodedUsername;

  late LazyBox<dynamic> _accountBox;
  late LazyBox<Uint8List?> _collectionBox;

  HiveCache(this._hive, String username)
      : _encodedUsername = utf8.fuse(base64Url).encode(username);

  Future<void> initialize() async {
    _accountBox = await _hive.openLazyBox(_boxName(_accountBoxName));
    _collectionBox = await _hive.openLazyBox(_boxName(_collectionBoxName));
  }

  @override
  Future<void> dispose() async {
    final collectionBoxes =
        _collectionBox.keys.cast<String>().map(_itemBoxName);
    await Future.wait([
      for (final boxName in collectionBoxes)
        if (_hive.isBoxOpen(boxName)) _hive.box<Uint8List>(boxName).close(),
      _collectionBox.close(),
      _accountBox.close(),
    ]);
  }

  @override
  Future<void> clearUser() async {
    final collectionBoxes =
        _collectionBox.keys.cast<String>().map(_itemBoxName);
    await Future.wait([
      for (final boxName in collectionBoxes) _hive.deleteBoxFromDisk(boxName),
      _collectionBox.deleteFromDisk(),
      _accountBox.deleteFromDisk(),
    ]);

    await initialize();
  }

  @override
  Future<void> saveAccount(
    EtebaseAccount account, [
    SecureKey? encryptionKey,
  ]) async {
    final accountData = await account.save(encryptionKey);
    await _accountBox.put(_accountDataKey, accountData);
  }

  @override
  Future<EtebaseAccount?> loadAccount(
    EtebaseClient client, [
    SecureKey? encryptionKey,
  ]) async {
    final accountData =
        await _accountBox.get(_accountDataKey).cast<Uint8List>();
    if (accountData == null) {
      return null;
    }
    return EtebaseAccount.restore(client, accountData, encryptionKey);
  }

  @override
  Future<void> saveStoken(String stoken) =>
      _accountBox.put(_accountStokenKey, stoken);

  @override
  Future<String?> loadStoken() => _accountBox.get(_accountStokenKey).cast();

  @override
  Future<void> collectionSaveStoken(String colUid, String stoken) =>
      _accountBox.put(_collectionStokenKey(colUid), stoken);

  @override
  Future<String?> collectionLoadStoken(String colUid) =>
      _accountBox.get(_collectionStokenKey(colUid)).cast();

  @override
  Future<void> collectionSet(
    EtebaseCollectionManager colMgr,
    EtebaseCollection col, {
    bool saveContent = true,
  }) async {
    final colData = colMgr.cacheSave(col, saveContent: saveContent);
    await _collectionBox.put(col.uid, colData);
  }

  @override
  Future<void> collectionUnset(
    EtebaseCollectionManager colMgr,
    String colUid,
  ) async {
    final itemBox = _itemBoxName(colUid);
    await _hive.deleteBoxFromDisk(itemBox);
    await _collectionBox.delete(colUid);
  }

  @override
  Future<EtebaseCollection?> collectionGet(
    EtebaseCollectionManager colMgr,
    String colUid,
  ) async {
    final colData = await _collectionBox.get(colUid);
    if (colData == null) {
      return null;
    }
    return colMgr.cacheLoad(colData);
  }

  @override
  Future<void> itemSet(
    EtebaseItemManager itemMgr,
    String colUid,
    EtebaseItem item, {
    bool saveContent = true,
  }) async {
    final itemBox = await _itemBox(colUid, create: true);
    final itemData = itemMgr.cacheSave(item, saveContent: saveContent);
    await itemBox!.put(item.uid, itemData);
  }

  @override
  Future<void> itemUnset(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  ) async {
    final itemBox = await _itemBox(colUid);
    await itemBox?.delete(itemUid);
  }

  @override
  Future<EtebaseItem?> itemGet(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  ) async {
    final itemBox = await _itemBox(colUid);
    final itemData = await itemBox?.get(itemUid);
    if (itemData == null) {
      return null;
    }
    return itemMgr.cacheLoad(itemData);
  }

  String _boxName(String name) => '$_encodedUsername.$name';

  String _itemBoxName(String colUid) => _boxName('$_collectionBoxName.$colUid');

  String _collectionStokenKey(String colUid) => 'col.stoken.$colUid';

  Future<LazyBox<Uint8List>?> _itemBox(
    String colUid, {
    bool create = false,
  }) async {
    final boxName = _itemBoxName(colUid);
    if (!create && !await _hive.boxExists(boxName)) {
      return null;
    }

    if (!_collectionBox.containsKey(colUid)) {
      await _collectionBox.put(colUid, null);
    }
    return _hive.openLazyBox<Uint8List>(boxName);
  }
}

extension on Future<dynamic> {
  Future<T?> cast<T>() => then((v) => v as T?);
}
