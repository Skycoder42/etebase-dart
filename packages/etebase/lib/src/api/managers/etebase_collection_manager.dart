import 'dart:typed_data';

import '../models/collection.dart';
import '../models/fetch_options.dart';
import '../models/item.dart';
import '../models/item_metadata.dart';
import '../models/list_response.dart';
import 'etebase_client.dart';
import 'etebase_collection_member_manager.dart';
import 'etebase_item_manager.dart';

/// A manager for managing [Collection] operations like creation and
/// fetching.
abstract class EtebaseCollectionManager {
  /// Create a new [Collection].
  ///
  /// The [collectionType] defines the type of [Item]s stored in the
  /// collection. The [meta] and [content] are backing the collections primary
  /// [Item]. This is unrelated to the [Item]s in the collection.
  ///
  /// {@template create_from_stream}
  /// **Note:** To create a new instance from a stream instead of an [Uint8List]
  /// [content], simply create it with `Uint8List(0)` as content and then call
  /// [Item.setContentStream] to set the actual content.
  /// {@endtemplate}
  ///
  /// {@template meta_registration}
  /// By default, the [meta] data will be of the type [ItemMetadata].
  /// You can use custom metadata objects that implement the
  /// [ItemMetadata] with additional properties. However, this requires
  /// you to register [TMeta] once via [EtebaseClient.registerCustomMetadata].
  /// {@endtemplate}
  Future<Collection> create<TMeta extends ItemMetadata>(
    String collectionType,
    TMeta meta,
    Uint8List content,
  );

  /// Fetch a single collection from the server using its [colUid].
  ///
  /// {@template fetch_options}
  /// The [fetchOptions] allow you to specify optional parameters to further
  /// filter the returned result or continue with the next iteration of data.
  /// {@endtemplate}
  Future<Collection> fetch(String colUid, [FetchOptions? fetchOptions]);

  /// Fetch all [Collection]s of a specific [collectionType] from the
  /// server and return a [CollectionListResponse].
  ///
  /// {@macro fetch_options}
  Future<CollectionListResponse<Collection>> list(
    String collectionType, [
    FetchOptions? fetchOptions,
  ]);

  /// Fetch all [Collection]s of the supplied [collectionTypes] from the
  /// server and return a [CollectionListResponse].
  ///
  /// {@macro fetch_options}
  Future<CollectionListResponse<Collection>> listMulti(
    List<String> collectionTypes, [
    FetchOptions? fetchOptions,
  ]);

  /// Upload a [collection].
  ///
  /// {@macro fetch_options}
  Future<void> upload(Collection collection, [FetchOptions? fetchOptions]);

  /// Upload a [collection] using a transaction.
  ///
  /// This call ensures that the collection hasn't changed since we last fetched
  /// it.
  ///
  /// {@macro fetch_options}
  Future<void> transaction(Collection collection, [FetchOptions? fetchOptions]);

  /// Save the [collection] object to a byte buffer for caching.
  ///
  /// The collection can later be loaded using [cacheLoad].
  ///
  /// {@template save_content}
  /// If [saveContent] is `true` (the default), the object is saved together
  /// with it's content. If set to `false`, only the metadata is stored and the
  /// content has to be restored using [EtebaseItemManager.downloadContent].
  /// {@endtemplate}
  Uint8List cacheSave(Collection collection, {bool saveContent = true});

  /// Load and return a cached [Collection] object from the [cached]
  /// bytes originally saved via [cacheSave].
  Collection cacheLoad(Uint8List cached);

  /// Return the item manager for the supplied [collection].
  EtebaseItemManager getItemManager(Collection collection);

  /// Return the collection member manager for the supplied [collection].
  EtebaseCollectionMemberManager getMemberManager(Collection collection);
}
