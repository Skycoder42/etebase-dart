import 'package:etebase/etebase.dart';

abstract interface class Storage {
  Future<EtebaseItem?> load(String uid);

  Future<void> save(EtebaseItem item);
  Future<void> saveAll(Iterable<EtebaseItem> items);
}
