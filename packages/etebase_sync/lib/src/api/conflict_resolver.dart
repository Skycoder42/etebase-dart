import 'dart:async';

import 'exceptions/unresolved_conflict.dart';
import 'models/conflict_origin.dart';
import 'models/repository_conflict_resolution.dart';
import 'models/repository_metadata.dart';

class ConflictResolver {
  FutureOr<String> resolveMultiplePrimaryCollections(
    String collectionType,
    Map<String, RepositoryMetadata> collectionData,
  ) => throw UnresolvedConflict(
    ConflictTarget.collection,
    'Found ${collectionData.length} primary collections '
    'for type "$collectionType"',
  );

  FutureOr<RepositoryConflictResolution> resolveRepositoryConflict({
    required String colUid,
    required RepositoryMetadata localMeta,
    required RepositoryMetadata remoteMeta,
    required bool deletedLocally,
    required bool deletedRemotely,
    required ConflictOrigin origin,
  }) => throw UnresolvedConflict(
    ConflictTarget.collection,
    'Metadata of collection with uid "$colUid" has been modified '
    'locally and on the remote (Origin: ${origin.name})',
    uid: colUid,
    origin: origin,
  );
}
