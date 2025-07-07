import '../sync/sync_config.dart';

abstract interface class AccountStore {
  SyncConfig getSyncConfig();

  Future<void> saveSyncConfig(SyncConfig config);

  bool get hasAccount;

  Future<void> saveAccount(String account);
}
