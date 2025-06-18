import 'dart:convert';

import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';

import '../../gen/package_metadata.dart' as meta;
import 'models/collection_info.dart';

@internal
enum SetMode { fromRemote, preUpload, postUpload }

@internal
class SyncCacheImpl {
  static const _metaBoxName = '${meta.package}.meta';
  static const _stokenBoxName = '${meta.package}.stokens';
  static const _collectionBoxPrefix = '${meta.package}.collections.';

  static const _metaTypeKeyPrefix = 'type.';

  final int _typeIdOffset;
  final HiveInterface _hive;

  final _typeCodec = utf8.fuse(base64Url);

  late final Box<dynamic> _metaBox;
  late final Box<String> _stokenBox;

  SyncCacheImpl(this._typeIdOffset, this._hive);

  Future<void> initialize() async {
    _autoRegister<CollectionInfo>(CollectionInfoAdapter(_typeIdOffset));

    _metaBox = await _hive.openBox<String>(_metaBoxName);
    _stokenBox = await _hive.openBox<String>(_stokenBoxName);
  }

  Future<void> dispose() async {
    await Future.wait([
      for (final boxName in _knownDynamicBoxes)
        if (_hive.isBoxOpen(boxName)) _hive.lazyBox<dynamic>(boxName).close(),
      _stokenBox.close(),
      _metaBox.close(),
    ]);
  }

  Future<void> saveStokenFor(String collectionType, String? stoken) async {
    if (stoken != null) {
      await _stokenBox.put(collectionType, stoken);
    } else {
      await _stokenBox.delete(collectionType);
    }
  }

  Future<String?> loadStokenFor(String collectionType) =>
      Future.value(_stokenBox.get(collectionType));

  Stream<String> collectionList(String collectionType) => Stream.fromFuture(
    _collectionBox(collectionType),
  ).expand((box) => box?.keys ?? const []).cast<String>();

  Future<Collection?> collectionGet(
    CollectionManager collectionManager,
    String collectionType,
    String colUid,
  ) async {
    final box = await _collectionBox(collectionType);
    final info = await box?.get(colUid);
    if (info == null) {
      return null;
    }
    return collectionManager.cacheLoad(info.collection);
  }

  Future<void> collectionSet(
    CollectionManager collectionManager,
    Collection collection, [
    SetMode mode = SetMode.fromRemote,
  ]) async {
    final box = (await _collectionBox(
      collection.collectionType,
      create: true,
    ))!;
    final needsUpload = switch (mode) {
      SetMode.fromRemote
          // inlined for improved performance
          when (await box.get(collection.uid))?.needsUpload ?? false =>
        throw Conflict(
          'The cache entry for collection with uid "${collection.uid}" '
          'is marked as locally modified',
        ),
      SetMode.fromRemote => false,
      SetMode.preUpload => true,
      SetMode.postUpload => false,
    };

    if (collection.isDeleted && !needsUpload) {
      await box.delete(collection.uid);
    } else {
      final collectionData = collectionManager.cacheSave(collection);
      await box.put(collection.uid, (
        collection: collectionData,
        needsUpload: needsUpload,
      ));
    }
  }

  Future<Item?> itemGet(
    ItemManager itemManager,
    String colUid,
    String itemUid,
  ) => throw UnimplementedError();

  Future<void> itemSet(
    ItemManager itemManager,
    String colUid,
    Item item, [
    SetMode mode = SetMode.fromRemote,
  ]) => throw UnimplementedError();

  void _autoRegister<T>(TypeAdapter<T> adapter) {
    if (!_hive.isAdapterRegistered(adapter.typeId)) {
      _hive.registerAdapter<T>(adapter);
    }
  }

  String _metaTypeKey(String collectionType) =>
      '$_metaTypeKeyPrefix$collectionType';

  String _collectionBoxName(String collectionType) =>
      '$_collectionBoxPrefix${_typeCodec.encode(collectionType)}';

  Future<LazyBox<CollectionInfo>?> _collectionBox(
    String collectionType, {
    bool create = false,
  }) async => await _dynamicBox<CollectionInfo>(
    boxName: _collectionBoxName(collectionType),
    metaKey: _metaTypeKey(collectionType),
    create: create,
  );

  Iterable<String> get _knownDynamicBoxes sync* {
    for (final key in _metaBox.keys.whereType<String>()) {
      if (key.startsWith(_metaTypeKeyPrefix)) {
        yield _collectionBoxName(key.substring(_metaTypeKeyPrefix.length));
      }
    }
  }

  Future<LazyBox<T>?> _dynamicBox<T>({
    required String boxName,
    required String metaKey,
    required bool create,
  }) async {
    if (_hive.isBoxOpen(boxName)) {
      return _hive.lazyBox<T>(boxName);
    } else if (!create && !await _hive.boxExists(boxName)) {
      return null;
    } else {
      if (!_metaBox.containsKey(metaKey)) {
        await _metaBox.put(metaKey, null);
      }
      return _hive.openLazyBox<T>(boxName);
    }
  }
}
