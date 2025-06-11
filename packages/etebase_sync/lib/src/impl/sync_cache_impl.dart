import 'package:etebase/etebase.dart';

abstract class SyncCacheImpl {
  Future<void> dispose();

  Future<void> collectionSet(
    CollectionManager colMgr,
    Collection collection, {
    bool saveContent = true,
  });

  Future<Collection?> collectionGet(CollectionManager colMgr, String colUid);

  Future<void> collectionUploadNeeded(String colUid);
}
