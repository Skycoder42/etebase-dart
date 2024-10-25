import 'dart:typed_data';

import '../models/etebase_collection.dart';
import '../models/etebase_collection_list_response.dart';
import '../models/etebase_fetch_options.dart';
import '../models/etebase_item_metadata.dart';
import 'etebase_collection_member_manager.dart';
import 'etebase_item_manager.dart';

/// The dart binding of the EtebaseCollectionManager rust class
abstract class EtebaseCollectionManager {
  /// Fetch a single collection from the server using its UID
  ///
  /// @param this_ the object handle
  /// @param col_uid the UID of the collection to be fetched
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollection> fetch(
    String colUid, [
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Create a new collection
  ///
  /// Should be destroyed with `etebase_collection_destroy`
  ///
  /// @param this_ the object handle
  /// @param collection_type the type of [Item]s stored in the collection
  /// @param meta the [ItemMetadata] for the collection
  /// @param content the collection's content as a byte array. This is unrelated to the [Item]s in the collection.
  /// @param content_size the content size
  EtebaseCollection create(
    String collectionType,
    EtebaseItemMetadata meta,
    Uint8List content,
  );

  /// Create a new collection using raw metadata
  ///
  /// Unlike `etebase_collection_manager_create`, this receives the metadata as valid `EtebaseItemMetadata`-like struct encoded using `msgpack`.
  /// This can be used to create collections with custom metadata types.
  ///
  /// Should be destroyed with `etebase_collection_destroy`
  ///
  /// @param this_ the object handle
  /// @param collection_type the type of [Item]s stored in the collection
  /// @param meta the metadata for the collection as a byte array
  /// @param meta_size the metadata size
  /// @param content the collection's content as a byte array. This is unrelated to the [Item]s in the collection.
  /// @param content_size the content size
  EtebaseCollection createRaw(
    String collectionType,
    Uint8List meta,
    Uint8List content,
  );

  /// Return the item manager for the supplied collection
  ///
  /// @param this_ the object handle
  /// @param col the collection for which the item manager is required
  EtebaseItemManager getItemManager(EtebaseCollection col);

  /// Fetch all collections of a specific type from the server and return a list response
  ///
  /// @param this_ the object handle
  /// @param collection_type the type of items stored in the collection
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollectionListResponse> list(
    String collectionType, [
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Fetch all collections of the supplied types from the server and return a list response
  ///
  /// @param this_ the object handle
  /// @param collection_types array of strings denoting the collection types
  /// @param collection_types_size size of the collection_types array
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollectionListResponse> listMulti(
    List<String> collectionTypes, [
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Upload a collection
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be uploaded
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> upload(
    EtebaseCollection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Upload a collection using a transaction
  ///
  /// This call ensures that the collection hasn't changed since we last fetched it
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be uploaded
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> transaction(
    EtebaseCollection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Load and return a cached collection object from a byte buffer
  ///
  /// @param this_ the object handle
  /// @param cached the byte buffer holding the cached collection obtained using [cache_save]
  /// @param cached_size size of the buffer
  EtebaseCollection cacheLoad(Uint8List cached);

  /// Save the collection object to a byte buffer for caching
  ///
  /// The collection can later be loaded using `etebase_collection_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Uint8List cacheSave(EtebaseCollection collection);

  /// Save the collection object and its content to a byte buffer for caching
  ///
  /// The collection can later be loaded using `etebase_collection_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Uint8List cacheSaveWithContent(EtebaseCollection collection);

  /// Return the collection member manager for the supplied collection
  ///
  /// @param this_ the object handle
  /// @param col the collection for which the manager is required
  EtebaseCollectionMemberManager getMemberManager(EtebaseCollection col);
}
