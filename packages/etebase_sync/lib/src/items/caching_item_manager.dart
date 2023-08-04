import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import 'dispose_ref.dart';
import 'local_item_manager.dart';
import 'sync_item.dart';

@internal
class CachingItemManager extends LocalItemManager {
  final _itemCache = <String, SyncItem>{};

  CachingItemManager(
    super._etebaseItemManager,
    super._storage,
    super._serializationRegistry,
  );

  @override
  Future<SyncItem> attach(EtebaseItem item, {Disposable? disposable}) async {
    final syncItem = await super.attach(item, disposable: disposable);
    return _cacheItem(syncItem);
  }

  @override
  Future<void> detach(SyncItem syncItem) async {
    await super.detach(syncItem);
    _itemCache.remove(syncItem.uid);
  }

  @override
  Future<SyncItem> create(String? itemType, dynamic data) async {
    final syncItem = await super.create(itemType, data);
    return _cacheItem(syncItem);
  }

  @override
  Future<SyncItem?> restore(String uid) async {
    final cachedItem = _itemCache[uid];
    if (cachedItem != null) {
      return cachedItem;
    }

    final syncItem = await super.restore(uid);
    if (syncItem == null) {
      return null;
    }

    return _cacheItem(syncItem);
  }

  @override
  Future<SyncItem> update(SyncItem syncItem, dynamic data) async {
    final updatedItem = await super.update(syncItem, data);
    return _cacheItem(updatedItem);
  }

  @override
  Future<SyncItem> delete(SyncItem syncItem) async {
    final deletedItem = await super.delete(syncItem);
    return _cacheItem(deletedItem);
  }

  SyncItem _cacheItem(SyncItem syncItem) => _itemCache[syncItem.uid] = syncItem;
}
