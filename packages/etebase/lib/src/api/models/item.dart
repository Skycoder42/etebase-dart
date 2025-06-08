// coverage:ignore-file

import 'dart:typed_data';

import '../managers/etebase_item_manager.dart';
import 'collection.dart';
import 'item_metadata.dart';

/// Items belong to [Collection]s and are where data is stored.
///
/// Items have two pieces of data associated with them:
/// * [ItemMetadata] - contains meta information like name and
/// modification time.
/// * Content ([Uint8List]) - a buffer containing arbitrary binary data.
abstract class Item {
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
  Future<void> verify();

  /// Set [meta]data for the item object
  Future<void> setMeta<TMeta extends ItemMetadata>(TMeta meta);

  /// Return the [ItemMetadata] of the item
  Future<TMeta> getMeta<TMeta extends ItemMetadata>();

  /// Set the [content] of the item.
  ///
  /// When your [content] comes from a large data source that also supports
  /// [Stream]s, consider using [setContentStream] instead.
  Future<void> setContent(Uint8List content);

  /// Set the [content] of the item by listening to the given stream.
  ///
  /// This variant of [setContent] can be used if you want to process large
  /// contents.
  Future<void> setContentStream(Stream<List<int>> content);

  /// Return the content of the item as a [Uint8List].
  ///
  /// When your item holds very large content and the processor can handle
  /// [Stream]s, consider using [getContentStream] instead.
  Future<Uint8List> getContent();

  /// Return the content of the item as a [Stream<Uint8List>].
  ///
  /// This variant of [getContent] can be used if you want to process large
  /// contents.
  Stream<Uint8List> getContentStream();

  /// Mark the item as deleted.
  ///
  /// The item needs to be uploaded via [EtebaseItemManager.batch] for this to
  /// take effect.
  Future<void> delete({bool preserveContent = false});
}
