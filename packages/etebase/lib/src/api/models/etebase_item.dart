import 'dart:typed_data';

import '../managers/etebase_item_manager.dart';
import 'etebase_collection.dart';
import 'etebase_item_metadata.dart';

/// Items belong to [EtebaseCollection]s and are where data is stored.
///
/// Items have two pieces of data associated with them:
/// * [EtebaseItemMetadata] - contains meta information like name and
/// modification time.
/// * Content ([Uint8List]) - a buffer containing arbitrary binary data.
abstract class EtebaseItem {
  /// The UID of the item.
  String get uid;

  /// The etag of the item.
  String get etag;

  /// Check whether the item is marked as deleted.
  bool get isDeleted;

  /// Check whether the item is missing data that needs to be downloaded.
  ///
  /// See [EtebaseItemManager.downloadContent] for more details.
  bool get isMissingContent;

  /// Disposes of the item and clears all cryptographic keys from memory.
  void dispose();

  /// Manually verify the integrity of the item.
  ///
  /// This is also done automatically by the API.
  Future<bool> verify();

  /// Set [meta]data for the item object
  Future<void> setMeta<TMeta extends EtebaseItemMetadata>(TMeta meta);

  /// Return the [EtebaseItemMetadata] of the item
  Future<TMeta> getMeta<TMeta extends EtebaseItemMetadata>();

  /// Set the [content] of the item.
  Future<void> setContent(Uint8List content);

  /// Return the content of the item as a [Uint8List].
  Future<Uint8List> getContent();

  /// Mark the item as deleted.
  ///
  /// The item needs to be uploaded via [EtebaseItemManager.batch] for this to
  /// take effect.
  Future<void> delete({bool preserveContent = false});
}
