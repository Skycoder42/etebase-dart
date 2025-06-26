import 'package:etebase/etebase.dart';

import '../items/items.dart';

abstract interface class RepositoryAdapter<TRecord extends ItemRecord> {
  TRecord createRecord(Repository<TRecord> repository, Item item);
}
