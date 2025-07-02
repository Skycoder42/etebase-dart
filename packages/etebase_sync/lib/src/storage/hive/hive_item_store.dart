import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import '../item_store.dart';
import 'hive_store.dart';
import 'item_info.dart';

@internal
final class HiveItemStore extends HiveStore<Item, ItemInfo>
    implements ItemStore {
  final String colUid;
  final ItemManager _itemManager;
  final Box<String> _stokenBox;

  final _writeLock = Lock();

  String get _stokenKey => 'items.$colUid';

  HiveItemStore(this.colUid, this._itemManager, this._stokenBox, super.itemBox);

  @override
  @nonVirtual
  Future<String?> getStoken() => Future.value(_stokenBox.get(_stokenKey));

  @override
  @nonVirtual
  Future<void> saveStoken(String? stoken) => _writeLock.synchronized(() async {
    if (stoken != null) {
      await _stokenBox.put(_stokenKey, stoken);
    } else {
      await _stokenBox.delete(_stokenKey);
    }
  });

  @override
  Item createItem(ItemInfo itemInfo) => _itemManager.cacheLoad(itemInfo.data);

  @override
  ItemInfo createItemInfo(Item item, String? remoteEtag) => ItemInfo(
    data: _itemManager.cacheSave(item),
    localEtag: item.etag,
    remoteEtag: remoteEtag,
  );
}
