import 'dart:typed_data';

import '../models/etebase_fetch_options.dart';
import '../models/etebase_item.dart';
import '../models/etebase_item_metadata.dart';
import '../models/etebase_list_response.dart';

/// A callback to receive progress for when an items content is uploaded or
/// downloaded separately.
typedef ContentProgressCallback = void Function(int current, int total);

/// A manager for managing [EtebaseItem] operations like creation and fetching.
abstract class EtebaseItemManager {
  /// Disposes of the instance and clears all cryptographic keys from memory.
  void dispose();

  /// Create a new [EtebaseItem].
  ///
  /// The [meta] and [content] are defining the data of the item.
  ///
  /// {@macro create_from_stream}
  ///
  /// {@macro meta_registration}
  Future<EtebaseItem> create<TMeta extends EtebaseItemMetadata>(
    TMeta meta,
    Uint8List content,
  );

  /// Fetch a single [EtebaseItem] from the server using its [itemUid].
  ///
  /// {@macro fetch_options}
  Future<EtebaseItem> fetch(
    String itemUid, [
    EtebaseItemFetchOptions? fetchOptions,
  ]);

  /// Fetch all [EtebaseItem] of a collection and return a
  /// [EtebaseItemListResponse].
  ///
  /// {@macro fetch_options}
  Future<EtebaseItemListResponse<EtebaseItem>> list([
    EtebaseItemFetchOptions? fetchOptions,
  ]);

  /// Fetch and return a [EtebaseIteratorListResponse] of [EtebaseItem] with
  /// each item as a revision of the given [item].
  ///
  /// {@macro fetch_options}
  Future<EtebaseIteratorListResponse<EtebaseItem>> itemRevisions(
    EtebaseItem item, [
    EtebaseRevisionFetchOptions? fetchOptions,
  ]);

  /// Fetch the latest revision of the supplied [items] from the server and
  /// return a [EtebaseItemListResponse] of [EtebaseItem]s.
  ///
  /// {@macro fetch_options}
  Future<EtebaseItemListResponse<EtebaseItem>> fetchUpdates(
    List<EtebaseItem> items, [
    EtebaseItemFetchOptions? fetchOptions,
  ]);

  /// Fetch multiple [EtebaseItem]s using their [itemUids] and return a
  /// [EtebaseItemListResponse].
  ///
  /// See [fetch] for fetching a single [EtebaseItem].
  ///
  /// {@macro fetch_options}
  Future<EtebaseItemListResponse<EtebaseItem>> fetchMulti(
    List<String> itemUids, [
    EtebaseItemFetchOptions? fetchOptions,
  ]);

  /// Upload the supplied [items] to the server.
  ///
  /// {@template deps}
  /// The optional [deps] can be used to specify additional [EtebaseItem]s that
  /// are dependencies of the uploaded [items]. The upload will fail if the
  /// [deps] have changed remotely.
  /// {@endtemplate}
  ///
  /// {@macro fetch_options}
  Future<void> batch(
    List<EtebaseItem> items, {
    List<EtebaseItem>? deps,
    EtebaseItemFetchOptions? options,
  });

  /// Upload the supplied [items] to the server using a transaction.
  ///
  /// {@macro deps}
  ///
  /// {@macro fetch_options}
  Future<void> transaction(
    List<EtebaseItem> items, {
    List<EtebaseItem>? deps,
    EtebaseItemFetchOptions? options,
  });

  /// Pre-upload the [item]s content - use it with large files.
  ///
  /// Pre-uploading item content is recommended when dealing with large files as
  /// it is much more efficient. It uploads the content of the [item] in advance
  /// so you don't need to upload it as part of transactions.
  ///
  /// The [onProgress] callback can be specified to get progress updates for
  /// every chunk that has been uploaded.
  Future<void> uploadContent(
    EtebaseItem item, {
    ContentProgressCallback? onProgress,
  });

  /// Download the content of an [item] if it is missing.
  ///
  /// When using some [EtebaseFetchOptions.prefetch], items may be incomplete.
  /// Use this call to download the [item]s content so it can be accessed.
  /// This is a much more efficient way of getting the content of large files.
  ///
  /// It can also be used to download the content of an [EtebaseItem] that was
  /// cached via [cacheSave] without it's content.
  ///
  /// The [onProgress] callback can be specified to get progress updates for
  /// every chunk that has been downloaded.
  Future<void> downloadContent(
    EtebaseItem item, {
    ContentProgressCallback? onProgress,
  });

  /// Save the [item] object to a byte buffer for caching.
  ///
  /// The item can later be loaded using [cacheLoad].
  ///
  /// {@macro save_content}
  Uint8List cacheSave(EtebaseItem item, {bool saveContent = true});

  /// Load and return a cached [EtebaseItem] from the [cached] bytes originally
  /// saved via [cacheSave].
  EtebaseItem cacheLoad(Uint8List cached);

  /// Subscribes to the remote server to get notified whenever items are
  /// created or updated in to collection.
  ///
  /// The returned [Stream] will continuously return
  /// [EtebaseItemListResponse]s containing the new [EtebaseItem]
  /// revisions.
  ///
  /// {@macro fetch_options}
  Stream<EtebaseItemListResponse<EtebaseItem>> subscribeChanges([
    EtebaseItemFetchOptions? options,
  ]);
}
