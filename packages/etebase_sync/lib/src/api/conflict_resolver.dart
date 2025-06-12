import 'dart:async';

import 'exceptions/unresolved_conflict.dart';
import 'models/repository_metadata.dart';

class ConflictResolver {
  FutureOr<String> resolveMultiplePrimaryCollections(
    String collectionType,
    Map<String, RepositoryMetadata> collectionData,
  ) => throw UnresolvedConflict(
    'Found ${collectionData.length} primary collections '
    'for type "$collectionType"',
  );
}
