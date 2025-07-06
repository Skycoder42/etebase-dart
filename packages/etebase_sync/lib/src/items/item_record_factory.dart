import 'package:etebase/etebase.dart';

import 'items.dart';

abstract interface class ItemRecordFactory<TRecord extends ItemRecord> {
  TRecord createRecord(Repository<TRecord> repository, Item item);
}
