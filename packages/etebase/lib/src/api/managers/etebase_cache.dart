import 'package:hive_ce/hive.dart';
import 'package:sodium/sodium.dart';

import '../../impl/cache/hive_cache.dart';
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
/// [package:hive_ce](https://pub.dev/packages/hive_ce) to persist the data on
/// the device. Hive was chosen as it simple (no other native dependencies),
/// fast and compatible with the VM and the Web.
abstract class EtebaseCache {
  /// Initialize hive based cache for the given [username].
  ///
  /// **Important:** Before you can create an [EtebaseCache], you must
  /// initialize hive! You can do so by calling [HiveInterface.init] :
  ///
  /// ```dart
  /// Hive.init('.../path/to/hive/dir');
  /// ```
  static EtebaseCache create(
    EtebaseClient client,
    String username,
  ) =>
      HiveCache(Hive, username);

  /// Disposes of the instance and clear all cryptographic keys from memory.
  Future<void> dispose();

  /// Clear all cache for the user
  ///
  /// @param this_ the object handle
  Future<void> clearUser();

  bool get hasAccount;

  /// Save the user account
  ///
  /// Load it later using `etebase_fs_cache_load_account`
  ///
  /// @param this_ the object handle
  /// @param etebase the account to save
  /// @param encryption_key used to encrypt the saved account string to enhance security
  /// @param encryption_key_size the size of the encryption_key
  Future<void> saveAccount(
    EtebaseAccount account, [
    SecureKey? encryptionKey,
  ]);

  /// Load the account object from cache
  ///
  /// @param this_ the object handle
  /// @param client the already setup [EtebaseClient] object
  /// @param encryption_key the same encryption key passed to [Self::save_account] while saving the account
  /// @param encryption_key_size the size of the encryption_key
  Future<EtebaseAccount?> loadAccount(
    EtebaseClient client, [
    SecureKey? encryptionKey,
  ]);

  bool get hasStoken;

  /// Save the collection list sync token
  ///
  /// @param this_ the object handle
  /// @param stoken the sync token to be saved
  Future<void> saveStoken(String stoken);

  /// Load the collection list sync token from cache
  ///
  /// @param this_ the object handle
  Future<String?> loadStoken();

  Iterable<String> get persistedCollectionStokenUids;

  /// Save a collection's sync token
  ///
  /// @param this_ the object handle
  /// @param col_uid the UID of the collection
  /// @param stoken the sync token to be saved
  Future<void> collectionSaveStoken(
    String colUid,
    String stoken,
  );

  /// Load the sync token for a collection
  ///
  /// @param this_ the object handle
  /// @param col_uid the UID of the collection
  Future<String?> collectionLoadStoken(String colUid);

  Iterable<String> get persistedCollectionUids;

  /// Save a collection to cache
  ///
  /// @param this_ the object handle
  /// @param col_mgr collection manager for the account
  /// @param col the collection to be saved
  Future<void> collectionSet(
    EtebaseCollectionManager colMgr,
    EtebaseCollection col, {
    bool saveContent = true,
  });

  /// Remove a collection from cache
  ///
  /// @param this_ the object handle
  /// @param col_mgr collection manager for the account
  /// @param col_uid the UID of the collection to remove
  Future<void> collectionUnset(
    EtebaseCollectionManager colMgr,
    String colUid,
  );

  /// Load a collection from cache
  ///
  /// @param this_ the object handle
  /// @param col_mgr collection manager for the account
  /// @param col_uid the UID of the collection
  Future<EtebaseCollection?> collectionGet(
    EtebaseCollectionManager colMgr,
    String colUid,
  );

  Iterable<String> get persistedItemUids;

  /// Save an item to cache
  ///
  /// @param this_ the object handle
  /// @param item_mgr item manager for the parent collection
  /// @param col_uid the UID of the parent collection
  /// @param item the item to be saved
  Future<void> itemSet(
    EtebaseItemManager itemMgr,
    String colUid,
    EtebaseItem item, {
    bool saveContent = true,
  });

  /// Remove an item from cache
  ///
  /// @param this_ the object handle
  /// @param item_mgr item manager for the parent collection
  /// @param col_uid the UID of the parent collection
  /// @param item_uid the UID of the item
  Future<void> itemUnset(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  );

  /// Load an item from cache
  ///
  /// @param this_ the object handle
  /// @param item_mgr item manager for the parent collection
  /// @param col_uid the UID of the parent collection
  /// @param item_uid the UID of the item
  Future<EtebaseItem?> itemGet(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  );
}
