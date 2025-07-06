// ignore_for_file: invalid_annotation_target for freezed

/// @docImport '../items/items.dart';
library;

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_metadata.freezed.dart';
part 'repository_metadata.g.dart';

/// A custom [ItemMetadata] implementation that adds some additional information
/// for [Repository] classes.
@freezed
sealed class RepositoryMetadata
    with _$RepositoryMetadata
    implements ItemMetadata {
  @JsonSerializable(includeIfNull: false)
  const factory RepositoryMetadata({
    // ItemMetadata
    String? color,
    String? description,
    @dateTimeMillis DateTime? mtime,
    String? name,
    String? itemType,
    // custom properties
    /// Marks a collection as the primary collection for the given
    /// [Collection.collectionType].
    @Default(false) bool primary,
  }) = _RepositoryMetadata;

  factory RepositoryMetadata.fromJson(Map<String, dynamic> json) =>
      _$RepositoryMetadataFromJson(json);
}
