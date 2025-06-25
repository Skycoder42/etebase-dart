import 'package:etebase/etebase.dart';

import '../items/item_record.dart';
import 'repository.dart';

abstract interface class RepositoryAdapter<TRecord extends ItemRecord> {
  TRecord createRecord(
    Repository<TRecord> repository,
    Item item, {
    bool readOnly = false,
  });
}
