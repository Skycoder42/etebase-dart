import 'package:etebase/etebase.dart';

import '../serialization/serialization_registry.dart';

abstract class DynamicItemRepository {
  final String colUid;
  final String itemType;

  final EtebaseItemManager _itemManager;
  final SerializationRegistry _serializationRegistry;

  DynamicItemRepository({
    required this.colUid,
    required this.itemType,
    required EtebaseItemManager itemManager,
    required SerializationRegistry serializationRegistry,
  })  : _itemManager = itemManager,
        _serializationRegistry = serializationRegistry;

  Stream<dynamic> getAll({
    bool sync = true,
    int? limit,
  }) =>
      _streamItems(
        fetchNext: _itemManager.list,
        limit: limit,
      );

  Future<dynamic> get(String id, {bool sync = true}) async {
    final etebaseItem = await _itemManager.fetch(id);
    return _deserializeItem(etebaseItem);
  }

  Stream<dynamic> getMany(
    List<String> ids, {
    bool sync = true,
    int? limit,
  }) =>
      _streamItems(
        // ignore: discarded_futures
        fetchNext: (options) => _itemManager.fetchMulti(ids, options),
        limit: limit,
      );

  Future<String> create(
    dynamic item, {
    bool transaction = true,
  }) async {
    final etebaseItem = await _createItem(item);

    if (transaction) {
      await _itemManager.transaction([etebaseItem]);
    } else {
      await _itemManager.batch([etebaseItem]);
    }

    return etebaseItem.getUid();
  }

  Future<List<String>> createMany(
    List<dynamic> items, {
    bool transaction = true,
  });

  Future<void> update(
    String id,
    dynamic item, {
    bool transaction = true,
  });

  Future<void> updateMany(
    Map<String, dynamic> items, {
    bool transaction = true,
  });

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

      stoken = await etebaseItems.getStoken();
      isDone = await etebaseItems.isDone();

      final data = await etebaseItems.getData();
      yield* Stream.fromIterable(data).asyncMap(_deserializeItem);

      await etebaseItems.dispose();
    }
  }

  Future<EtebaseItem> _createItem(item) {
    final serializer = _serializationRegistry.getSerializer(itemType);
    return _itemManager.create(
      EtebaseItemMetadata(
        itemType: itemType,
        mtime: DateTime.now(),
      ),
      serializer.serialize(item),
    );
  }

  Future<dynamic> _deserializeItem(EtebaseItem etebaseItem) async {
    final metadata = await etebaseItem.getMeta();
    final serializer =
        _serializationRegistry.getSerializer(metadata.itemType ?? itemType);

    final content = await etebaseItem.getContent();
    return serializer.deserialize(content);
  }
}
