// coverage:ignore-file
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../impl/codec/date_time_millis_converter.dart';

// reexport converter here, as it is needed for custom implementations
export '../../impl/codec/date_time_millis_converter.dart';

part 'etebase_item_metadata.freezed.dart';
part 'etebase_item_metadata.g.dart';

/// The type definition of the [EtebaseItemMetadataCopyWithX.copyWith] method
typedef EtebaseItemMetadataCopyWith =
    $EtebaseItemMetadataImplCopyWith<EtebaseItemMetadata>;

/// Metadata of the item.
///
/// If you want to create your own custom metadata, you must always implement
/// this interface. You will also have to provide your own from and to json
/// converters and a [copyWith] implementation. Here is a simple example on how
/// to do this with `freezed` and `json_serializable`:
///
/// ```dart
/// @freezed
/// sealed class CustomMetadata
///     with _$CustomMetadata
///     implements EtebaseItemMetadata {
///   @JsonSerializable(includeIfNull: false) // recommended, but not required
///   const factory CustomMetadata({
///     // default attributes from EtebaseItemMetadata
///     String? color,
///     @dateTimeMillis DateTime? mtime,
///     String? name,
///     String? itemType,
///     // your attributes
///     String myCustomProperty,
///   }) = _CustomMetadata;
///
///   factory CustomMetadata.fromJson(Map<String, dynamic> json) =>
///       _$CustomMetadataFromJson(json);
/// }
/// ```
abstract interface class EtebaseItemMetadata {
  /// The item type.
  String? get itemType;

  /// The item name.
  String? get name;

  /// Modification time of the item.
  ///
  /// Must be encoded as milliseconds since the start of the epoch.
  ///
  /// You can use the [dateTimeMillis] converter when working with
  /// `json_serializable`.
  DateTime? get mtime;

  /// The item description.
  String? get description;

  /// The item color in `#RRGGBB` or `#RRGGBBAA` format.
  String? get color;

  /// Serializes this EtebaseItemMetadata to a JSON map.
  Map<String, dynamic> toJson();

  /// Default constructor.
  const factory EtebaseItemMetadata({
    String? color,
    String? description,
    DateTime? mtime,
    String? name,
    String? itemType,
  }) = _EtebaseItemMetadataImpl;

  /// Deserializes the [EtebaseItemMetadata] from a [json] object.
  factory EtebaseItemMetadata.fromJson(Map<String, dynamic> json) =>
      _$EtebaseItemMetadataImplFromJson(json);
}

/// Helper extension to be able to call [copyWith] on [EtebaseItemMetadata]
/// without making the method part of the interface
extension EtebaseItemMetadataCopyWithX on EtebaseItemMetadata {
  /// Create a copy of [EtebaseItemMetadata] with the given fields replaced by
  /// the non-null parameter values.
  EtebaseItemMetadataCopyWith get copyWith => switch (this) {
    final EtebaseItemMetadataImpl impl =>
      impl.copyWith as EtebaseItemMetadataCopyWith,
    _ => throw UnsupportedError(
      'The copyWith extension can only be invoked on EtebaseItemMetadata. '
      'When implementing custom metadata, you must provide your own '
      'implementation.',
    ),
  };
}

@internal
@Freezed(fromJson: true, toJson: true, copyWith: true)
sealed class EtebaseItemMetadataImpl with _$EtebaseItemMetadataImpl {
  @JsonSerializable(includeIfNull: false)
  @Implements<EtebaseItemMetadata>()
  const factory EtebaseItemMetadataImpl({
    String? color,
    String? description,
    @dateTimeMillis DateTime? mtime,
    String? name,
    String? itemType,
  }) = _EtebaseItemMetadataImpl;
}
