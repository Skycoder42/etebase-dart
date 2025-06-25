import '../items/item_record.dart';

abstract class Repository<TRecord extends ItemRecord> {
  Future<TRecord> create();

  Future<TRecord?> open(String uid);
}
