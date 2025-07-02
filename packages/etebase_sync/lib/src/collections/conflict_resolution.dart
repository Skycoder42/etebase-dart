import 'package:freezed_annotation/freezed_annotation.dart';

import '../../etebase_sync.dart';

part 'conflict_resolution.freezed.dart';

@freezed
sealed class ConflictResolution with _$ConflictResolution {
  const factory ConflictResolution.discard() = ConflictResolutionDiscard;
  const factory ConflictResolution.update(RepositoryMetadata meta) =
      ConflictResolutionUpdate;
  const factory ConflictResolution.delete([RepositoryMetadata? meta]) =
      ConflictResolutionDelete;

  const ConflictResolution._();
}
