import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';

import '../models/item_info.dart';

@internal
enum SetMode { fromRemote, preUpload, postUpload }

@internal
abstract interface class CacheView<TItem extends Item> {
  String get container;

  String? getStoken();

  Future<void> saveStoken(String? stoken);

  Iterable<String> listItems();

  Future<TItem?> getItem(String uid);

  Future<void> saveItem(TItem item, SetMode mode);
}

@internal
abstract base class HiveCacheView<TItem extends Item>
    implements CacheView<TItem> {
  final Box<String> _stokenBox;
  final LazyBox<ItemInfo> _itemBox;

  HiveCacheView(this._stokenBox, this._itemBox);

  @override
  @nonVirtual
  String? getStoken() => _stokenBox.get(_stokenKey);

  @override
  @nonVirtual
  Future<void> saveStoken(String? stoken) async {
    if (stoken != null) {
      await _stokenBox.put(_stokenKey, stoken);
    } else {
      await _stokenBox.delete(_stokenKey);
    }
  }

  @override
  Iterable<String> listItems() => _itemBox.keys.cast<String>();

  @override
  @nonVirtual
  Future<TItem?> getItem(String uid) async {
    final info = await _itemBox.get(uid);
    if (info == null) {
      return null;
    }
    return cacheLoad(info.data);
  }

  @override
  @nonVirtual
  Future<void> saveItem(TItem item, SetMode mode) async {
    final needsUpload = switch (mode) {
      SetMode.fromRemote
          // inlined for improved performance
          when (await _itemBox.get(item.uid))?.needsUpload ?? false =>
        throw Conflict(
          'The cache entry for $kind with uid "${item.uid}" '
          'is marked as locally modified',
        ),
      SetMode.fromRemote => false,
      SetMode.preUpload => true,
      SetMode.postUpload => false,
    };

    if (item.isDeleted && !needsUpload) {
      await _itemBox.delete(item.uid);
    } else {
      await _itemBox.put(item.uid, (
        data: cacheSave(item),
        needsUpload: needsUpload,
      ));
    }
  }

  @visibleForOverriding
  String get kind;

  @visibleForOverriding
  TItem cacheLoad(Uint8List data);

  @visibleForOverriding
  Uint8List cacheSave(TItem item);

  String get _stokenKey => '$kind.$container';
}

@internal
final class CollectionCacheView extends HiveCacheView<Collection> {
  final String _collectionType;
  final CollectionManager _collectionManager;

  CollectionCacheView(
    this._collectionType,
    this._collectionManager,
    super._stokenBox,
    super._itemBox,
  );

  @override
  String get kind => 'collection';

  @override
  String get container => _collectionType;

  @override
  Collection cacheLoad(Uint8List data) => _collectionManager.cacheLoad(data);

  @override
  Uint8List cacheSave(Collection item) => _collectionManager.cacheSave(item);
}

@internal
final class ItemCacheView extends HiveCacheView<Item> {
  final Collection _collection;
  final ItemManager _itemManager;

  ItemCacheView(
    this._collection,
    this._itemManager,
    super._stokenBox,
    super._itemBox,
  );

  @override
  String get kind => 'item';

  @override
  String get container => _collection.uid;

  @override
  Item cacheLoad(Uint8List data) => _itemManager.cacheLoad(data);

  @override
  Uint8List cacheSave(Item item) => _itemManager.cacheSave(item);
}
