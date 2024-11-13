import 'dart:typed_data';

import 'etebase_item_metadata.dart';

/// The dart binding of the EtebaseItem rust class
abstract class EtebaseItem {
  /// The UID of the item
  ///
  /// @param this_ the object handle
  String get uid;

  /// The etag of the item
  ///
  /// @param this_ the object handle
  String get etag;

  /// Check whether the item is marked as deleted
  ///
  /// @param this_ the object handle
  bool get isDeleted;

  /// Check whether the item is missing data that needs to be downloaded
  bool get isMissingContent;

  /// Disposes the item
  Future<void> dispose();

  /// Manually verify the integrity of the item
  ///
  /// This is also done automatically by the API
  ///
  /// @param this_ the object handle
  Future<bool> verify();

  /// Set metadata for the item object
  ///
  /// @param this_ the object handle
  /// @param meta the metadata object to be set for the item
  Future<void> setMeta(EtebaseItemMetadata meta);

  /// Return the metadata of the item
  ///
  /// @param this_ the object handle
  Future<EtebaseItemMetadata> getMeta();

  /// Set the content of the item
  ///
  /// @param this_ the object handle
  /// @param content the content of the item as a byte array
  /// @param content_size the content size
  Future<void> setContent(Uint8List content);

  /// Write the content of the item to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Future<Uint8List> getContent();

  /// Mark the item as deleted
  ///
  /// The item needs to be \ref uploaded `etebase_item_manager_batch` for this to take effect
  ///
  /// @param this_ the object handle
  Future<void> delete({bool preserveContent = false});
}
