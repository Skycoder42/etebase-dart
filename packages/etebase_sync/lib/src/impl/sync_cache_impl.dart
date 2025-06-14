import 'package:etebase/etebase.dart';

enum SetMode { fromRemote, preUpload, postUpload }

abstract class SyncCacheImpl {
  Future<void> dispose();

  Future<void> saveStokenFor(String collectionType, String? stoken);

  Future<String?> loadStokenFor(String collectionType);

  Iterable<String> collectionList(String collectionType);

  Future<Collection?> collectionGet(String colUid);

  // TODO handle delete from cache when deleted!
  Future<void> collectionSet(
    Collection collection, [
    SetMode mode = SetMode.fromRemote,
  ]);
}
