import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:etebase/etebase.dart';
import 'package:etebase_sync/src/account/etebase_sync.dart';
import 'package:etebase_sync/src/account/keystore.dart';
import 'package:etebase_sync/src/collections/repository_metadata.dart';
import 'package:etebase_sync/src/items/proxy_record.dart';
import 'package:hive_ce/hive.dart';
import 'package:logging/logging.dart';
import 'package:sodium/sodium_sumo.dart';

class InMemoryKeystore implements Keystore {
  SecureKey? _key;

  @override
  Future<void> dispose() => Future.sync(() => _key?.dispose());

  @override
  Future<void> deleteStorageKey([String? prefix]) => Future.sync(() {
    _key?.dispose();
    _key = null;
  });

  @override
  Future<SecureKey?> loadStorageKey([String? prefix]) => Future.value(_key);

  @override
  Future<void> saveStorageKey(SecureKey key, [String? prefix]) =>
      Future.sync(() => _key = key);
}

class StringRecord extends ProxyRecord<String> {
  StringRecord(super.repository, super._item);

  @override
  dynamic encode(String data) => data;

  @override
  String decode(dynamic data) => data as String;
}

Future<void> main() async {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen(print);

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

  final sync = EtebaseSync(client: client, keystore: InMemoryKeystore())
    ..registerType('etebase_sync.example.string', StringRecord.new);
  await sync.init();

  final username = base64Url.encode(client.randombytes(24));
  await sync.signup(
    username: username,
    email: '$username@mail.com',
    password: base64.encode(client.randombytes(32)),
  );

  final repoMgr = sync.repositoryManager;

  print('>>>>>>>>> openPrimary');
  final primary = await repoMgr.openPrimary<StringRecord>();
  await Future<void>.delayed(const Duration(seconds: 1));
  print('<<<<<<<<< ${primary.uid}');

  print('>>>>>>>>> list');
  final all = await repoMgr.list<StringRecord>();
  await Future<void>.delayed(const Duration(seconds: 1));
  print('<<<<<<<<< $all');

  print('>>>>>>>>> create');
  final created = await repoMgr.create<StringRecord>(
    const RepositoryMetadata(name: 'Other'),
  );
  await Future<void>.delayed(const Duration(seconds: 1));
  print('<<<<<<<<< ${created.uid}');

  print('>>>>>>>>> updateMeta');
  await repoMgr.updateMeta<StringRecord>(
    all.keys.single,
    all.values.single.copyWith(name: 'Testing'),
  );
  await Future<void>.delayed(const Duration(seconds: 1));
  print('<<<<<<<<<');

  print('>>>>>>>>> list');
  final all2 = await repoMgr.list<StringRecord>();
  await Future<void>.delayed(const Duration(seconds: 1));
  print('<<<<<<<<< $all2');

  print('>>>>>>>>> delete');
  await repoMgr.delete<StringRecord>(all.keys.single);
  await Future<void>.delayed(const Duration(seconds: 1));
  print('<<<<<<<<<');

  print('>>>>>>>>> list');
  final all3 = await repoMgr.list<StringRecord>(sync: false);
  await Future<void>.delayed(const Duration(seconds: 1));
  print('<<<<<<<<< $all3');

  print('>>>>>>>>> openPrimary');
  final newPrimary = await repoMgr.openPrimary<StringRecord>();
  await Future<void>.delayed(const Duration(seconds: 1));
  print('<<<<<<<<< ${newPrimary.uid}');

  print('>>>>>>>>> getMeta');
  final meta = await repoMgr.getMeta<StringRecord>(newPrimary.uid);
  await Future<void>.delayed(const Duration(seconds: 1));
  print('<<<<<<<<< $meta');

  await primary.dispose();
  await created.dispose();
  await newPrimary.dispose();
  await sync.dispose();
}
