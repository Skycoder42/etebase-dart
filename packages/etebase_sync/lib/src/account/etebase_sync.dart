import 'package:etebase/etebase.dart';

import '../collections/collection_conflict_resolver.dart';
import '../collections/repository_manager.dart';
import '../crypto/key_manager.dart';
import '../exceptions/already_logged_in.dart';
import '../items/factory_registry.dart';
import '../items/item_record_factory.dart';
import '../items/items.dart';
import '../online/online_checker.dart';
import '../storage/account_store.dart';
import '../storage/storage_manager.dart';
import '../sync/sync_config.dart';

class EtebaseSync {
  final Client _client;
  final StorageManager _storageManager;
  final FactoryRegistry _registry;
  final CollectionConflictResolver _conflictResolver;
  final OnlineChecker _onlineChecker;
  final KeyManager _keyManager;

  late final AccountStore _accountStore;

  late SyncConfig _currentConfig;
  Account? _account;
  RepositoryManager? _repoManager;

  EtebaseSync(
    this._client,
    this._storageManager,
    this._registry,
    this._conflictResolver,
    this._onlineChecker,
    this._keyManager,
  );

  Future<void> init() async {
    _accountStore = await _storageManager.createAccountStore();
    _currentConfig = _accountStore.getSyncConfig() ?? const SyncConfig();
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

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (_account != null || _accountStore.hasAccount) {
      throw AlreadyLoggedIn();
    }

    final account = await Account.login(_client, username, password);
    await _persistNewAccount(account);
  }

  Future<void> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    if (_account != null || _accountStore.hasAccount) {
      throw AlreadyLoggedIn();
    }

    final account = await Account.signup(
      _client,
      User(username: username, email: email),
      password,
    );
    await _persistNewAccount(account);
  }

  Future<void> restore() async {
    if (_account != null) {
      throw AlreadyLoggedIn();
    } else if (!_accountStore.hasAccount) {
      throw UnimplementedError(); // TODO
    }

    Account? account;
    try {
      // restore from storage
      final restoredAccount = _accountStore.getAccount();
      await _keyManager.loadKey();
      account = await Account.restore(
        _client,
        restoredAccount,
        _keyManager.accountKey,
      );

      // refresh tokens and persist again
      await account.fetchToken();
      final savedAccount = await account.save(_keyManager.accountKey);
      await _accountStore.saveAccount(savedAccount);

      await _createRepoManager(account);
      _account = account;
    } catch (_) {
      account?.dispose();
      rethrow;
    }
  }

  Future<void> logOut() async {
    if (_account == null && !_accountStore.hasAccount) {
      throw UnimplementedError(); // TODO
    }

    _repoManager = null;
    _account?.dispose();
    _account = null;

    await _storageManager.erase();

    await _keyManager.discardKey();
  }

  Future<void> _persistNewAccount(Account account) async {
    try {
      await _keyManager.createKey();
      final savedAccount = await account.save(_keyManager.accountKey);
      await _accountStore.saveAccount(savedAccount);

      await _createRepoManager(account);
      _account = account;
    } catch (_) {
      account.dispose();
      rethrow;
    }
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
