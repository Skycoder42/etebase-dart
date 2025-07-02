import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import '../../api/exceptions/item_deleted.dart';
import '../save_result.dart';
import '../store.dart';
import 'item_info.dart';

@internal
abstract base class HiveStore<
  TItem extends Item,
  TItemInfo extends ItemInfoBase
>
    implements Store<TItem> {
  @protected
  final writeLock = Lock();

  final BoxBase<TItemInfo> itemBox;

  HiveStore(this.itemBox);

  FutureOr<TItemInfo?> _boxGet(String uid) => switch (itemBox) {
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
    final info = await _boxGet(uid);
    if (info == null || (forUpload && info.localEtag == info.remoteEtag)) {
      return null;
    }
    return createItem(info);
  }

  @override
  Future<SaveResult<TItem>> saveRemote(TItem item) =>
      writeLock.synchronized(() async {
        final oldItem = await _boxGet(item.uid);
        if (oldItem == null) {
          if (!item.isDeleted) {
            await itemBox.put(item.uid, createItemInfo(item, item.etag));
          }
          return SaveResult.ok(item.etag);
        }

        if (oldItem.remoteEtag == item.etag) {
          return SaveResult.ok(oldItem.localEtag);
        }

        if (oldItem.localEtag != oldItem.remoteEtag) {
          return SaveResult.conflict(createItem(oldItem));
        }

        await itemBox.put(item.uid, createItemInfo(item, item.etag));
        return SaveResult.ok(item.etag);
      });

  @override
  Future<SaveResult<TItem>> saveLocal(
    TItem item, {
    required String? expectedEtag,
    String? remoteEtag,
  }) => writeLock.synchronized(() async {
    final oldItem = await _boxGet(item.uid);
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
    return SaveResult.ok(item.etag);
  });

  @override
  Future<SaveResult<TItem>> saveUploaded(TItem item) =>
      writeLock.synchronized(() async {
        final cacheItem = await _boxGet(item.uid);
        if (cacheItem == null) {
          if (item.isDeleted) {
            return SaveResult.ok(item.etag);
          } else {
            await itemBox.put(item.uid, createItemInfo(item, item.etag));
            return SaveResult.ok(item.etag);
          }
        }

        if (cacheItem.localEtag != item.etag) {
          return SaveResult.conflict(createItem(cacheItem));
        } else if (item.isDeleted) {
          await itemBox.delete(item.uid);
          return SaveResult.ok(item.etag);
        } else {
          await itemBox.put(item.uid, cacheItem.withRemoteEtag(item.etag));
          return SaveResult.ok(item.etag);
        }
      });

  @override
  Stream<String> stream() =>
      itemBox.watch().where((e) => !e.deleted).map((e) => e.key as String);
}
