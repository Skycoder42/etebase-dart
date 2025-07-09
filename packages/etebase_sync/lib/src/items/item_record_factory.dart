import 'package:etebase/etebase.dart';

import 'items.dart';

typedef ItemRecordFactory<TRecord extends ItemRecord> =
    TRecord Function(Repository<TRecord> repository, Item item);
