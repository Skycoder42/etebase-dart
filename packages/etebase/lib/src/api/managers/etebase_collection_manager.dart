import 'dart:typed_data';

import '../models/etebase_collection.dart';
import '../models/etebase_fetch_options.dart';
import '../models/etebase_item.dart';
import '../models/etebase_item_metadata.dart';
import '../models/etebase_list_response.dart';
import 'etebase_client.dart';
import 'etebase_collection_member_manager.dart';
import 'etebase_item_manager.dart';

/// A manager for managing [EtebaseCollection] operations like creation and
/// fetching.
abstract class EtebaseCollectionManager {
  /// Create a new [EtebaseCollection].
  ///
  /// The [collectionType] defines the type of [EtebaseItem]s stored in the
  /// collection. The [meta] and [content] are backing the collections primary
  /// [EtebaseItem]. This is unrelated to the [EtebaseItem]s in the collection.
  ///
  /// {@template meta_registration}
  /// By default, the [meta] data will be of the type [EtebaseItemMetadata].
  /// You can use custom metadata objects that implement the
  /// [EtebaseItemMetadata] with additional properties. However, this requires
  /// you to register [TMeta] once via [EtebaseClient.registerCustomMetadata].
  /// {@endtemplate}
  Future<EtebaseCollection> create<TMeta extends EtebaseItemMetadata>(
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
  Future<EtebaseCollection> fetch(
    String colUid, [
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Fetch all [EtebaseCollection]s of a specific [collectionType] from the
  /// server and return a [EtebaseCollectionListResponse].
  ///
  /// {@macro fetch_options}
  Future<EtebaseCollectionListResponse<EtebaseCollection>> list(
    String collectionType, [
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Fetch all [EtebaseCollection]s of the supplied [collectionTypes] from the
  /// server and return a [EtebaseCollectionListResponse].
  ///
  /// {@macro fetch_options}
  Future<EtebaseCollectionListResponse<EtebaseCollection>> listMulti(
    List<String> collectionTypes, [
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Upload a [collection].
  ///
  /// {@macro fetch_options}
  Future<void> upload(
    EtebaseCollection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Upload a [collection] using a transaction.
  ///
  /// This call ensures that the collection hasn't changed since we last fetched
  /// it.
  ///
  /// {@macro fetch_options}
  Future<void> transaction(
    EtebaseCollection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]);

  /// Save the [collection] object to a byte buffer for caching.
  ///
  /// The collection can later be loaded using [cacheLoad].
  ///
  /// {@template save_content}
  /// If [saveContent] is `true` (the default), the object is saved together
  /// with it's content. If set to `false`, only the metadata is stored and the
  /// content has to be restored using [EtebaseItemManager.downloadContent].
  /// {@endtemplate}
  Uint8List cacheSave(EtebaseCollection collection, {bool saveContent = true});

  /// Load and return a cached [EtebaseCollection] object from the [cached]
  /// bytes originally saved via [cacheSave].
  EtebaseCollection cacheLoad(Uint8List cached);

  /// Return the item manager for the supplied [collection].
  EtebaseItemManager getItemManager(EtebaseCollection collection);

  /// Return the collection member manager for the supplied [collection].
  EtebaseCollectionMemberManager getMemberManager(EtebaseCollection collection);
}
