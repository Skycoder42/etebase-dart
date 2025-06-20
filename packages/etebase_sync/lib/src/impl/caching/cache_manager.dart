import 'dart:convert';

import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';

import '../../../gen/package_metadata.dart' as meta;
import '../models/item_info.dart';
import 'cache_view.dart';

class CacheManager {
  static const _boxPrefix = meta.package;
  static const _metaBoxName = '$_boxPrefix.meta';
  static const _stokenBoxName = '$_boxPrefix.stokens';
  static const _collectionBoxPrefix = '$_boxPrefix.collections.';
  static const _itemBoxPrefix = '$_boxPrefix.items.';

  static const _metaBoxKeyPrefix = 'box.';

  final int _typeIdOffset;
  final HiveInterface _hive;

  final _typeCodec = utf8.fuse(base64Url);

  late final Box<dynamic> _metaBox;
  late final Box<String> _stokenBox;

  CacheManager(this._typeIdOffset, this._hive);

  Future<void> initialize() async {
    final adapter = ItemInfoAdapter(_typeIdOffset);
    if (!_hive.isAdapterRegistered(adapter.typeId)) {
      _hive.registerAdapter<ItemInfo>(adapter);
    }

    _metaBox = await _hive.openBox<dynamic>(_metaBoxName);
    _stokenBox = await _hive.openBox<String>(_stokenBoxName);
  }

  Future<void> dispose() async {
    await Future.wait([
      for (final box in _openBoxes) box.close(),
      _stokenBox.close(),
      _metaBox.close(),
    ]);
  }

  Future<CacheView<Collection>> collectionCache(
    CollectionManager collectionManager,
    String collectionType,
  ) async => CollectionCacheView(
    collectionType,
    collectionManager,
    _stokenBox,
    await _getLazyBox<ItemInfo>(_collectionBoxName(collectionType)),
  );

  Future<CacheView<Item>> itemCache(
    ItemManager itemManager,
    Collection collection,
  ) async => ItemCacheView(
    collection,
    itemManager,
    _stokenBox,
    await _getLazyBox<ItemInfo>(_itemBoxName(collection)),
  );

  String _collectionBoxName(String collectionType) =>
      '$_collectionBoxPrefix${_typeCodec.encode(collectionType)}';

  String _itemBoxName(Collection collection) =>
      '$_itemBoxPrefix${collection.uid}';

  Future<LazyBox<T>> _getLazyBox<T>(String boxName) async {
    if (_hive.isBoxOpen(boxName)) {
      return _hive.lazyBox<T>(boxName);
    } else {
      final metaKey = '$_metaBoxKeyPrefix$boxName';
      if (!_metaBox.containsKey(metaKey)) {
        await _metaBox.put(metaKey, null);
      }
      return _hive.openLazyBox<T>(boxName);
    }
  }

  Iterable<BoxBase<dynamic>> get _openBoxes sync* {
    for (final key in _metaBox.keys.whereType<String>()) {
      if (key.startsWith(_metaBoxKeyPrefix)) {
        final boxName = key.substring(_metaBoxKeyPrefix.length);
        if (_hive.isBoxOpen(boxName)) {
          yield _hive.box(boxName);
        }
      }
    }
  }
}
