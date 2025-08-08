import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';

import '../../../gen/package_metadata.dart' as meta;
import '../../sync/storage_mode.dart';
import '../account_store.dart';
import '../storage_manager.dart';
import 'hive_account_store.dart';
import 'hive_collection_store .dart';
import 'hive_item_store.dart';
import 'item_info.dart';

@internal
class HiveStorageManager implements StorageManager {
  static const _metaBoxKeyPrefix = 'box.';

  final int _typeIdOffset;
  final HiveInterface _hive;
  final StorageMode _storageMode;
  final String? _prefix;

  late final Box<dynamic> _metaBox;
  late final Box<String> _stokenBox;

  HiveStorageManager(
    this._typeIdOffset,
    this._hive,
    this._storageMode, [
    this._prefix,
  ]);

  late final _boxPrefix = _prefix != null
      ? '${meta.package}.$_prefix'
      : meta.package;
  late final _metaBoxName = '$_boxPrefix.meta';
  late final _stokenBoxName = '$_boxPrefix.stokens';
  late final _collectionBoxName = '$_boxPrefix.collections';
  late final _itemBoxPrefix = '$_boxPrefix.items.';

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
  Future<AccountStore> createAccountStore() =>
      Future.value(HiveAccountStore(_metaBox));

  @override
  Future<HiveCollectionStore> createCollectionStore(
    CollectionManager collectionManager,
  ) async => HiveCollectionStore(
    collectionManager,
    _stokenBox,
    await _getBox(_collectionBoxName),
  );

  @override
  Future<HiveItemStore> createItemStore(
    Collection collection,
    ItemManager itemManager,
  ) async => HiveItemStore(
    collection.uid,
    itemManager,
    _stokenBox,
    await _getBox(_itemBoxName(collection.uid)),
  );

  @override
  Future<void> eraseItemStore(String colUid) async {
    final itemBoxName = _itemBoxName(colUid);
    if (_hive.isBoxOpen(itemBoxName)) {
      await _box<ItemInfo>(itemBoxName).close();
    }
    await _hive.deleteBoxFromDisk(itemBoxName);
    await _metaBox.delete(_metaBoxKey(itemBoxName));
    await _stokenBox.delete(HiveItemStore.stokenKeyFor(colUid));
  }

  @override
  Future<void> erase() async {
    for (final boxName in _knownBoxes) {
      if (_hive.isBoxOpen(boxName)) {
        await _genericBox(boxName).close();
      }
      await _hive.deleteBoxFromDisk(boxName);
    }
    await _stokenBox.clear();
    await _metaBox.clear();
  }

  void _registerTypeAdapter<TType, TAdapter extends TypeAdapter<TType>>(
    TAdapter Function(int typeIdOffset) createAdapter,
  ) {
    final adapter = createAdapter(_typeIdOffset);
    if (!_hive.isAdapterRegistered(adapter.typeId)) {
      _hive.registerAdapter<TType>(adapter);
    }
  }

  String _itemBoxName(String colUid) => '$_itemBoxPrefix$colUid';

  String _metaBoxKey(String boxName) => '$_metaBoxKeyPrefix$boxName';

  BoxBase<T> _box<T extends ItemInfoBase>(String boxName) =>
      switch (_storageMode) {
        StorageMode.cached => _hive.box<T>(boxName),
        StorageMode.lazy => _hive.lazyBox<T>(boxName),
      };

  Future<BoxBase<T>> _openBox<T extends ItemInfoBase>(String boxName) async =>
      switch (_storageMode) {
        StorageMode.cached => await _hive.openBox(boxName),
        StorageMode.lazy => await _hive.openLazyBox(boxName),
      };

  Future<BoxBase<T>> _getBox<T extends ItemInfoBase>(String boxName) async {
    if (_hive.isBoxOpen(boxName)) {
      return _box<T>(boxName);
    } else {
      final metaKey = _metaBoxKey(boxName);
      if (!_metaBox.containsKey(metaKey)) {
        await _metaBox.put(metaKey, null);
      }
      return _openBox<T>(boxName);
    }
  }

  Iterable<String> get _knownBoxes sync* {
    for (final key in _metaBox.keys.whereType<String>()) {
      if (key.startsWith(_metaBoxKeyPrefix)) {
        yield key.substring(_metaBoxKeyPrefix.length);
      }
    }
  }

  Iterable<BoxBase<ItemInfoBase>> get _openBoxes => _knownBoxes
      .where(_hive.isBoxOpen)
      .map(
        (boxName) => boxName == _collectionBoxName
            ? _box<CollectionInfo>(boxName)
            : _box<ItemInfo>(boxName),
      );

  BoxBase<ItemInfoBase> _genericBox(String boxName) =>
      boxName == _collectionBoxName
      ? _box<CollectionInfo>(boxName)
      : _box<ItemInfo>(boxName);
}
