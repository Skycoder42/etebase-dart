import 'dart:async';

import 'package:etebase/etebase.dart';

typedef OnSavedCb = FutureOr<void> Function();

abstract interface class Storage {
  Future<EtebaseItem?> load(String uid);

  void save(EtebaseItem item);

  void delete(String uid);
}
