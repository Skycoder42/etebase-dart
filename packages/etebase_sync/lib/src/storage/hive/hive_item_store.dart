import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import '../item_store.dart';
import '../save_result.dart';
import 'item_info.dart';

abstract base class HiveItemStore implements ItemStore {
  final String colUid;
  final Box<String> _stokenBox;
  final ItemManager _itemManager;

  final _writeLock = Lock();

  String get _stokenKey => 'items.$colUid';

  HiveItemStore(this.colUid, this._stokenBox, this._itemManager);

  factory HiveItemStore.lazy(
    String colUid,
    Box<String> stokenBox,
    LazyBox<ItemInfo> itemBox,
    ItemManager itemManager,
  ) = _LazyHiveItemStore;

  factory HiveItemStore.cached(
    String colUid,
    Box<String> stokenBox,
    Box<ItemInfo> itemBox,
    ItemManager itemManager,
  ) = _CachedHiveItemStore;

  BoxBase<ItemInfo> get _itemBox;

  FutureOr<ItemInfo?> _boxGet(String uid);

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
  Stream<String> listUids() =>
      Stream.fromIterable(_itemBox.keys.cast<String>());

  @override
  @nonVirtual
  Future<Item?> getItem(String uid, {bool forUpload = false}) async {
    final info = await _boxGet(uid);
    if (info == null || (forUpload && info.localEtag == info.remoteEtag)) {
      return null;
    }
    return _itemManager.cacheLoad(info.data);
  }

  @override
  Future<SaveResult> saveRemote(Item item) => _writeLock.synchronized(() async {
    final oldItem = await _boxGet(item.uid);
    if (oldItem == null) {
      if (!item.isDeleted) {
        await _itemBox.put(
          item.uid,
          ItemInfo(
            data: _itemManager.cacheSave(item),
            localEtag: item.etag,
            remoteEtag: item.etag,
          ),
        );
      }
      return SaveResult.ok(item.etag);
    }

    if (oldItem.remoteEtag == item.etag) {
      return SaveResult.ok(oldItem.localEtag);
    }

    if (oldItem.localEtag != oldItem.remoteEtag) {
      return SaveResult.conflict(_itemManager.cacheLoad(oldItem.data));
    }

    await _itemBox.put(
      item.uid,
      ItemInfo(
        data: _itemManager.cacheSave(item),
        localEtag: item.etag,
        remoteEtag: item.etag,
      ),
    );
    return SaveResult.ok(item.etag);
  });

  @override
  Future<SaveResult> saveLocal(
    Item item, {
    required String? expectedEtag,
    String? remoteEtag,
  }) => _writeLock.synchronized(() async {
    final oldItem = await _boxGet(item.uid);
    if (expectedEtag == null) {
      if (oldItem != null) {
        return SaveResult.conflict(_itemManager.cacheLoad(oldItem.data));
      }
    } else {
      if (oldItem == null) {
        return const SaveResult.deleted();
      } else if (oldItem.localEtag != expectedEtag) {
        return SaveResult.conflict(_itemManager.cacheLoad(oldItem.data));
      }
    }

    await _itemBox.put(
      item.uid,
      ItemInfo(
        data: _itemManager.cacheSave(item),
        localEtag: item.etag,
        remoteEtag: remoteEtag ?? oldItem?.remoteEtag,
      ),
    );
    return SaveResult.ok(item.etag);
  });

  @override
  Future<SaveResult> saveUploaded(Item item) => _writeLock.synchronized(
    () async {
      final cacheItem = await _boxGet(item.uid);
      if (cacheItem == null) {
        if (item.isDeleted) {
          return SaveResult.ok(item.etag);
        } else {
          return const SaveResult.deleted();
        }
      } else if (cacheItem.localEtag != item.etag) {
        return SaveResult.conflict(_itemManager.cacheLoad(cacheItem.data));
      }

      if (item.isDeleted) {
        await _itemBox.delete(item.uid);
      } else {
        await _itemBox.put(item.uid, cacheItem.copyWith(remoteEtag: item.etag));
      }
      return SaveResult.ok(item.etag);
    },
  );

  @override
  Stream<String> stream() =>
      _itemBox.watch().where((e) => !e.deleted).map((e) => e.key as String);
}

final class _CachedHiveItemStore extends HiveItemStore {
  @override
  final Box<ItemInfo> _itemBox;

  _CachedHiveItemStore(
    super.colUid,
    super._stokenBox,
    this._itemBox,
    super._itemManager,
  );

  @override
  ItemInfo? _boxGet(String uid) => _itemBox.get(uid);
}

final class _LazyHiveItemStore extends HiveItemStore {
  @override
  final LazyBox<ItemInfo> _itemBox;

  _LazyHiveItemStore(
    super.colUid,
    super._stokenBox,
    this._itemBox,
    super._itemManager,
  );

  @override
  Future<ItemInfo?> _boxGet(String uid) async => await _itemBox.get(uid);
}
