// ignore_for_file: invalid_annotation_target

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_metadata.freezed.dart';
part 'custom_metadata.g.dart';

@Freezed(fromJson: true, toJson: true, copyWith: true)
sealed class CustomMetadata with _$CustomMetadata implements ItemMetadata {
  @JsonSerializable(includeIfNull: false)
  const factory({
    String? color,
    String? description,
    @dateTimeMillis DateTime? mtime,
    String? name,
    String? itemType,
    @Default(false) bool confirmed,
  }) = _CustomMetadata;

  factory fromJson(Map<String, dynamic> json) => _$CustomMetadataFromJson(json);
}
