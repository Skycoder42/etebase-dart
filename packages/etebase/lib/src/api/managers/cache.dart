import 'package:hive_ce/hive.dart';
import 'package:sodium/sodium.dart';

import '../../impl/crypto/crypto_utils.dart';
import '../../impl/managers/client_impl.dart';
import '../models/collection.dart';
import '../models/item.dart';
import 'account.dart';
import 'client.dart';
import 'collection_manager.dart';
import 'item_manager.dart';

/// A caching helper that allows you to easily save and restore items and
/// collections on the end device.
///
/// The default implementation of the dart port uses
/// [package:hive_ce](https://pub.dev/packages/hive_ce) to persist the data on
/// the device. Hive was chosen as it simple (no other native dependencies),
/// fast and compatible with the VM and the Web.
abstract class Cache {
  /// The length that the `encryptionKey` for [saveAccount] and [loadAccount]
  /// must have.
  static const cacheKeyLength = CryptoUtils.symmetricKeySize;

  /// Initialize hive based cache for the given [username].
  ///
  /// **Important:** Before you can create an [Cache], you must
  /// initialize hive! You can do so by calling the[HiveInterface.init] method:
  ///
  /// ```dart
  /// Hive.init('.../path/to/hive/dir');
  /// ```
  static Future<Cache> create(Client client, String username) =>
      (client as ClientImpl).createCache(username);

  /// Disposes of the instance and closes all hive boxes.
  Future<void> dispose();

  /// Clear all cache for the user.
  ///
  /// If [reInitialize] is `false` (the default), this will implicitly [dispose]
  /// of the cache, thus making it unusable. If you intend to reuse the cache
  /// for the user to add data again, set it to `true` instead.
  Future<void> clearUser({bool reInitialize = false});

  /// Checks if the users account is stored within the cache.
  Future<bool> get hasAccount;

  /// Save the user account.
  ///
  /// Load it later using [loadAccount].
  ///
  /// {@macro encryption_key}
  Future<void> saveAccount(Account account, [SecureKey? encryptionKey]);

  /// Load the [Account] object from cache.
  ///
  /// The [encryptionKey] must be the same as used for [saveAccount].
  Future<Account> loadAccount([SecureKey? encryptionKey]);

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
  Future<void> collectionSaveStoken(String colUid, String stoken);

  /// Load the sync stoken for the collection identified by [colUid].
  Future<String> collectionLoadStoken(String colUid);

  /// Lists all collection uids for collections been stored in the cache.
  Stream<String> get persistedCollectionUids;

  /// Save a [collection] to cache.
  ///
  /// {@macro save_content}
  Future<void> collectionSet(
    CollectionManager colMgr,
    Collection collection, {
    bool saveContent = true,
  });

  /// Remove a collection identified by [colUid] from cache.
  ///
  /// This will also remove the collection stoken if previously set via
  /// [collectionSaveStoken].
  Future<void> collectionUnset(String colUid);

  /// Load a [Collection] identified by [colUid] from cache.
  Future<Collection> collectionGet(CollectionManager colMgr, String colUid);

  /// Lists all item uids for items of the collection identified by [colUid]
  /// that have been stored in the cache.
  Stream<String> persistedItemUids(String colUid);

  /// Save an [item] of the collection identified by [colUid] to cache.
  ///
  /// {@macro save_content}
  Future<void> itemSet(
    ItemManager itemMgr,
    String colUid,
    Item item, {
    bool saveContent = true,
  });

  /// Remove an item identified by [itemUid] of the collection identified by
  /// [colUid] from cache.
  Future<void> itemUnset(String colUid, String itemUid);

  /// Load an [Item] identified by [itemUid] of the collection identified
  /// by [colUid] from cache.
  Future<Item> itemGet(ItemManager itemMgr, String colUid, String itemUid);
}
