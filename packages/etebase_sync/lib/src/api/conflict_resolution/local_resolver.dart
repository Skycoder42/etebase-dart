import 'dart:async';

import '../models/conflict_origin.dart';
import '../models/repository_conflict_resolution.dart';
import '../models/repository_metadata.dart';
import 'conflict_resolver.dart';

class LocalResolver extends ConflictResolver {
  const LocalResolver();

  @override
  FutureOr<RepositoryConflictResolution> resolveRepositoryConflict({
    required String colUid,
    required RepositoryMetadata localMeta,
    required RepositoryMetadata remoteMeta,
    required bool deletedLocally,
    required bool deletedRemotely,
    required ConflictOrigin origin,
  }) => const RepositoryConflictResolution.local();
}
