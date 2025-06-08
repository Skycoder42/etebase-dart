import 'dart:typed_data';

import '../models/fetch_options.dart';
import '../models/item.dart';
import '../models/item_metadata.dart';
import '../models/list_response.dart';

/// A callback to receive progress for when an items content is uploaded or
/// downloaded separately.
typedef ContentProgressCallback = void Function(int current, int total);

/// A manager for managing [Item] operations like creation and fetching.
abstract class ItemManager {
  /// Disposes of the instance and clears all cryptographic keys from memory.
  void dispose();

  /// Create a new [Item].
  ///
  /// The [meta] and [content] are defining the data of the item.
  ///
  /// {@macro create_from_stream}
  ///
  /// {@macro meta_registration}
  Future<Item> create<TMeta extends ItemMetadata>(
    TMeta meta,
    Uint8List content,
  );

  /// Fetch a single [Item] from the server using its [itemUid].
  ///
  /// {@macro fetch_options}
  Future<Item> fetch(String itemUid, [ItemFetchOptions? fetchOptions]);

  /// Fetch all [Item] of a collection and return a
  /// [ItemListResponse].
  ///
  /// {@macro fetch_options}
  Future<ItemListResponse<Item>> list([ItemFetchOptions? fetchOptions]);

  /// Fetch and return a [IteratorListResponse] of [Item] with
  /// each item as a revision of the given [item].
  ///
  /// {@macro fetch_options}
  Future<IteratorListResponse<Item>> itemRevisions(
    Item item, [
    RevisionFetchOptions? fetchOptions,
  ]);

  /// Fetch the latest revision of the supplied [items] from the server and
  /// return a [ItemListResponse] of [Item]s.
  ///
  /// {@macro fetch_options}
  Future<ItemListResponse<Item>> fetchUpdates(
    List<Item> items, [
    ItemFetchOptions? fetchOptions,
  ]);

  /// Fetch multiple [Item]s using their [itemUids] and return a
  /// [ItemListResponse].
  ///
  /// See [fetch] for fetching a single [Item].
  ///
  /// {@macro fetch_options}
  Future<ItemListResponse<Item>> fetchMulti(
    List<String> itemUids, [
    ItemFetchOptions? fetchOptions,
  ]);

  /// Upload the supplied [items] to the server.
  ///
  /// {@template deps}
  /// The optional [deps] can be used to specify additional [Item]s that
  /// are dependencies of the uploaded [items]. The upload will fail if the
  /// [deps] have changed remotely.
  /// {@endtemplate}
  ///
  /// {@macro fetch_options}
  Future<void> batch(
    List<Item> items, {
    List<Item>? deps,
    ItemFetchOptions? options,
  });

  /// Upload the supplied [items] to the server using a transaction.
  ///
  /// {@macro deps}
  ///
  /// {@macro fetch_options}
  Future<void> transaction(
    List<Item> items, {
    List<Item>? deps,
    ItemFetchOptions? options,
  });

  /// Pre-upload the [item]s content - use it with large files.
  ///
  /// Pre-uploading item content is recommended when dealing with large files as
  /// it is much more efficient. It uploads the content of the [item] in advance
  /// so you don't need to upload it as part of transactions.
  ///
  /// The [onProgress] callback can be specified to get progress updates for
  /// every chunk that has been uploaded.
  Future<void> uploadContent(Item item, {ContentProgressCallback? onProgress});

  /// Download the content of an [item] if it is missing.
  ///
  /// When using some [FetchOptions.prefetch], items may be incomplete.
  /// Use this call to download the [item]s content so it can be accessed.
  /// This is a much more efficient way of getting the content of large files.
  ///
  /// It can also be used to download the content of an [Item] that was
  /// cached via [cacheSave] without it's content.
  ///
  /// The [onProgress] callback can be specified to get progress updates for
  /// every chunk that has been downloaded.
  Future<void> downloadContent(
    Item item, {
    ContentProgressCallback? onProgress,
  });

  /// Save the [item] object to a byte buffer for caching.
  ///
  /// The item can later be loaded using [cacheLoad].
  ///
  /// {@macro save_content}
  Uint8List cacheSave(Item item, {bool saveContent = true});

  /// Load and return a cached [Item] from the [cached] bytes originally
  /// saved via [cacheSave].
  Item cacheLoad(Uint8List cached);

  /// Subscribes to the remote server to get notified whenever items are
  /// created or updated in to collection.
  ///
  /// The returned [Stream] will continuously return
  /// [ItemListResponse]s containing the new [Item]
  /// revisions.
  ///
  /// {@macro fetch_options}
  Stream<ItemListResponse<Item>> subscribeChanges([ItemFetchOptions? options]);
}
