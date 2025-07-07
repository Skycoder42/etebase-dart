import 'package:etebase/etebase.dart';

import '../collections/collection_conflict_resolver.dart';
import '../collections/repository_manager.dart';
import '../exceptions/already_logged_in.dart';
import '../items/factory_registry.dart';
import '../items/item_record_factory.dart';
import '../items/items.dart';
import '../online/online_checker.dart';
import '../online/online_wrapper.dart';
import '../storage/account_store.dart';
import '../storage/storage_manager.dart';
import '../sync/sync_config.dart';

class EtebaseSync {
  final Client _client;
  final StorageManager _storageManager;
  final FactoryRegistry _registry;
  final CollectionConflictResolver _conflictResolver;
  final OnlineChecker _onlineChecker;

  late final AccountStore _accountStore;

  late SyncConfig _currentConfig;
  Account? _account;
  RepositoryManager? _repoManager;

  EtebaseSync._(
    this._client,
    this._storageManager,
    this._registry,
    this._conflictResolver,
    this._onlineChecker,
  );

  Future<void> init() async {
    _accountStore = await _storageManager.createAccountStore();
    _currentConfig = _accountStore.getSyncConfig();
  }

  Future<void> dispose() async {
    await Future.wait([_client.dispose(), _storageManager.dispose()]);
  }

  SyncConfig get config => _currentConfig;

  RepositoryManager get repositoryManager => switch (_repoManager) {
    final RepositoryManager rm => rm,
    _ => throw UnimplementedError(), // TODO real exception
  };

  void registerType<TRecord extends ItemRecord>(
    String collectionType,
    ItemRecordFactory<TRecord> factory,
  ) => _registry.registerType<TRecord>(collectionType, factory);

  Future<void> updateConfig(SyncConfig config) async {
    _currentConfig = config;
    await _accountStore.saveSyncConfig(config);
    // TODO handle update while running
  }

  Future<void> login(String username, String password) async {
    if (_account != null || _accountStore.hasAccount) {
      throw AlreadyLoggedIn();
    }

    final account = _account = await Account.login(_client, username, password);
    final savedAccount = await account.save(); // TODO use actual key
    await _accountStore.saveAccount(savedAccount);
    await _createRepoManager(account);
  }

  Future<void> _createRepoManager(Account account) async {
    _repoManager = RepositoryManager.create(
      account.collectionManager,
      _storageManager,
      _registry,
      await _storageManager.createCollectionStore(account.collectionManager),
      _conflictResolver,
      _currentConfig, // TODO handle changes
      _onlineChecker,
    );
  }

  factory EtebaseSync.instance() => throw UnimplementedError();

  factory EtebaseSync.create(String prefix) => throw UnimplementedError();
}
