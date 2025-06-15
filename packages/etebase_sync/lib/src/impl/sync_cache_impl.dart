import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

@internal
enum SetMode { fromRemote, preUpload, postUpload }

@internal
class SyncCacheImpl {
  final CollectionManager _collectionManager;

  final _stokens = <String, String>{};
  final _collections = <String, Map<String, (Uint8List, bool)>>{};

  SyncCacheImpl(this._collectionManager);

  Future<void> dispose() async {}

  Future<void> saveStokenFor(String collectionType, String? stoken) async {
    if (stoken != null) {
      _stokens[collectionType] = stoken;
    } else {
      _stokens.remove(collectionType);
    }
  }

  Future<String?> loadStokenFor(String collectionType) =>
      Future.value(_stokens[collectionType]);

  Iterable<String> collectionList(String collectionType) =>
      _collections[collectionType]?.keys ?? const [];

  Future<Collection?> collectionGet(
    String collectionType,
    String colUid,
  ) async {
    final data = _collections[collectionType]?[colUid];
    if (data == null) {
      return null;
    }
    return _collectionManager.cacheLoad(data.$1);
  }

  Future<void> collectionSet(
    Collection collection, [
    SetMode mode = SetMode.fromRemote,
  ]) async {
    final colMap = _collections.putIfAbsent(
      collection.collectionType,
      () => {},
    );
    final current = colMap[collection.uid];
    final needsUpload = switch (mode) {
      SetMode.fromRemote when current?.$2 ?? false => throw Conflict(
        'The cache entry for collection with uid "${collection.uid}" '
        'is marked as locally modified',
      ),
      SetMode.fromRemote => false,
      SetMode.preUpload => true,
      SetMode.postUpload => false,
    };

    if (collection.isDeleted && !needsUpload) {
      colMap.remove(collection.uid);
    } else {
      colMap[collection.uid] = (
        _collectionManager.cacheSave(collection),
        needsUpload,
      );
    }
  }
}
