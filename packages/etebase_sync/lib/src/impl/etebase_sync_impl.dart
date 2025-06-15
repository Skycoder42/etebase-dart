import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import '../api/etebase_sync.dart';
import '../api/exceptions/missing_type_registration_error.dart';
import '../api/repository.dart';

typedef _Registration<T extends Object> = ({
  String type,
  RepositoryFactory<T> factory,
});

@internal
class EtebaseSyncImpl implements EtebaseSync {
  final _repositoryConfig = <Type, _Registration>{};

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
    try {
      return await callback();
    } on ConnectionProblem {
      // break
    } on TemporaryServerProblem {
      // break
    } catch (_) {
      rethrow;
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
