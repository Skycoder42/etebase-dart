import 'dart:convert';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';
import 'package:sodium/sodium.dart';

import '../../api/exceptions/not_found.dart';
import '../../api/managers/etebase_account.dart';
import '../../api/managers/etebase_cache.dart';
import '../../api/managers/etebase_client.dart';
import '../../api/managers/etebase_collection_manager.dart';
import '../../api/managers/etebase_item_manager.dart';
import '../../api/models/etebase_collection.dart';
import '../../api/models/etebase_item.dart';
import '../codec/msg_pack_codec.dart';

@internal
abstract base class SembastCache implements EtebaseCache {
  static const _accountBoxName = 'account';
  static const _collectionBoxName = 'collection';

  static const _accountDataKey = 'account.data';
  static const _accountStokenKey = 'account.stoken';
  static const _accountColStokenKeyPrefix = 'col.stoken.';

  final String _encodedUsername;
  final String _path;

  late final Database _database;
  late final StoreRef<String, dynamic> _accountStore;
  late final StoreRef<String, Uint8List?> _collectionStore;

  SembastCache(String username, this._path)
      : _encodedUsername = utf8.fuse(base64UrlNoPad).encode(username);

  @visibleForOverriding
  Future<Database> openDatabase(String encodedUserName, String path);

  Future<void> initialize() async {
    _database = await openDatabase(_encodedUsername, _path);
    await _database.compact();
    _accountStore = StoreRef(_accountBoxName);
    _collectionStore = StoreRef(_collectionBoxName);
  }

  @override
  Future<void> dispose() async {
    await _database.close();
  }

  @override
  Future<void> clearUser() async {
    await _database.dropAll();
  }

  @override
  Future<bool> get hasAccount =>
      _accountStore.record(_accountDataKey).exists(_database);

  @override
  Future<void> saveAccount(
    EtebaseAccount account, [
    SecureKey? encryptionKey,
  ]) async {
    final accountData = await account.save(encryptionKey);
    await _accountStore.record(_accountDataKey).put(_database, accountData);
  }

  @override
  Future<EtebaseAccount> loadAccount(
    EtebaseClient client, [
    SecureKey? encryptionKey,
  ]) async {
    final accountData = await _accountStore
        .record(_accountDataKey)
        .get(_database)
        .cast<Uint8List?>();
    if (accountData == null) {
      throw NotFound('No account has been cached');
    }
    return EtebaseAccount.restore(client, accountData, encryptionKey);
  }

  @override
  Future<bool> get hasStoken =>
      _accountStore.record(_accountStokenKey).exists(_database);

  @override
  Future<void> saveStoken(String stoken) =>
      _accountStore.record(_accountStokenKey).put(_database, stoken);

  @override
  Future<String> loadStoken() async {
    final stoken = await _accountStore
        .record(_accountStokenKey)
        .get(_database)
        .cast<String?>();
    if (stoken == null) {
      throw NotFound('No stoken has been cached');
    }
    return stoken;
  }

  @override
  Stream<String> get persistedCollectionStokenUids => Stream.fromFuture(
        // ignore: discarded_futures
        _accountStore.findKeys(
          _database,
          finder: Finder(
            filter: Filter.custom(
              (record) => switch (record) {
                RecordSnapshot(key: final String key)
                    when key.startsWith(_accountColStokenKeyPrefix) =>
                  true,
                _ => false,
              },
            ),
          ),
        ),
      )
          .expand((keys) => keys)
          .map((key) => key.substring(_accountColStokenKeyPrefix.length));

  @override
  Future<void> collectionSaveStoken(String colUid, String stoken) =>
      _accountStore.record(_collectionStokenKey(colUid)).put(_database, stoken);

  @override
  Future<String> collectionLoadStoken(String colUid) async {
    final stoken = await _accountStore
        .record(_collectionStokenKey(colUid))
        .get(_database)
        .cast<String?>();
    if (stoken == null) {
      throw NotFound('No stoken has been cached for $colUid');
    }
    return stoken;
  }

  @override
  Stream<String> get persistedCollectionUids =>
      // ignore: discarded_futures
      Stream.fromFuture(_collectionStore.findKeys(_database))
          .expand((keys) => keys);

  @override
  Future<void> collectionSet(
    EtebaseCollectionManager colMgr,
    EtebaseCollection col, {
    bool saveContent = true,
  }) async {
    final colData = colMgr.cacheSave(col, saveContent: saveContent);
    await _collectionStore.record(col.uid).put(_database, colData);
  }

  @override
  Future<void> collectionUnset(
    EtebaseCollectionManager colMgr,
    String colUid,
  ) async {
    await _accountStore.record(_collectionStokenKey(colUid)).delete(_database);
    final itemStore = _itemStore(colUid);
    await itemStore.delete(_database);
  }

  @override
  Future<EtebaseCollection> collectionGet(
    EtebaseCollectionManager colMgr,
    String colUid,
  ) async {
    final colData = await _collectionStore.record(colUid).get(_database);
    if (colData == null) {
      throw NotFound('No collection has been cached for $colUid');
    }
    return colMgr.cacheLoad(colData);
  }

  @override
  Stream<String> persistedItemUids(String colUid) =>
      // ignore: discarded_futures
      Stream.fromFuture(_itemStore(colUid).findKeys(_database))
          .expand((keys) => keys);

  @override
  Future<void> itemSet(
    EtebaseItemManager itemMgr,
    String colUid,
    EtebaseItem item, {
    bool saveContent = true,
  }) async {
    final itemStore = _itemStore(colUid);
    final itemData = itemMgr.cacheSave(item, saveContent: saveContent);
    await itemStore.record(item.uid).put(_database, itemData);
  }

  @override
  Future<void> itemUnset(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  ) async {
    final itemStore = _itemStore(colUid);
    await itemStore.record(itemUid).delete(_database);
  }

  @override
  Future<EtebaseItem> itemGet(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  ) async {
    final itemStore = _itemStore(colUid);
    final itemData = await itemStore.record(itemUid).get(_database);
    if (itemData == null) {
      throw NotFound(
        'No item has been cached for $itemUid in collection $colUid',
      );
    }
    return itemMgr.cacheLoad(itemData);
  }

  StoreRef<String, Uint8List> _itemStore(String colUid) =>
      StoreRef('$_collectionBoxName.$colUid');

  String _collectionStokenKey(String colUid) =>
      '$_accountColStokenKeyPrefix$colUid';
}

extension on Future<dynamic> {
  Future<T> cast<T>() => then((v) => v as T);
}
