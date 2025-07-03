import 'dart:async';

import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

import '../../etebase_sync.dart';
import '../api/exceptions/item_deleted.dart';
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

@internal
extension CollectionConflictResolverX on CollectionConflictResolver {
  @protected
  Future<void> resolveConflict(
    Collection target,
    Collection conflicted,
    ConflictOrigin origin,
  ) async {
    final resolution = await resolveRepositoryConflict(
      colUid: target.uid,
      targetMeta: await target.getMeta<RepositoryMetadata>(),
      targetDeleted: target.isDeleted,
      conflictedMeta: await conflicted.getMeta<RepositoryMetadata>(),
      conflictedDeleted: conflicted.isDeleted,
      origin: origin,
    );
    switch (resolution) {
      case ConflictResolutionDiscard():
      case ConflictResolutionDelete() when target.isDeleted:
        break;
      case ConflictResolutionUpdate() when target.isDeleted:
        throw ItemDeleted(target.uid);

      case ConflictResolutionUpdate(:final meta):
        await target.setMeta<RepositoryMetadata>(meta);
      case ConflictResolutionDelete(:final RepositoryMetadata meta):
        await target.setMeta<RepositoryMetadata>(meta);
        await target.delete();
      case ConflictResolutionDelete():
        await target.delete();
    }
  }
}
