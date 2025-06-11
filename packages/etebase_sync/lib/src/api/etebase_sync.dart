import 'dart:async';

import 'package:etebase/etebase.dart';

import 'repository.dart';

typedef RepositoryFactory<T extends Object> =
    FutureOr<Repository<T>> Function(Collection collection);

abstract interface class EtebaseSync {
  void registerRepositoryType<T extends Object>(
    String typeName,
    RepositoryFactory<T> factory,
  );
}
