import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import '../api/conflict_resolution/conflict_resolver.dart';
import '../api/etebase_sync.dart';
import '../api/exceptions/missing_type_registration_error.dart';
import '../api/item_record.dart';
import '../api/online_checker.dart';
import '../api/repository.dart';
import '../api/repository_adapter.dart';
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

  Stream<T> streamOnline<T>(
    Stream<T> Function() callback, {
    Stream<T> Function()? whenOffline,
  }) async* {
    if (await _onlineChecker.isOnline()) {
      try {
        yield* callback();
      } on ConnectionProblem {
        // break
      } on TemporaryServerProblem {
        // break
      } catch (_) {
        rethrow;
      }
    }

    yield* whenOffline?.call() ?? const Stream.empty();
  }

  _Registration<TRecord> _registration<TRecord extends ItemRecord>() {
    final registration = _repositoryConfig[TRecord];
    if (registration == null) {
      throw MissingTypeRegistrationError(TRecord);
    }
    return registration as _Registration<TRecord>;
  }
}
