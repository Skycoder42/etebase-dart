import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import '../api/conflict_resolution/conflict_resolver.dart';
import '../api/etebase_sync.dart';
import '../api/exceptions/missing_type_registration_error.dart';
import '../api/online_checker.dart';
import '../api/repository_adapter.dart';
import '../items/items.dart';
import '../sync/sync_config.dart';
import 'caching/cache_manager.dart';
import 'repository_manager_impl.dart';

typedef _Registration<TRecord extends ItemRecord> = ({
  String type,
  RepositoryAdapter<TRecord> adapter,
});

@internal
class EtebaseSyncImpl implements EtebaseSync {
  final OnlineChecker _onlineChecker;
  final ConflictResolver _conflictResolver;
  final Account _account;
  final CacheManager _cache;

  final _repositoryConfig = <Type, _Registration>{};

  EtebaseSyncImpl(
    this._onlineChecker,
    this._conflictResolver,
    this._account,
    this._cache,
  );

  SyncConfig get config => throw UnimplementedError();

  @override
  RepositoryManagerImpl get repositoryManager => RepositoryManagerImpl(
    this,
    _cache,
    _conflictResolver,
    _account.collectionManager,
  );

  @override
  Future<void> dispose() async {
    await Future.wait([_cache.dispose(), Future.sync(_account.dispose)]);
  }

  @override
  void registerType<TRecord extends ItemRecord>(
    String typeName,
    RepositoryAdapter<TRecord> adapter,
  ) => _repositoryConfig[TRecord] = (type: typeName, adapter: adapter);

  String typeFor<TRecord extends ItemRecord>() => _registration<TRecord>().type;

  Repository<TRecord> createRepo<TRecord extends ItemRecord>(
    Collection collection,
  ) {
    throw UnimplementedError();
  }

  _Registration<TRecord> _registration<TRecord extends ItemRecord>() {
    final registration = _repositoryConfig[TRecord];
    if (registration == null) {
      throw MissingTypeRegistrationError(TRecord);
    }
    return registration as _Registration<TRecord>;
  }
}
