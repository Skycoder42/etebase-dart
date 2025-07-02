import 'package:etebase/etebase.dart';

import 'collection_store.dart';
import 'item_store.dart';

abstract interface class StorageManager {
  Future<void> init();

  Future<void> dispose();

  Future<ItemStore> createItemStore(
    Collection collection,
    ItemManager itemManager,
  );

  Future<CollectionStore> createCollectionStore(CollectionManager itemManager);
}
