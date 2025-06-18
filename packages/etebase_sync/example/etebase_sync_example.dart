import 'dart:convert';
import 'dart:ffi';

import 'package:etebase/etebase.dart';
import 'package:etebase_sync/src/api/conflict_resolution/conflict_resolver.dart';
import 'package:etebase_sync/src/api/models/repository_metadata.dart';
import 'package:etebase_sync/src/api/online_checker.dart';
import 'package:etebase_sync/src/api/repository.dart';
import 'package:etebase_sync/src/impl/etebase_sync_impl.dart';
import 'package:etebase_sync/src/impl/sync_cache_impl.dart';
import 'package:hive_ce/hive.dart';
import 'package:sodium/sodium_sumo.dart';

Future<void> main() async {
  final sodium = await SodiumSumoInit.init(
    // replace with wherever libsodium is located on your machine
    () => DynamicLibrary.open('/usr/lib/libsodium.so'),
  );
  final client = Client.create(
    sodium,
    'etebase_sync_example',
    Uri.http('127.0.0.1:3735'),
  )..registerCustomMetadata(RepositoryMetadata.fromJson);
  final userdata = base64Url.encode(client.randombytes(24));
  final account = await Account.signup(
    client,
    User(username: userdata, email: '$userdata@mail.com'),
    base64.encode(client.randombytes(32)),
  );

  final sync = EtebaseSyncImpl(
    const OnlineChecker.alwaysOnline(),
    const ConflictResolver.remote(),
    account,
    SyncCacheImpl(0, Hive),
  )..registerRepositoryType<String>('test', Repository<String>.new);
  final repoMgr = sync.repositoryManager;

  final primary = await repoMgr.openPrimary<String>();
  print(primary.collection.uid);

  final all = await repoMgr.list<String>();
  print(all);

  await repoMgr.create<String>(const RepositoryMetadata(name: 'Other'));

  await repoMgr.updateMeta<String>(
    all.keys.single,
    all.values.single.copyWith(name: 'Testing'),
  );

  print(await repoMgr.list<String>());

  await repoMgr.delete<String>(all.keys.single);

  print(await repoMgr.list<String>());

  final newPrimary = await repoMgr.openPrimary<String>();
  print(newPrimary.collection.uid);

  print(await repoMgr.getMeta<String>(newPrimary.collection.uid));
}
