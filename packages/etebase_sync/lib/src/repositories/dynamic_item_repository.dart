import 'dart:async';

import 'package:etebase/etebase.dart';

import '../items/dispose_ref.dart';
import '../items/local_item_manager.dart';
import '../items/sync_item.dart';

// TODO exception handling on the *Many functions

abstract class DynamicItemRepository {
  final String colUid;

  final EtebaseItemManager _etebaseItemManager;
  final LocalItemManager _localItemManager;

  DynamicItemRepository({
    required this.colUid,
    required EtebaseItemManager etebaseItemManager,
    required LocalItemManager localItemManager,
  })  : _etebaseItemManager = etebaseItemManager,
        _localItemManager = localItemManager;

  Stream<dynamic> getAll({
    bool sync = true,
    int? limit,
  }) =>
      _streamItems(
        fetchNext: _etebaseItemManager.list,
        limit: limit,
      );

  Future<dynamic> get(String id, {bool sync = true}) async {
    final etebaseItem = await _etebaseItemManager.fetch(id);
    final syncItem = await _localItemManager.attach(etebaseItem);
    return syncItem.data;
  }

  Stream<dynamic> getMany(
    List<String> ids, {
    bool sync = true,
    int? limit,
  }) =>
      _streamItems(
        // ignore: discarded_futures
        fetchNext: (options) => _etebaseItemManager.fetchMulti(ids, options),
        limit: limit,
      );

  Future<String> create(
    dynamic item, {
    String? itemType,
    bool transaction = true,
  }) async {
    final syncItem = await _localItemManager.create(itemType, item);

    await _upload([syncItem], transaction);

    return syncItem.uid;
  }

  Future<List<String>> createMany(
    List<dynamic> items, {
    String? itemType,
    bool transaction = true,
  }) async {
    final syncItems = await Stream.fromIterable(items)
        .asyncMap((item) => _localItemManager.create(itemType, item))
        .toList();

    await _upload(syncItems, transaction);

    return syncItems.map((s) => s.uid).toList();
  }

  Future<void> update(
    String id,
    dynamic item, {
    bool transaction = true,
  }) async {
    final syncItem = await _localItemManager.restore(id);
    if (syncItem == null) {
      throw Exception('TODO: $id');
    }

    final updatedSyncItem = await _localItemManager.update(syncItem, item);
    await _upload([updatedSyncItem], transaction);
  }

  Future<void> updateMany(
    Map<String, dynamic> items, {
    bool transaction = true,
    String? itemType,
    bool forceItemType = false,
  }) async {
    final updatedSyncItems = <SyncItem>[];
    final failedIds = <String>[];

    for (final MapEntry(key: id, value: item) in items.entries) {
      final syncItem = await _localItemManager.restore(id);
      if (syncItem == null) {
        failedIds.add(id);
      } else {
        updatedSyncItems.add(await _localItemManager.update(syncItem, item));
      }
    }

    await _upload(updatedSyncItems, transaction);
    throw Exception('TODO: $failedIds');
  }

  Future<void> delete(String id);

  Future<void> deleteMany(List<String> id);

  Future<void> uploadOfflineChanges();

  Stream<dynamic> _streamItems({
    required Future<EtebaseItemListResponse> Function(
      EtebaseFetchOptions options,
    ) fetchNext,
    required int? limit,
  }) async* {
    String? stoken;
    var isDone = false;
    while (!isDone) {
      final etebaseItems = await fetchNext(
        EtebaseFetchOptions(
          limit: limit,
          stoken: stoken,
        ),
      );

      final disposable = Disposable(etebaseItems.dispose);
      try {
        stoken = await etebaseItems.getStoken();
        isDone = await etebaseItems.isDone();

        final data = await etebaseItems.getData();

        yield* _localItemManager
            .attachAll(data, disposable: Disposable(etebaseItems.dispose))
            .map((s) => s.data);
      } finally {
        await disposable.unlockDispose();
      }
    }
  }

  Future<void> _upload(Iterable<SyncItem> syncItems, bool transaction) async {
    if (transaction) {
      await _etebaseItemManager
          .transaction(syncItems.map((s) => s.item).toList());
    } else {
      await _etebaseItemManager.batch(syncItems.map((s) => s.item).toList());
    }

    syncItems.forEach(_localItemManager.refreshCache);
  }
}
