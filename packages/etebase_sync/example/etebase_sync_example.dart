import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:etebase/etebase.dart';
import 'package:etebase_sync/src/account/etebase_sync.dart';
import 'package:etebase_sync/src/collections/collection_conflict_resolver.dart';
import 'package:etebase_sync/src/collections/repository_metadata.dart';
import 'package:etebase_sync/src/crypto/key_manager.dart';
import 'package:etebase_sync/src/crypto/keystore.dart';
import 'package:etebase_sync/src/items/factory_registry.dart';
import 'package:etebase_sync/src/items/proxy_record.dart';
import 'package:etebase_sync/src/online/server_ping_online_checker.dart';
import 'package:etebase_sync/src/storage/hive/hive_storage_manager.dart';
import 'package:etebase_sync/src/sync/storage_mode.dart';
import 'package:etebase_sync/src/sync/sync_mode.dart';
import 'package:hive_ce/hive.dart';
import 'package:sodium/sodium_sumo.dart';

class InMemoryKeystore implements Keystore {
  SecureKey? _key;

  @override
  Future<void> deleteStorageKey([String? prefix]) => Future.sync(() {
    _key?.dispose();
    _key = null;
  });

  @override
  Future<SecureKey?> loadStorageKey([String? prefix]) => Future.value(_key);

  @override
  Future<void> saveStorageKey(SecureKey key, [String? prefix]) =>
      Future.sync(() {
        _key = key;
      });
}

class StringRecord extends ProxyRecord<String> {
  StringRecord(super.repository, super._item);

  @override
  dynamic encode(String data) => data;

  @override
  String decode(dynamic data) => data as String;
}

Future<void> main() async {
  final sodium = await SodiumSumoInit.init(
    // replace with wherever libsodium is located on your machine
    () => DynamicLibrary.open('/usr/lib/aarch64-linux-gnu/libsodium.so'),
  );

  final client = Client.create(
    sodium,
    'etebase_sync_example',
    Uri.http('127.0.0.1:3735'),
  );

  Hive.init(Directory.systemTemp.createTempSync().path);

  final sync = EtebaseSync(
    client,
    HiveStorageManager(0, Hive, StorageMode.cached),
    FactoryRegistry(),
    const CollectionConflictResolver(),
    ServerPingOnlineChecker(client),
    KeyManager(InMemoryKeystore(), sodium),
  )..registerType('etebase_sync.example.string', StringRecord.new);
  await sync.init();
  // await sync.updateConfig(
  //   sync.config.copyWith(syncMode: const SyncMode.manual()),
  // );

  final username = base64Url.encode(client.randombytes(24));
  await sync.signup(
    username: username,
    email: '$username@mail.com',
    password: base64.encode(client.randombytes(32)),
  );

  final repoMgr = sync.repositoryManager;

  final primary = await repoMgr.openPrimary<StringRecord>();
  print(primary.uid);

  final all = await repoMgr.list<StringRecord>();
  print(all);

  final created = await repoMgr.create<StringRecord>(
    const RepositoryMetadata(name: 'Other'),
  );
  print(created.uid);

  await repoMgr.updateMeta<StringRecord>(
    all.keys.single,
    all.values.single.copyWith(name: 'Testing'),
  );

  print(await repoMgr.list<StringRecord>());

  await repoMgr.delete<StringRecord>(all.keys.single);

  print(await repoMgr.list<StringRecord>());

  final newPrimary = await repoMgr.openPrimary<StringRecord>();
  print(newPrimary.uid);

  print(await repoMgr.getMeta<StringRecord>(newPrimary.uid));

  print('disposing1');
  await primary.dispose();
  print('disposing2');
  await created.dispose();
  print('disposing3');
  await newPrimary.dispose();
  print('disposing4');
  await sync.dispose();
  print('disposed');
}
