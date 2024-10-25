import 'package:freezed_annotation/freezed_annotation.dart';

part 'etebase_item_metadata.freezed.dart';

/// The dart binding of the EtebaseItemMetadata rust class
@freezed
sealed class EtebaseItemMetadata with _$EtebaseItemMetadata {
  /// Create a new metadata object
  ///
  /// Should be destroyed with `etebase_item_metadata_destroy`
  const factory EtebaseItemMetadata({
    /// The item color in `#RRGGBB` or `#RRGGBBAA` format
    ///
    /// @param this_ the object handle
    String? color,

    /// The item description
    ///
    /// @param this_ the object handle
    String? description,

    /// Modification time of the item
    ///
    /// @param this_ the object handle
    DateTime? mtime,

    /// The item name
    ///
    /// @param this_ the object handle
    String? name,

    /// The item type
    ///
    /// @param this_ the object handle
    String? itemType,
  }) = _EtebaseItemMetadata;
}
