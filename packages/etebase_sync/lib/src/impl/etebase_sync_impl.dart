import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import '../api/conflict_resolution/conflict_resolver.dart';
import '../api/etebase_sync.dart';
import '../api/exceptions/missing_type_registration_error.dart';
import '../api/online_checker.dart';
import '../api/repository.dart';
import 'repository_manager_impl.dart';
import 'sync_cache_impl.dart';

typedef _Registration<T extends Object> = ({
  String type,
  RepositoryFactory<T> factory,
});

@internal
class EtebaseSyncImpl implements EtebaseSync {
  final OnlineChecker _onlineChecker;
  final ConflictResolver _conflictResolver;
  final Account _account;
  final SyncCacheImpl _syncCache;

  final _repositoryConfig = <Type, _Registration>{};

  EtebaseSyncImpl(
    this._onlineChecker,
    this._conflictResolver,
    this._account,
    this._syncCache,
  );

  @override
  RepositoryManagerImpl get repositoryManager => RepositoryManagerImpl(
    this,
    _syncCache,
    _conflictResolver,
    _account.collectionManager,
  );

  @override
  Future<void> dispose() async {
    await Future.wait([_syncCache.dispose(), Future.sync(_account.dispose)]);
  }

  @override
  void registerRepositoryType<T extends Object>(
    String typeName,
    RepositoryFactory<T> factory,
  ) => _repositoryConfig[T] = (type: typeName, factory: factory);

  String typeFor<T extends Object>() => _registration<T>().type;

  Future<Repository<T>> createRepo<T extends Object>(
    Collection collection,
  ) async {
    final (type: _, :factory) = _registration<T>();
    return await factory(collection);
  }

  Future<T> runOnline<T>(
    FutureOr<T> Function() callback, {
    FutureOr<T> Function()? whenOffline,
  }) async {
    if (await _onlineChecker.isOnline()) {
      try {
        return await callback();
      } on ConnectionProblem {
        // break
      } on TemporaryServerProblem {
        // break
      } catch (_) {
        rethrow;
      }
    }

    return whenOffline?.call() ?? (null as T);
  }

  _Registration<T> _registration<T extends Object>() {
    final registration = _repositoryConfig[T];
    if (registration == null) {
      throw MissingTypeRegistrationError(T);
    }
    return registration as _Registration<T>;
  }
}
