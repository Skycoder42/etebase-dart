import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

import '../collection_store.dart';
import 'hive_store.dart';
import 'item_info.dart';

@internal
final class HiveCollectionStore extends HiveStore<Collection, CollectionInfo>
    implements CollectionStore {
  final CollectionManager _collectionManager;
  final Box<String> _stokenBox;

  final _writeLock = Lock();

  HiveCollectionStore(this._collectionManager, this._stokenBox, super.itemBox);

  @override
  @nonVirtual
  Future<String?> getStoken(String collectionType) =>
      Future.value(_stokenBox.get(_stokenKey(collectionType)));

  @override
  @nonVirtual
  Future<void> saveStoken(String collectionType, String? stoken) =>
      _writeLock.synchronized(() async {
        if (stoken != null) {
          await _stokenBox.put(_stokenKey(collectionType), stoken);
        } else {
          await _stokenBox.delete(_stokenKey(collectionType));
        }
      });

  @override
  Stream<Collection> listCollections(String collectionType) => listUids()
      .asyncMap(boxGet)
      .whereNotNull()
      .where((info) => info.collectionType == collectionType)
      .map(createItem);

  @override
  Future<bool> isRemoved(String uid) async {
    final info = await boxGet(uid);
    return info?.isRemoved ?? true;
  }

  @override
  Future<bool> markRemoved(String uid) async {
    final info = await boxGet(uid);
    if (info == null) {
      return false;
    }
    await itemBox.put(uid, info.copyWith(isRemoved: true));
    return true;
  }

  @override
  Collection createItem(CollectionInfo itemInfo) =>
      _collectionManager.cacheLoad(itemInfo.data);

  @override
  CollectionInfo createItemInfo(Collection item, String? remoteEtag) =>
      CollectionInfo(
        collectionType: item.collectionType,
        data: _collectionManager.cacheSave(item),
        localEtag: item.etag,
        remoteEtag: remoteEtag,
      );

  String _stokenKey(String collectionType) => 'collections.$collectionType';
}
