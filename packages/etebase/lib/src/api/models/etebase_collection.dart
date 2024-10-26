import 'dart:typed_data';

import 'etebase_collection_access_level.dart';
import 'etebase_item.dart';
import 'etebase_item_metadata.dart';

/// The dart binding of the EtebaseCollection rust class
abstract class EtebaseCollection implements EtebaseItem {
  /// Clone a collection object
  ///
  /// @param this_ the object handle
  @override
  EtebaseCollection clone();

  /// Manually verify the integrity of the collection
  ///
  /// This is also done automatically by the API
  ///
  /// @param this_ the object handle
  @override
  bool verify();

  /// Set metadata for the collection object
  ///
  /// @param this_ the object handle
  /// @param meta the metadata object to be set for the collection
  @override
  set meta(EtebaseItemMetadata meta);

  /// Return the metadata of the collection
  ///
  /// @param this_ the object handle
  @override
  EtebaseItemMetadata get meta;

  /// Set metadata for the collection object from a byte array
  ///
  /// @param this_ the object handle
  /// @param meta the metadata for the collection. This needs to be a valid `EtebaseItemMetadata`-like struct encoded using `msgpack`.
  /// @param meta_size the metadata size
  @override
  set metaRaw(Uint8List meta);

  /// Write the metadata of the collection to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  @override
  Uint8List get metaRaw;

  /// Set the content of the collection
  ///
  /// @param this_ the object handle
  /// @param content the content of the collection as a byte array
  /// @param content_size the content size
  @override
  set content(Uint8List content);

  /// Write the content of the collection to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  @override
  Uint8List get content;

  /// Mark the collection as deleted
  ///
  /// The collection needs to be \ref uploaded `etebase_collection_manager_upload` for this to take effect
  ///
  /// @param this_ the object handle
  @override
  void delete();

  /// Check whether the collection is marked as deleted
  ///
  /// @param this_ the object handle
  @override
  bool get isDeleted;

  /// The UID of the collection
  ///
  /// @param this_ the object handle
  @override
  String get uid;

  /// The etag of the collection
  ///
  /// @param this_ the object handle
  @override
  String get etag;

  /// The sync token for the collection
  ///
  /// The sync token reflects changes to the collection properties or its items on the server
  ///
  /// @param this_ the object handle
  String? get stoken;

  /// The type of the collection
  ///
  /// @param this_ the object handle
  String get collectionType;

  /// Return the access level of the collection for the current user
  ///
  /// @param this_ the object handle
  EtebaseCollectionAccessLevel get accessLevel;
}
