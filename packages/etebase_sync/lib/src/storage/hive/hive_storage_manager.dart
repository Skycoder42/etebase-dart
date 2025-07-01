import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';

import '../../../gen/package_metadata.dart' as meta;
import '../../sync/storage_mode.dart';
import '../storage_manager.dart';
import 'hive_item_store.dart';
import 'item_info.dart';

class HiveStorageManager implements StorageManager {
  static const _boxPrefix = meta.package;
  static const _metaBoxName = '$_boxPrefix.meta';
  static const _stokenBoxName = '$_boxPrefix.stokens';
  // static const _collectionBoxPrefix = '$_boxPrefix.collections.';
  static const _itemBoxPrefix = '$_boxPrefix.items.';

  static const _metaBoxKeyPrefix = 'box.';

  final int _typeIdOffset;
  final HiveInterface _hive;
  final StorageMode _storageMode;

  // final _typeCodec = utf8.fuse(base64Url);

  late final Box<dynamic> _metaBox;
  late final Box<String> _stokenBox;

  HiveStorageManager(this._typeIdOffset, this._hive, this._storageMode);

  @override
  Future<void> init() async {
    final adapter = ItemInfoAdapter(_typeIdOffset);
    if (!_hive.isAdapterRegistered(adapter.typeId)) {
      _hive.registerAdapter<ItemInfo>(adapter);
    }

    _metaBox = await _hive.openBox<dynamic>(_metaBoxName);
    _stokenBox = await _hive.openBox<String>(_stokenBoxName);
  }

  @override
  Future<void> dispose() async {
    await Future.wait([
      for (final box in _openBoxes) box.close(),
      _stokenBox.close(),
      _metaBox.close(),
    ]);
  }

  @override
  Future<HiveItemStore> createItemStore(
    Collection collection,
    ItemManager itemManager,
  ) async => switch (_storageMode) {
    StorageMode.cached => HiveItemStore.cached(
      collection.uid,
      _stokenBox,
      await _getBox(_itemBoxName(collection)),
      itemManager,
    ),
    StorageMode.lazy => HiveItemStore.lazy(
      collection.uid,
      _stokenBox,
      await _getLazyBox(_itemBoxName(collection)),
      itemManager,
    ),
  };

  // String _collectionBoxName(String collectionType) =>
  //     '$_collectionBoxPrefix${_typeCodec.encode(collectionType)}';

  String _itemBoxName(Collection collection) =>
      '$_itemBoxPrefix${collection.uid}';

  Future<Box<T>> _getBox<T>(String boxName) async {
    if (_hive.isBoxOpen(boxName)) {
      return _hive.box<T>(boxName);
    } else {
      final metaKey = '$_metaBoxKeyPrefix$boxName';
      if (!_metaBox.containsKey(metaKey)) {
        await _metaBox.put(metaKey, null);
      }
      return _hive.openBox<T>(boxName);
    }
  }

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
          yield switch (_storageMode) {
            StorageMode.cached => _hive.box(boxName),
            StorageMode.lazy => _hive.lazyBox(boxName),
          };
        }
      }
    }
  }
}
