import 'package:etebase/etebase.dart';

import 'item_record.dart';
import 'repository.dart';

abstract interface class RepositoryAdapter<TRecord extends ItemRecord> {
  TRecord createRecord(Repository<TRecord> repository, Item item);
}
