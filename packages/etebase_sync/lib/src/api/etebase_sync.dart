import 'dart:async';

import 'item_record.dart';
import 'repository_adapter.dart';
import 'repository_manager.dart';

abstract interface class EtebaseSync {
  RepositoryManager get repositoryManager;

  Future<void> dispose();

  void registerType<TRecord extends ItemRecord>(
    String typeName,
    RepositoryAdapter<TRecord> adapter,
  );
}
