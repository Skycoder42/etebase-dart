import 'package:etebase/etebase.dart';

import '../serialization/serialization_registry.dart';
import '../storage/storage.dart';

abstract class DynamicItemRepository {
  final String colUid;

  final EtebaseItemManager _itemManager;
  final Storage _storage;
  final SerializationRegistry _serializationRegistry;

  DynamicItemRepository({
    required this.colUid,
    required EtebaseItemManager itemManager,
    required Storage storage,
    required SerializationRegistry serializationRegistry,
  })  : _itemManager = itemManager,
        _storage = storage,
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
    await _storage.save(etebaseItem);
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
    String? itemType,
    bool transaction = true,
  }) async {
    final etebaseItem = await _createItem(item, itemType);
    await _storage.save(etebaseItem);

    if (transaction) {
      await _itemManager.transaction([etebaseItem]);
    } else {
      await _itemManager.batch([etebaseItem]);
    }
    await _storage.save(etebaseItem);

    return etebaseItem.getUid();
  }

  Future<List<String>> createMany(
    List<dynamic> items, {
    String? itemType,
    bool transaction = true,
  }) async {
    final etebaseItems = await Stream.fromIterable(items)
        .asyncMap((item) => _createItem(item, itemType))
        .toList();
    await _storage.saveAll(etebaseItems);

    if (transaction) {
      await _itemManager.transaction(etebaseItems);
    } else {
      await _itemManager.batch(etebaseItems);
    }
    await _storage.saveAll(etebaseItems);

    return Stream.fromIterable(etebaseItems)
        .asyncMap((item) => item.getUid())
        .toList();
  }

  Future<void> update(
    String id,
    dynamic item, {
    bool transaction = true,
    String? itemType,
  }) async {
    final etebaseItem = await _storage.load(id);
    if (etebaseItem == null) {
      throw Exception('TODO');
    }

    final serializer = _serializationRegistry.getSerializer(itemType);
    final meta = await etebaseItem.getMeta();
    await etebaseItem.setMeta(meta.copyWith(itemType: itemType));
    await etebaseItem.setContent(serializer.serialize(item));
    await _storage.save(etebaseItem);

    if (transaction) {
      await _itemManager.transaction([etebaseItem]);
    } else {
      await _itemManager.batch([etebaseItem]);
    }
    await _storage.save(etebaseItem);
  }

  Future<void> updateMany(
    Map<String, dynamic> items, {
    bool transaction = true,
    String? itemType,
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
      await _storage.saveAll(data);
      yield* Stream.fromIterable(data).asyncMap(_deserializeItem);

      await etebaseItems.dispose();
    }
  }

  Future<EtebaseItem> _createItem(dynamic item, String? itemType) async {
    final serializer = _serializationRegistry.getSerializer(itemType);
    final etebaseItem = await _itemManager.create(
      EtebaseItemMetadata(
        itemType: itemType,
        mtime: DateTime.now(),
      ),
      serializer.serialize(item),
    );
    return etebaseItem;
  }

  Future<dynamic> _deserializeItem(EtebaseItem etebaseItem) async {
    final metadata = await etebaseItem.getMeta();
    final serializer = _serializationRegistry.getSerializer(metadata.itemType);

    final content = await etebaseItem.getContent();
    return serializer.deserialize(content);
  }
}
