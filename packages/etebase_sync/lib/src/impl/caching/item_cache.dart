import '../../storage/hive/item_info.dart';

abstract class ItemCache {
  Future<ItemInfo?> get(String uid);
}
