// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'etebase_item_metadata.freezed.dart';
part 'etebase_item_metadata.g.dart';

/// The type definition of the [EtebaseItemMetadata.copyWith] method
typedef EtebaseItemMetadataCopyWith
    = _$EtebaseItemMetadataImplCopyWith<EtebaseItemMetadata>;

/// The dart binding of the EtebaseItemMetadata rust class
abstract interface class EtebaseItemMetadata {
  /// The item color in `#RRGGBB` or `#RRGGBBAA` format
  String? get color;

  /// The item description
  String? get description;

  /// Modification time of the item
  DateTime? get mtime;

  /// The item name
  String? get name;

  /// The item type
  String? get itemType;

  /// Create a copy of EtebaseItemMetadata
  /// with the given fields replaced by the non-null parameter values.
  EtebaseItemMetadataCopyWith get copyWith;

  /// Serializes this EtebaseItemMetadata to a JSON map.
  Map<String, dynamic> toJson();

  const factory EtebaseItemMetadata({
    String? color,
    String? description,
    DateTime? mtime,
    String? name,
    String? itemType,
  }) = _EtebaseItemMetadataImpl;

  factory EtebaseItemMetadata.fromJson(Map<String, dynamic> json) =>
      _$EtebaseItemMetadataImplFromJson(json);
}

@Freezed(fromJson: true, toJson: true, copyWith: true)
sealed class _EtebaseItemMetadataImpl
    with _$EtebaseItemMetadataImpl
    implements EtebaseItemMetadata {
  @JsonSerializable(includeIfNull: false)
  const factory _EtebaseItemMetadataImpl({
    String? color,
    String? description,
    DateTime? mtime,
    String? name,
    String? itemType,
  }) = __EtebaseItemMetadataImpl;
}
