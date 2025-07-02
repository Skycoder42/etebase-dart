import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';

import '../../../gen/package_metadata.dart' as meta;
import '../../sync/storage_mode.dart';
import '../storage_manager.dart';
import 'hive_collection_store .dart';
import 'hive_item_store.dart';
import 'item_info.dart';

@internal
class HiveStorageManager implements StorageManager {
  static const _boxPrefix = meta.package;
  static const _metaBoxName = '$_boxPrefix.meta';
  static const _stokenBoxName = '$_boxPrefix.stokens';
  static const _collectionBoxName = '$_boxPrefix.collections';
  static const _itemBoxPrefix = '$_boxPrefix.items.';

  static const _metaBoxKeyPrefix = 'box.';

  final int _typeIdOffset;
  final HiveInterface _hive;
  final StorageMode _storageMode;

  late final Box<dynamic> _metaBox;
  late final Box<String> _stokenBox;

  HiveStorageManager(this._typeIdOffset, this._hive, this._storageMode);

  @override
  Future<void> init() async {
    _registerTypeAdapter<ItemInfo, ItemInfoAdapter>(ItemInfoAdapter.new);
    _registerTypeAdapter<CollectionInfo, CollectionInfoAdapter>(
      CollectionInfoAdapter.new,
    );

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
  ) async => HiveItemStore(
    collection.uid,
    itemManager,
    _stokenBox,
    await _getBox(_itemBoxName(collection)),
  );

  @override
  Future<HiveCollectionStore> createCollectionStore(
    CollectionManager itemManager,
  ) async => HiveCollectionStore(
    itemManager,
    _stokenBox,
    await _getBox(_collectionBoxName),
  );

  void _registerTypeAdapter<TType, TAdapter extends TypeAdapter<TType>>(
    TAdapter Function(int typeIdOffset) createAdapter,
  ) {
    final adapter = createAdapter(_typeIdOffset);
    if (!_hive.isAdapterRegistered(adapter.typeId)) {
      _hive.registerAdapter<TType>(adapter);
    }
  }

  String _itemBoxName(Collection collection) =>
      '$_itemBoxPrefix${collection.uid}';

  BoxBase<T> _box<T>(String boxName) => switch (_storageMode) {
    StorageMode.cached => _hive.box(boxName),
    StorageMode.lazy => _hive.lazyBox(boxName),
  };

  Future<BoxBase<T>> _openBox<T>(String boxName) async =>
      switch (_storageMode) {
        StorageMode.cached => await _hive.openBox(boxName),
        StorageMode.lazy => await _hive.openLazyBox(boxName),
      };

  Future<BoxBase<T>> _getBox<T>(String boxName) async {
    if (_hive.isBoxOpen(boxName)) {
      return _box<T>(boxName);
    } else {
      final metaKey = '$_metaBoxKeyPrefix$boxName';
      if (!_metaBox.containsKey(metaKey)) {
        await _metaBox.put(metaKey, null);
      }
      return _openBox<T>(boxName);
    }
  }

  Iterable<BoxBase<dynamic>> get _openBoxes sync* {
    for (final key in _metaBox.keys.whereType<String>()) {
      if (key.startsWith(_metaBoxKeyPrefix)) {
        final boxName = key.substring(_metaBoxKeyPrefix.length);
        if (_hive.isBoxOpen(boxName)) {
          yield _box<dynamic>(boxName);
        }
      }
    }
  }
}
