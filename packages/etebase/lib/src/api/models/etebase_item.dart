import 'dart:typed_data';

import 'base/etebase_cloneable.dart';
import 'etebase_item_metadata.dart';

/// The dart binding of the EtebaseItem rust class
abstract class EtebaseItem implements EtebaseCloneable<EtebaseItem> {
  Future<void> dispose();

  /// Clone an item object
  ///
  /// @param this_ the object handle
  @override
  EtebaseItem clone();

  /// Manually verify the integrity of the item
  ///
  /// This is also done automatically by the API
  ///
  /// @param this_ the object handle
  bool verify();

  /// Set metadata for the item object
  ///
  /// @param this_ the object handle
  /// @param meta the metadata object to be set for the item
  set meta(EtebaseItemMetadata meta);

  /// Return the metadata of the item
  ///
  /// @param this_ the object handle
  EtebaseItemMetadata get meta;

  /// Set metadata for the item object from a byte array
  ///
  /// @param this_ the object handle
  /// @param meta the metadata for the item. This needs to be a valid `EtebaseItemMetadata`-like struct encoded using `msgpack`.
  /// @param meta_size the metadata size
  set metaRaw(Uint8List meta);

  /// Write the metadata of the item to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Uint8List get metaRaw;

  /// Set the content of the item
  ///
  /// @param this_ the object handle
  /// @param content the content of the item as a byte array
  /// @param content_size the content size
  set content(Uint8List content);

  /// Write the content of the item to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Uint8List get content;

  /// Mark the item as deleted
  ///
  /// The item needs to be \ref uploaded `etebase_item_manager_batch` for this to take effect
  ///
  /// @param this_ the object handle
  void delete();

  /// Check whether the item is marked as deleted
  ///
  /// @param this_ the object handle
  bool get isDeleted;

  /// The UID of the item
  ///
  /// @param this_ the object handle
  String get uid;

  /// The etag of the item
  ///
  /// @param this_ the object handle
  String get etag;
}
