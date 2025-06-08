// coverage:ignore-file

import 'dart:typed_data';

import '../managers/collection_manager.dart';
import 'collection_access_level.dart';
import 'item.dart';
import 'item_metadata.dart';

/// A collection of [Item]s.
///
/// Like [Item]s, collections have two pieces of data associated with
/// them:
/// * [ItemMetadata] - contains meta information like name and
/// modification time.
/// * Content ([Uint8List]) - a buffer containing arbitrary binary data.
///
/// They also have an immutable type and an associated sync token. The
/// [Item]s within that collection can be fetched using the
/// [CollectionManager.getItemManager].
abstract class Collection implements Item {
  /// The sync token for the collection.
  ///
  /// The sync token reflects changes to the collection properties or its
  /// [Item]s on the server.
  String? get stoken;

  /// The type of the collection.
  String get collectionType;

  /// Return the access level of the collection for the current user.
  CollectionAccessLevel get accessLevel;
}
