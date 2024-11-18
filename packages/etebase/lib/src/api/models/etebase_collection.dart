import 'dart:typed_data';

import '../managers/etebase_collection_manager.dart';
import 'etebase_collection_access_level.dart';
import 'etebase_item.dart';
import 'etebase_item_metadata.dart';

/// A collection of [EtebaseItem]s.
///
/// Like [EtebaseItem]s, collections have two pieces of data associated with
/// them:
/// * [EtebaseItemMetadata] - contains meta information like name and
/// modification time.
/// * Content ([Uint8List]) - a buffer containing arbitrary binary data.
///
/// They also have an immutable type and an associated sync token. The
/// [EtebaseItem]s within that collection can be fetched using the
/// [EtebaseCollectionManager.getItemManager].
abstract class EtebaseCollection implements EtebaseItem {
  /// The sync token for the collection.
  ///
  /// The sync token reflects changes to the collection properties or its
  /// [EtebaseItem]s on the server.
  String? get stoken;

  /// The type of the collection.
  String get collectionType;

  /// Return the access level of the collection for the current user.
  EtebaseCollectionAccessLevel get accessLevel;
}
