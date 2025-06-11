import 'package:etebase/etebase.dart';

abstract class SyncCacheImpl {
  Future<void> dispose();

  Future<void> saveStokenFor(String collectionType, String? stoken);

  Future<String?> loadStokenFor(String collectionType);

  Iterable<String> collectionList(String collectionType);

  Future<Collection?> collectionGet(String colUid);

  Future<void> collectionSet(Collection collection, {bool needsUpload = false});
}
