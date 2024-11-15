import 'dart:typed_data';

import '../models/base/etebase_collection_item_list_response.dart';
import '../models/base/etebase_iterator_list_response.dart';
import '../models/etebase_fetch_options.dart';
import '../models/etebase_item.dart';
import '../models/etebase_item_metadata.dart';

/// The dart binding of the EtebaseItemManager rust class
abstract class EtebaseItemManager {
  /// Disposes of the instance and clear all cryptographic keys from memory.
  Future<void> dispose();

  /// Fetch a single item from the server using its UID
  ///
  /// @param this_ the object handle
  /// @param item_uid the UID of the item to be fetched
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseItem> fetch(
    String itemUid, [
    EtebaseItemFetchOptions? fetchOptions,
  ]);

  /// Create a new item
  ///
  /// Should be destroyed with `etebase_item_destroy`
  ///
  /// @param this_ the object handle
  /// @param meta the [ItemMetadata] for the item
  /// @param content the item's content as a byte array
  /// @param content_size the content size
  Future<EtebaseItem> create<TMeta extends EtebaseItemMetadata>(
    TMeta meta,
    Uint8List content,
  );

  /// Fetch all items of a collection and return a list response
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollectionItemListResponse<EtebaseItem>> list([
    EtebaseItemFetchOptions? fetchOptions,
  ]);

  /// Fetch and return a list response of items with each item as the revision
  ///
  /// @param this_ the object handle
  /// @param item the item for which to fetch the revision history
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseIteratorListResponse<EtebaseItem>> itemRevisions(
    EtebaseItem item, [
    EtebaseRevisionFetchOptions? fetchOptions,
  ]);

  /// Fetch the latest revision of the supplied items from the server and return a list response
  ///
  /// @param this_ the object handle
  /// @param items the list of items to be fetched
  /// @param items_size the number of items
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollectionItemListResponse<EtebaseItem>> fetchUpdates(
    List<EtebaseItem> items, [
    EtebaseItemFetchOptions? fetchOptions,
  ]);

  /// Fetch multiple Items using their UID
  ///
  /// See etebase_item_manager_fetch for fetching a single item
  ///
  /// @param this_ the object handle
  /// @param items the list of item uids to be fetched
  /// @param items_size the number of items
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollectionItemListResponse<EtebaseItem>> fetchMulti(
    List<String> items, [
    EtebaseItemFetchOptions? fetchOptions,
  ]);

  /// Upload the supplied items to the server
  /// Upload the supplied items to the server with a list of items as dependencies
  ///
  /// This will fail if the dependencies have changed remotely
  ///
  /// @param this_ the object handle
  /// @param items the list of items to be uploaded
  /// @param items_size the number of items
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> batch(
    List<EtebaseItem> items, {
    List<EtebaseItem>? deps,
    EtebaseItemFetchOptions? options,
  });

  /// Upload items using a transaction
  /// Upload items using a transaction with a list of items as dependencies
  ///
  /// This call ensures that the items haven't changed since we last fetched them
  ///
  /// @param this_ the object handle
  /// @param items the list of items to be uploaded
  /// @param items_size the number of items
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> transaction(
    List<EtebaseItem> items, {
    List<EtebaseItem>? deps,
    EtebaseItemFetchOptions? options,
  });

  Future<void> uploadContent(EtebaseItem item);

  Future<void> downloadContent(EtebaseItem item);

  /// Load and return a cached item from a byte buffer
  ///
  /// @param this_ the object handle
  /// @param cached the byte buffer holding the cached item obtained using [cache_save]
  /// @param cached_size size of the buffer
  Future<EtebaseItem> cacheLoad(Uint8List cached);

  /// Save the item object to a byte buffer for caching
  /// Save the item object and its content to a byte buffer for caching
  ///
  /// The item can later be loaded using `etebase_item_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param item the item object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Uint8List cacheSave(EtebaseItem item, {bool saveContent = true});

  Stream<EtebaseCollectionItemListResponse<EtebaseItem>> subscribeChanges([
    EtebaseItemFetchOptions? options,
  ]);
}
