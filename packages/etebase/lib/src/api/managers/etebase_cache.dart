import 'package:sodium/sodium.dart';

import '../../impl/cache/sembast_cache.dart';
import '../models/etebase_collection.dart';
import '../models/etebase_item.dart';
import 'etebase_account.dart';
import 'etebase_client.dart';
import 'etebase_collection_manager.dart';
import 'etebase_item_manager.dart';

/// A caching helper that allows you to easily save and restore items and
/// collections on the end device.
///
/// The default implementation of the dart port uses
/// [package:sembast](https://pub.dev/packages/sembast) to persist the data on
/// the device. Sembast was chosen as it simple (no other native dependencies),
/// fast and compatible with the VM and the Web.
abstract class EtebaseCache {
  /// Initialize sembast based cache for the given [client] and [username].
  ///
  /// The [pathHint] is a hint to the cache where to store the data. It has
  /// no effect on the web platform, but on the VM it will be used to determine
  /// the path to the cache directory. By default, the cache will be stored in
  /// etebase_cache in the current directory.
  ///
  /// If [autoCompact] is true (the default), the cache will be compacted every
  /// time it is opened. This is useful to keep the cache size small, but comes
  /// at a performance cost on creation.
  static Future<EtebaseCache> create(
    EtebaseClient client,
    String username, {
    String? pathHint,
    bool autoCompact = true,
  }) async {
    final cache = SembastCache(
      username,
      pathHint: pathHint,
      autoCompact: autoCompact,
    );
    await cache.initialize();
    return cache;
  }

  /// Disposes of the instance and closes all open databases.
  Future<void> dispose();

  /// Clear all cache for the user.
  Future<void> clearUser();

  /// Checks if the users account is stored within the cache.
  Future<bool> get hasAccount;

  /// Save the user account.
  ///
  /// Load it later using [loadAccount].
  ///
  /// {@macro encryption_key}
  Future<void> saveAccount(
    EtebaseAccount account, [
    SecureKey? encryptionKey,
  ]);

  /// Load the [EtebaseAccount] object from cache.
  ///
  /// The [encryptionKey] must be the same as used for [saveAccount].
  Future<EtebaseAccount> loadAccount(
    EtebaseClient client, [
    SecureKey? encryptionKey,
  ]);

  /// Checks if the users account stoken is stored within the cache.
  Future<bool> get hasStoken;

  /// Save the collection list sync [stoken].
  Future<void> saveStoken(String stoken);

  /// Load the collection list sync stoken from cache.
  Future<String> loadStoken();

  /// Lists all collection uids for collections that have their stoken stored
  /// in the cache.
  Stream<String> get persistedCollectionStokenUids;

  /// Save a collections sync [stoken] for the collection identified by
  /// [colUid].
  ///
  /// **Note:** To delete the token, use [collectionUnset].
  Future<void> collectionSaveStoken(
    String colUid,
    String stoken,
  );

  /// Load the sync stoken for the collection identified by [colUid].
  Future<String> collectionLoadStoken(String colUid);

  /// Lists all collection uids for collections been stored in the cache.
  Stream<String> get persistedCollectionUids;

  /// Save a [collection] to cache.
  ///
  /// {@macro save_content}
  Future<void> collectionSet(
    EtebaseCollectionManager colMgr,
    EtebaseCollection collection, {
    bool saveContent = true,
  });

  /// Remove a collection identified by [colUid] from cache.
  ///
  /// This will also remove the collection stoken if previously set via
  /// [collectionSaveStoken].
  Future<void> collectionUnset(
    EtebaseCollectionManager colMgr,
    String colUid,
  );

  /// Load a [EtebaseCollection] identified by [colUid] from cache.
  Future<EtebaseCollection> collectionGet(
    EtebaseCollectionManager colMgr,
    String colUid,
  );

  /// Lists all item uids for items of the collection identified by [colUid]
  /// that have been stored in the cache.
  Stream<String> persistedItemUids(String colUid);

  /// Save an [item] of the collection identified by [colUid] to cache.
  ///
  /// {@macro save_content}
  Future<void> itemSet(
    EtebaseItemManager itemMgr,
    String colUid,
    EtebaseItem item, {
    bool saveContent = true,
  });

  /// Remove an item identified by [itemUid] of the collection identified by
  /// [colUid] from cache.
  Future<void> itemUnset(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  );

  /// Load an [EtebaseItem] identified by [itemUid] of the collection identified
  /// by [colUid] from cache.
  Future<EtebaseItem> itemGet(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  );
}
