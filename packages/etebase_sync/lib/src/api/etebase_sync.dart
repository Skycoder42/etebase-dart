import 'dart:async';

import 'package:etebase/etebase.dart';

import 'repository.dart';
import 'repository_manager.dart';

typedef RepositoryFactory<T extends Object> =
    FutureOr<Repository<T>> Function(Collection collection);

abstract interface class EtebaseSync {
  RepositoryManager get repositoryManager;

  Future<void> dispose();

  void registerRepositoryType<T extends Object>(
    String typeName,
    RepositoryFactory<T> factory,
  );
}
