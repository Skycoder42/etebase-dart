import 'dart:convert';
import 'dart:typed_data';

import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';
import 'package:sodium/sodium.dart';

import '../../api/exceptions/not_found.dart';
import '../../api/managers/account.dart';
import '../../api/managers/cache.dart';
import '../../api/managers/collection_manager.dart';
import '../../api/managers/item_manager.dart';
import '../../api/models/collection.dart';
import '../../api/models/item.dart';
import '../codec/base64_url_no_pad_codec.dart';
import '../managers/client_impl.dart';

@internal
class HiveCache implements Cache {
  static const _metaBoxName = 'meta';
  static const _collectionBoxName = 'collection';

  static const _accountDataKey = 'account.data';
  static const _accountStokenKey = 'account.stoken';
  static const _accountColStokenKeyPrefix = 'col.stoken.';

  final ClientImpl _client;
  final HiveInterface _hive;
  final String _encodedUsername;

  late final LazyBox<String> _metaBox;
  late final LazyBox<Uint8List> _collectionBox;

  new(this._client, this._hive, String username)
    : _encodedUsername = utf8.fuse(base64UrlNoPad).encode(username);

  Future<void> initialize() async {
    _metaBox = await _hive.openLazyBox(_boxName(_metaBoxName));
    _collectionBox = await _hive.openLazyBox(_boxName(_collectionBoxName));
  }

  @override
  Future<void> dispose() async {
    await Future.wait([
      for (final boxName in _knownItemBoxNames)
        if (_hive.isBoxOpen(boxName)) _hive.lazyBox<Uint8List>(boxName).close(),
      _collectionBox.close(),
      _metaBox.close(),
    ]);
  }

  @override
  Future<void> clearUser({bool reInitialize = false}) async {
    await Future.wait([
      for (final boxName in _knownItemBoxNames)
        _safeDeleteBoxByName<Uint8List>(boxName),
      if (reInitialize) ...[
        _collectionBox.clear(),
        _metaBox.clear(),
      ] else ...[
        _safeDeleteBox(_collectionBox),
        _safeDeleteBox(_metaBox),
      ],
    ]);
  }

  @override
  Future<bool> get hasAccount =>
      Future.value(_metaBox.containsKey(_accountDataKey));

  @override
  Future<void> saveAccount(Account account, [SecureKey? encryptionKey]) async {
    final accountData = await account.save(encryptionKey);
    await _metaBox.put(_accountDataKey, accountData);
  }

  @override
  Future<Account> loadAccount([SecureKey? encryptionKey]) async {
    final accountData = await _metaBox.get(_accountDataKey);
    if (accountData == null) {
      throw NotFound('No account has been cached');
    }
    return await _client.restoreAccount(accountData, encryptionKey);
  }

  @override
  Future<bool> get hasStoken =>
      Future.value(_metaBox.containsKey(_accountStokenKey));

  @override
  Future<void> saveStoken(String stoken) =>
      _metaBox.put(_accountStokenKey, stoken);

  @override
  Future<String> loadStoken() async {
    final stoken = await _metaBox.get(_accountStokenKey);
    if (stoken == null) {
      throw NotFound('No stoken has been cached');
    }
    return stoken;
  }

  @override
  Stream<String> get persistedCollectionStokenUids => Stream.fromIterable(
    _metaBox.keys
        .cast<String>()
        .where((key) => key.startsWith(_accountColStokenKeyPrefix))
        .map((key) => key.substring(_accountColStokenKeyPrefix.length)),
  );

  @override
  Future<void> collectionSaveStoken(String colUid, String stoken) =>
      _metaBox.put(_collectionStokenKey(colUid), stoken);

  @override
  Future<String> collectionLoadStoken(String colUid) async {
    final stoken = await _metaBox.get(_collectionStokenKey(colUid));
    if (stoken == null) {
      throw NotFound('No stoken has been cached for $colUid');
    }
    return stoken;
  }

  @override
  Stream<String> get persistedCollectionUids =>
      Stream.fromIterable(_collectionBox.keys.cast());

  @override
  Future<void> collectionSet(
    CollectionManager colMgr,
    Collection col, {
    bool saveContent = true,
  }) async {
    final colData = colMgr.cacheSave(col, saveContent: saveContent);
    await _collectionBox.put(col.uid, colData);
  }

  @override
  Future<void> collectionUnset(String colUid) async {
    await Future.wait([
      _metaBox.delete(_collectionStokenKey(colUid)),
      _collectionBox.delete(colUid),
      _safeDeleteBoxByName<Uint8List>(_itemBoxName(colUid)),
    ]);
  }

  @override
  Future<Collection> collectionGet(
    CollectionManager colMgr,
    String colUid,
  ) async {
    final colData = await _collectionBox.get(colUid);
    if (colData == null) {
      throw NotFound('No collection has been cached for $colUid');
    }
    return colMgr.cacheLoad(colData);
  }

  @override
  Stream<String> persistedItemUids(String colUid) =>
      Stream.fromFuture(_itemBox(colUid))
          .expand((itemBox) => itemBox?.keys.cast() ?? const []);

  @override
  Future<void> itemSet(
    ItemManager itemMgr,
    String colUid,
    Item item, {
    bool saveContent = true,
  }) async {
    final itemBox = await _itemBox(colUid, create: true);
    final itemData = itemMgr.cacheSave(item, saveContent: saveContent);
    await itemBox!.put(item.uid, itemData);
  }

  @override
  Future<void> itemUnset(String colUid, String itemUid) async {
    final itemBox = await _itemBox(colUid);
    await itemBox?.delete(itemUid);
  }

  @override
  Future<Item> itemGet(
    ItemManager itemMgr,
    String colUid,
    String itemUid,
  ) async {
    final itemBox = await _itemBox(colUid);
    final itemData = await itemBox?.get(itemUid);
    if (itemData == null) {
      throw NotFound(
        'No item has been cached for $itemUid in collection $colUid',
      );
    }
    return itemMgr.cacheLoad(itemData);
  }

  String _boxName(String name) => '$_encodedUsername.$name';

  String _itemBoxName(String colUid) => _boxName('$_collectionBoxName.$colUid');

  String _collectionStokenKey(String colUid) =>
      '$_accountColStokenKeyPrefix$colUid';

  Iterable<String> get _knownItemBoxNames => _collectionBox.isOpen
      ? _collectionBox.keys.cast<String>().map(_itemBoxName)
      : const [];

  Future<LazyBox<Uint8List>?> _itemBox(
    String colUid, {
    bool create = false,
  }) async {
    final boxName = _itemBoxName(colUid);
    if (_hive.isBoxOpen(boxName)) {
      return _hive.lazyBox<Uint8List>(boxName);
    } else if (!create && !await _hive.boxExists(boxName)) {
      return null;
    } else {
      return await _hive.openLazyBox<Uint8List>(boxName);
    }
  }

  // Helper methods to safely delete a box.
  // On web, deleting a box that is open will never complete.
  // On io, when calling box.deleteFromDisk on a closed box, it will throw.
  // So, as a workaround we close open boxes before deleting them and then
  // always delete them via the deleteBoxFromDisk method.

  Future<void> _safeDeleteBoxByName<T>(String boxName) async {
    if (_hive.isBoxOpen(boxName)) {
      await _hive.lazyBox<T>(boxName).close();
    }
    await _hive.deleteBoxFromDisk(boxName);
  }

  Future<void> _safeDeleteBox(BoxBase<dynamic> box) async {
    if (box.isOpen) {
      await box.close();
    }
    await _hive.deleteBoxFromDisk(box.name);
  }
}
