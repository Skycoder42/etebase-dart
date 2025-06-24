import 'package:etebase/etebase.dart';

import 'item_record.dart';

abstract interface class RepositoryAdapter<TRecord extends ItemRecord> {
  TRecord createRecord(Item item);
}
