import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:synchronized/synchronized.dart';

import '../models/item_info.dart';

part 'cache_view.freezed.dart';

@internal
enum SaveMode { fromRemote, preUpload, postUpload }

@freezed
sealed class SaveResult<TItem extends Item> with _$SaveResult<TItem> {
  const factory SaveResult.ok(String etag) = SaveOk;
  const factory SaveResult.deleted() = SaveDeleted;
  const factory SaveResult.conflict(TItem cacheItem) = SaveConflict;
}

@internal
abstract interface class CacheView<TItem extends Item> {
  String get container;

  String? getStoken();

  Future<void> saveStoken(String? stoken);

  Iterable<String> listItems();

  Future<TItem?> getItem(String uid);

  Future<TItem> saveItem(TItem item, SaveMode mode);

  Future<SaveResult<TItem>> saveLocal(TItem item, String? expectedEtag);

  Future<SaveResult<TItem>> saveUploaded(TItem item);
}

@internal
abstract base class HiveCacheView<TItem extends Item>
    implements CacheView<TItem> {
  final Box<String> _stokenBox;
  final LazyBox<ItemInfo> _itemBox;

  final _writeLock = Lock();

  HiveCacheView(this._stokenBox, this._itemBox);

  @override
  @nonVirtual
  String? getStoken() => _stokenBox.get(_stokenKey);

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
  Future<TItem> saveItem(TItem item, SaveMode mode) async {
    final String? originalEtag;

    final oldItem = await _itemBox.get(item.uid);

    switch (mode) {
      case SaveMode.fromRemote
          when oldItem != null &&
              (oldItem.currentEtag == item.etag ||
                  oldItem.originalEtag == item.etag):
        // simply ignore the update, as remote has not been modified
        return cacheLoad(oldItem.data);
      case SaveMode.fromRemote when oldItem?.originalEtag != null:
        throw Conflict(
          'The cache entry for $kind with uid "${item.uid}" '
          'is marked as locally modified',
        );
      case SaveMode.fromRemote:
        originalEtag = null;
      case SaveMode.preUpload
          when oldItem != null && oldItem.currentEtag != item.etag:
        throw Conflict(
          'The cache entry for $kind with uid "${item.uid}" '
          'is marked as locally modified',
        );
      case SaveMode.preUpload:
        originalEtag = oldItem?.originalEtag ?? item.etag;
      case SaveMode.postUpload:
        originalEtag = null;
    }

    if (item.isDeleted && originalEtag == null) {
      await _itemBox.delete(item.uid);
    } else {
      await _itemBox.put(
        item.uid,
        ItemInfo(
          data: cacheSave(item),
          currentEtag: item.etag,
          originalEtag: originalEtag,
        ),
      );
    }
    return item;
  }

  @override
  Future<SaveResult<TItem>> saveLocal(TItem item, String? expectedEtag) =>
      _writeLock.synchronized(() async {
        final oldItem = await _itemBox.get(item.uid);
        if (expectedEtag == null) {
          if (oldItem != null) {
            return SaveResult.conflict(cacheLoad(oldItem.data));
          }
        } else {
          if (oldItem == null) {
            return const SaveResult.deleted();
          } else if (oldItem.localEtag != expectedEtag) {
            return SaveResult.conflict(cacheLoad(oldItem.data));
          }
        }

        await _itemBox.put(
          item.uid,
          ItemInfo(
            data: cacheSave(item),
            localEtag: item.etag,
            // TODO is this right?
            remoteEtag: oldItem?.remoteEtag ?? item.etag,
          ),
        );
        return SaveResult.ok(item.etag);
      });

  @override
  Future<SaveResult<TItem>> saveUploaded(TItem item) =>
      _writeLock.synchronized(() async {
        final oldItem = await _itemBox.get(item.uid);
        if (oldItem == null) {
          if (item.isDeleted) {
            return SaveResult.ok(item.etag);
          } else {
            return const SaveResult.deleted();
          }
        } else if (oldItem.localEtag != item.etag) {
          return SaveResult.conflict(cacheLoad(oldItem.data));
        }

        if (item.isDeleted) {
          await _itemBox.delete(item.uid);
        } else {
          await _itemBox.put(item.uid, oldItem.copyWith(remoteEtag: item.etag));
        }
        return SaveResult.ok(item.etag);
      });

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
