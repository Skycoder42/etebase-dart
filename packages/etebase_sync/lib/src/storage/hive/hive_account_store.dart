import 'package:hive_ce/hive.dart';

import '../../sync/sync_config.dart';
import '../account_store.dart';

class HiveAccountStore implements AccountStore {
  static const _prefix = 'account';
  static const _configKey = '$_prefix.config';
  static const _accountKey = '$_prefix.data';

  final Box<dynamic> _metaBox;

  HiveAccountStore(this._metaBox);

  @override
  SyncConfig? getSyncConfig() {
    final mapData = _metaBox.get(_configKey);
    if (mapData is! Map) {
      return null;
    }
    return SyncConfig.fromJson(mapData.cast());
  }

  @override
  Future<void> saveSyncConfig(SyncConfig config) async =>
      await _metaBox.put(_configKey, config.toJson());

  @override
  bool get hasAccount => _metaBox.containsKey(_accountKey);

  @override
  String getAccount() => _metaBox.get(_accountKey)! as String;

  @override
  Future<void> saveAccount(String account) async =>
      await _metaBox.put(_accountKey, account);
}
