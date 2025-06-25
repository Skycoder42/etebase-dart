import 'dart:async';

import '../models/etebase_target.dart';
import '../exceptions/unresolved_conflict.dart';
import '../models/conflict_origin.dart';
import '../models/conflict_resolution.dart';
import '../models/repository_metadata.dart';
import '../models/value_or_deleted.dart';
import 'local_resolver.dart';
import 'remote_resolver.dart';

class ConflictResolver {
  const ConflictResolver();

  const factory ConflictResolver.local() = LocalResolver;

  const factory ConflictResolver.remote() = RemoteResolver;

  FutureOr<String> resolveMultiplePrimaryCollections(
    String collectionType,
    Map<String, RepositoryMetadata> collectionData,
  ) => throw UnresolvedConflict(
    EtebaseTarget.collection,
    'Found ${collectionData.length} primary collections '
    'for type "$collectionType"',
  );

  FutureOr<ConflictResolution<RepositoryMetadata>> resolveRepositoryConflict({
    required String colUid,
    required RepositoryMetadata localMeta,
    required RepositoryMetadata remoteMeta,
    required bool deletedLocally,
    required bool deletedRemotely,
    required ConflictOrigin origin,
  }) => throw UnresolvedConflict(
    EtebaseTarget.collection,
    'Metadata of collection with uid "$colUid" has been modified '
    'locally and on the remote (Origin: ${origin.name})',
    uid: colUid,
    origin: origin,
  );

  FutureOr<ConflictResolution<ValueOrDeleted<TValue>>>
  resolveItemConflict<TValue extends Object>({
    required String itemUid,
    required ValueOrDeleted<TValue> local,
    required ValueOrDeleted<TValue> remote,
    required ConflictOrigin origin,
  }) => throw UnresolvedConflict(
    EtebaseTarget.item,
    'Content of item with uid "$itemUid" has been modified '
    'locally and on the remote (Origin: ${origin.name})',
    uid: itemUid,
    origin: origin,
  );
}
