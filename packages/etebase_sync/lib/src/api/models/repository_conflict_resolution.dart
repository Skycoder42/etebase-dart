import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../etebase_sync.dart';

part 'repository_conflict_resolution.freezed.dart';

@freezed
sealed class RepositoryConflictResolution with _$RepositoryConflictResolution {
  const factory RepositoryConflictResolution.local([RepositoryMetadata? meta]) =
      RepositoryConflictResolutionLocal;

  const factory RepositoryConflictResolution.remote([
    RepositoryMetadata? meta,
  ]) = RepositoryConflictResolutionRemote;
}
