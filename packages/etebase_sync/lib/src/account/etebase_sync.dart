import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';

import '../collections/collection_conflict_resolver.dart';
import '../collections/repository_manager.dart';
import '../collections/repository_metadata.dart';
import '../exceptions/already_logged_in.dart';
import '../exceptions/not_logged_in.dart';
import '../items/factory_registry.dart';
import '../items/items.dart';
import '../logging/account_logger.dart';
import '../online/online_checker.dart';
import '../online/online_wrapper.dart';
import '../online/server_ping_online_checker.dart';
import '../share/invitation_user_validator.dart';
import '../storage/account_store.dart';
import '../storage/hive/hive_storage_manager.dart';
import '../storage/storage_manager.dart';
import '../sync/storage_mode.dart';
import '../sync/sync_config.dart';
import 'key_manager.dart';
import 'keystore.dart';

class EtebaseSync {
  static EtebaseSync? _instance;

  final Client _client;
  final StorageManager _storageManager;
  final FactoryRegistry _registry;
  final CollectionConflictResolver _conflictResolver;
  final OnlineWrapper _online;
  final KeyManager _keyManager;
  final InvitationUserValidator _invitationUserValidator;
  final AccountLogger _logger;

  late final AccountStore _accountStore;

  late SyncConfig _config;
  Account? _account;
  RepositoryManager? _repoManager;

  factory EtebaseSync({
    required Client client,
    required Keystore keystore,
    StorageManager? storageManager,
    CollectionConflictResolver? conflictResolver,
    OnlineChecker? onlineChecker,
    InvitationUserValidator? invitationUserValidator,
    AccountLogger? logger,
    int hiveTypeIdOffset = 100,
    StorageMode storageMode = StorageMode.cached,
  }) {
    if (_instance != null) {
      throw StateError(
        'Another EtebaseSync instance has already been created. '
        'If you need multiple instances, use EtebaseSync.prefixed instead.',
      );
    }

    final accountLogger = logger ?? AccountLogger();
    return _instance = EtebaseSync.internal(
      client,
      storageManager ?? HiveStorageManager(hiveTypeIdOffset, Hive, storageMode),
      FactoryRegistry(),
      conflictResolver ?? const CollectionConflictResolver(),
      OnlineWrapper(
        onlineChecker ?? ServerPingOnlineChecker(client),
        accountLogger.online,
      ),
      KeyManager(keystore, client),
      invitationUserValidator ?? const RejectValidator(),
      accountLogger,
    );
  }

  factory EtebaseSync.prefixed({
    required String prefix,
    required Client client,
    required Keystore keystore,
    StorageManager? storageManager,
    CollectionConflictResolver? conflictResolver,
    OnlineChecker? onlineChecker,
    InvitationUserValidator? invitationUserValidator,
    AccountLogger? logger,
    int hiveTypeIdOffset = 100,
    StorageMode storageMode = StorageMode.cached,
  }) {
    final accountLogger = logger ?? AccountLogger(prefix);
    return EtebaseSync.internal(
      client,
      storageManager ??
          HiveStorageManager(hiveTypeIdOffset, Hive, storageMode, prefix),
      FactoryRegistry(),
      conflictResolver ?? const CollectionConflictResolver(),
      OnlineWrapper(
        onlineChecker ?? ServerPingOnlineChecker(client),
        accountLogger.online,
      ),
      KeyManager(keystore, client, prefix),
      invitationUserValidator ?? const RejectValidator(),
      accountLogger,
    );
  }

  @visibleForTesting
  EtebaseSync.internal(
    this._client,
    this._storageManager,
    this._registry,
    this._conflictResolver,
    this._online,
    this._keyManager,
    this._invitationUserValidator,
    this._logger,
  );

  @internal
  Account get account => _account!;

  @internal
  InvitationUserValidator get invitationUserValidator =>
      _invitationUserValidator;

  Future<void> init() async {
    _client.registerCustomMetadata(RepositoryMetadata.fromJson);

    await _storageManager.init();
    _accountStore = await _storageManager.createAccountStore();
    _config = _accountStore.getSyncConfig() ?? const SyncConfig();
  }

  Future<void> dispose() async {
    if (_instance == this) {
      _instance = null;
    }

    await Future.wait([
      ?_repoManager?.dispose(),
      _client.dispose(),
      _storageManager.dispose(),
      _online.dispose(),
      Future.sync(_keyManager.dispose),
    ]);
  }

  SyncConfig get config => _config;

  bool get hasStoredAccount => _accountStore.hasAccount;

  RepositoryManager get repositoryManager => switch (_repoManager) {
    final RepositoryManager rm => rm,
    _ => throw NotLoggedIn(),
  };

  void registerType<TRecord extends ItemRecord>(
    String collectionType,
    ItemRecordFactory<TRecord> factory,
  ) => _registry.registerType<TRecord>(collectionType, factory);

  /// Updates the current sync configuration.
  ///
  /// Changing the [config] will update the internal state and persist the
  /// config to the storage for persistence. The [repositoryManager] will also
  /// be updated to use the new [config] immediately and newly created
  /// [Repository] instances will use it as well.
  ///
  /// **Attention:** Any existing [Repository] will **not** be updated with the
  /// new config. If you need that, you will have to dispose and recreate all
  /// used repositories.
  Future<void> updateConfig(SyncConfig config) async {
    await _accountStore.saveSyncConfig(config);
    _config = config;
    _repoManager?.updateConfig(config);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (_account != null || _accountStore.hasAccount) {
      throw AlreadyLoggedIn();
    }

    _logger.login();
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

    _logger.signup();
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
      throw NotLoggedIn();
    }

    _logger.restore();
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
      _logger.fetch();
      await account.fetchToken();
      _logger.saving();
      final savedAccount = await account.save(_keyManager.accountKey);
      await _accountStore.saveAccount(savedAccount);
      _logger.authenticated();

      await _createRepoManager(account);
      _account = account;
    } catch (_) {
      account?.dispose();
      rethrow;
    }
  }

  Future<void> logOut() async {
    if (_account == null && !_accountStore.hasAccount) {
      throw NotLoggedIn();
    }

    _logger.logout();
    await _repoManager?.dispose();
    _repoManager = null;
    _account?.dispose();
    _account = null;

    await _storageManager.erase();

    await _keyManager.discardKey();
    _logger.loggedOut();
  }

  String prettyFingerprint(
    Uint8List key, [
    String delimiter = Client.defaultFingerprintDelimiter,
  ]) => _client.prettyFingerprint(key, delimiter);

  Future<void> _persistNewAccount(Account account) async {
    try {
      _logger.saving();
      await _keyManager.createKey();
      final savedAccount = await account.save(_keyManager.accountKey);
      await _accountStore.saveAccount(savedAccount);
      _logger.authenticated();

      await _createRepoManager(account);
      _account = account;
    } catch (_) {
      account.dispose();
      rethrow;
    }
  }

  Future<void> _createRepoManager(Account account) async {
    await _repoManager?.dispose();
    _repoManager = RepositoryManager.create(
      this,
      account.collectionManager,
      _storageManager,
      _registry,
      await _storageManager.createCollectionStore(account.collectionManager),
      _conflictResolver,
      _config,
      _online,
      _logger.collection,
    );
    await _repoManager!.init();
  }
}
