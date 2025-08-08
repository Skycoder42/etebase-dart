import 'package:etebase/etebase.dart';

import 'account_store.dart';
import 'collection_store.dart';
import 'item_store.dart';

abstract interface class StorageManager {
  Future<void> init();

  Future<void> dispose();

  Future<AccountStore> createAccountStore();

  Future<CollectionStore> createCollectionStore(
    CollectionManager collectionManager,
  );

  Future<ItemStore> createItemStore(
    Collection collection,
    ItemManager itemManager,
  );

  Future<void> eraseItemStore(String colUid);

  Future<void> erase();
}
