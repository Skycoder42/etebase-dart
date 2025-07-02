import 'dart:async';

import '../../etebase_sync.dart';
import '../api/exceptions/unresolved_conflict.dart';
import '../api/models/conflict_origin.dart';
import '../api/models/etebase_target.dart';
import 'conflict_resolution.dart';

class CollectionConflictResolver {
  const CollectionConflictResolver();

  FutureOr<String> resolveMultiplePrimaryCollections(
    String collectionType,
    Map<String, RepositoryMetadata> collectionData,
  ) => throw UnresolvedConflict(
    EtebaseTarget.collection,
    'Found ${collectionData.length} primary collections '
    'for type "$collectionType"',
  );

  FutureOr<ConflictResolution> resolveRepositoryConflict({
    required String colUid,
    required RepositoryMetadata targetMeta,
    required bool targetDeleted,
    required RepositoryMetadata conflictedMeta,
    required bool conflictedDeleted,
    required ConflictOrigin origin,
  }) => const ConflictResolution.discard();
}
