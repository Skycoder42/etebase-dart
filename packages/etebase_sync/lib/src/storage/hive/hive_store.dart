import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

import '../../exceptions/item_deleted.dart';
import '../save_result.dart';
import '../store.dart';
import 'item_info.dart';

@internal
abstract base class HiveStore<
  TItem extends Item,
  TItemInfo extends ItemInfoBase
>
    implements Store<TItem> {
  final _pendingUploads = <String>{};

  @protected
  final writeLock = Lock();

  @protected
  final BoxBase<TItemInfo> itemBox;

  HiveStore(this.itemBox);

  @protected
  FutureOr<TItemInfo?> boxGet(String uid) => switch (itemBox) {
    final Box<TItemInfo> box => box.get(uid),
    final LazyBox<TItemInfo> box => box.get(uid),
    _ => throw UnsupportedError(
      'Unknown BoxBase subtype: ${itemBox.runtimeType}',
    ),
  };

  @visibleForOverriding
  TItem createItem(TItemInfo itemInfo);

  @visibleForOverriding
  TItemInfo createItemInfo(TItem item, String? remoteEtag);

  @override
  Stream<String> listUids() => Stream.fromIterable(itemBox.keys.cast<String>());

  @override
  @nonVirtual
  Future<TItem?> getItem(String uid, {bool forUpload = false}) async {
    final info = await boxGet(uid);
    if (info == null || (forUpload && info.localEtag == info.remoteEtag)) {
      return null;
    }
    return createItem(info);
  }

  @override
  Future<SaveResult<TItem>> saveRemote(TItem item) =>
      writeLock.synchronized(() async {
        final oldItem = await boxGet(item.uid);
        if (oldItem == null) {
          if (!item.isDeleted) {
            await itemBox.put(item.uid, createItemInfo(item, item.etag));
            _pendingUploads.remove(item.uid);
            return SaveResult.ok(item.etag);
          } else {
            return SaveResult.ok(item.etag, SaveAction.unchanged);
          }
        }

        if (oldItem.remoteEtag == item.etag) {
          return SaveResult.ok(oldItem.localEtag, SaveAction.unchanged);
        }

        if (oldItem.localEtag != oldItem.remoteEtag) {
          return SaveResult.conflict(createItem(oldItem));
        }

        if (item.isDeleted) {
          await itemBox.delete(item.uid);
          _pendingUploads.remove(item.uid);
          return SaveResult.ok(item.etag, SaveAction.deleted);
        }

        await itemBox.put(item.uid, createItemInfo(item, item.etag));
        _pendingUploads.remove(item.uid);
        return SaveResult.ok(item.etag);
      });

  @override
  Future<SaveResult<TItem>> saveLocal(
    TItem item, {
    required String? expectedEtag,
    String? remoteEtag,
  }) => writeLock.synchronized(() async {
    final oldItem = await boxGet(item.uid);
    if (expectedEtag == null) {
      if (oldItem != null) {
        return SaveResult.conflict(createItem(oldItem));
      }
    } else {
      if (oldItem == null) {
        return throw ItemDeleted(item.uid);
      } else if (oldItem.localEtag != expectedEtag) {
        return SaveResult.conflict(createItem(oldItem));
      }
    }

    await itemBox.put(
      item.uid,
      createItemInfo(item, remoteEtag ?? oldItem?.remoteEtag),
    );
    _pendingUploads.add(item.uid);
    return SaveResult.ok(item.etag);
  });

  @override
  Future<SaveResult<TItem>> saveUploaded(TItem item) =>
      writeLock.synchronized(() async {
        final cacheItem = await boxGet(item.uid);
        if (cacheItem == null) {
          if (item.isDeleted) {
            return SaveResult.ok(item.etag, SaveAction.unchanged);
          } else {
            await itemBox.put(item.uid, createItemInfo(item, item.etag));
            _pendingUploads.remove(item.uid);
            return SaveResult.ok(item.etag);
          }
        }

        if (cacheItem.localEtag != item.etag) {
          return SaveResult.conflict(createItem(cacheItem));
        } else if (item.isDeleted) {
          await itemBox.delete(item.uid);
          _pendingUploads.remove(item.uid);
          return SaveResult.ok(item.etag, SaveAction.deleted);
        } else {
          await itemBox.put(item.uid, createItemInfo(item, item.etag));
          _pendingUploads.remove(item.uid);
          return SaveResult.ok(item.etag, SaveAction.unchanged);
        }
      });

  @override
  Stream<String> streamModified() => MergeStream([
    // stream all that are pending uploads
    listUids().asyncMap(_checkAndTrackPending).whereNotNull(),
    // stream all future actual item modifications
    itemBox.watch().where(_filterModified).map((e) => e.key as String),
  ]);

  @override
  Iterable<String> getPendingUploads() => _pendingUploads;

  Future<String?> _checkAndTrackPending(String uid) async =>
      await writeLock.synchronized(() async {
        final item = await boxGet(uid);
        if (item == null || item.localEtag == item.remoteEtag) {
          return null;
        }
        _pendingUploads.add(uid);
        return uid;
      });

  bool _filterModified(BoxEvent event) {
    if (event.deleted) {
      return false;
    }
    final info = event.value as TItemInfo;
    return info.localEtag != info.remoteEtag;
  }
}
