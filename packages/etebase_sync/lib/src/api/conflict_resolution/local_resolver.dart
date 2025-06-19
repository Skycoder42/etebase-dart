import 'dart:async';

import '../models/conflict_origin.dart';
import '../models/conflict_resolution.dart';
import '../models/repository_metadata.dart';
import '../models/value_or_deleted.dart';
import 'conflict_resolver.dart';

class LocalResolver extends ConflictResolver {
  const LocalResolver();

  @override
  FutureOr<ConflictResolution<RepositoryMetadata>> resolveRepositoryConflict({
    required String colUid,
    required RepositoryMetadata localMeta,
    required RepositoryMetadata remoteMeta,
    required bool deletedLocally,
    required bool deletedRemotely,
    required ConflictOrigin origin,
  }) => const ConflictResolution.local();

  @override
  FutureOr<ConflictResolution<ValueOrDeleted<TValue>>>
  resolveItemConflict<TValue extends Object>({
    required String itemUid,
    required ValueOrDeleted<TValue> local,
    required ValueOrDeleted<TValue> remote,
    required ConflictOrigin origin,
  }) => const ConflictResolution.local();
}
