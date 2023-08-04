import 'package:etebase/etebase.dart';

import '../serialization/serialization_registry.dart';
import '../storage/storage.dart';
import 'caching_item_manager.dart';
import 'dispose_ref.dart';
import 'sync_item.dart';

class LocalItemManager {
  final EtebaseItemManager _etebaseItemManager;
  final Storage _storage;
  final SerializationRegistry _serializationRegistry;

  LocalItemManager(
    this._etebaseItemManager,
    this._storage,
    this._serializationRegistry,
  );

  factory LocalItemManager.caching(
    EtebaseItemManager etebaseItemManager,
    Storage storage,
    SerializationRegistry serializationRegistry,
  ) = CachingItemManager;

  Future<SyncItem> attach(
    EtebaseItem item, {
    Disposable? disposable,
  }) async {
    final uid = await item.getUid();
    final meta = await item.getMeta();
    final content = await item.getContent();

    final serializer = _serializationRegistry.getSerializer(meta.itemType);
    final data = serializer.deserialize(content);
    _storage.save(item);

    return SyncItem(
      uid: uid,
      itemType: meta.itemType,
      item: item,
      data: data,
      internalDisposeRef: disposable?.attach(),
    );
  }

  Stream<SyncItem> attachAll(
    Iterable<EtebaseItem> items, {
    Disposable? disposable,
  }) =>
      Stream.fromIterable(items).asyncMap(
        // ignore: discarded_futures
        (item) => attach(
          item,
          disposable: disposable,
        ),
      );

  Future<void> detach(SyncItem syncItem) async {
    _storage.delete(syncItem.uid);
    await syncItem.dispose();
  }

  Future<SyncItem> create(String? itemType, dynamic data) async {
    final serializer = _serializationRegistry.getSerializer(itemType);

    final meta = EtebaseItemMetadata(
      itemType: itemType,
      mtime: DateTime.now(),
    );
    final content = serializer.serialize(data);
    final item = await _etebaseItemManager.create(meta, content);
    try {
      _storage.save(item);

      final uid = await item.getUid();
      return SyncItem(
        uid: uid,
        itemType: itemType,
        item: item,
        data: data,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      await item.dispose();
      rethrow;
    }
  }

  Future<SyncItem?> restore(String uid) async {
    final item = await _storage.load(uid);
    if (item == null) {
      return null;
    }

    try {
      final meta = await item.getMeta();
      final serializer = _serializationRegistry.getSerializer(meta.itemType);
      final content = await item.getContent();
      final data = serializer.deserialize(content);

      return SyncItem(
        uid: uid,
        itemType: meta.itemType,
        item: item,
        data: data,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      await item.dispose();
      rethrow;
    }
  }

  Future<SyncItem> update(SyncItem syncItem, dynamic data) async {
    final serializer = _serializationRegistry.getSerializer(syncItem.itemType);
    final meta = await syncItem.item.getMeta();

    final updatedMeta = meta.copyWith(mtime: DateTime.now());
    final content = serializer.serialize(data);
    await syncItem.item.setMeta(updatedMeta);
    await syncItem.item.setContent(content);
    _storage.save(syncItem.item);

    return syncItem.copyWith(data: data);
  }

  Future<SyncItem> delete(SyncItem syncItem) async {
    await syncItem.item.delete();
    _storage.save(syncItem.item);

    return syncItem.copyWith(data: null);
  }

  void refreshCache(SyncItem syncItem) => _storage.save(syncItem.item);
}
