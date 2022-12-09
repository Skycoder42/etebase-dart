@TestOn('!windows')
library fs_cache_test;

import 'dart:io';
import 'dart:typed_data';

// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
import 'util/server_controller.dart';

void main() {
  const testCollectionType = 'etebase-dart.fs_cache_test';

  late final Uri serverUri;
  late final EtebaseClient client;
  late final EtebaseAccount account;
  late final EtebaseFileSystemCache cache;

  setUpAll(() async {
    await Etebase.ensureInitialized(loadLibEtebase);
    serverUri = await ServerController().start();

    client = await EtebaseClient.create('fs-cache-test', serverUri);
    addTearDown(client.dispose);

    const username = 'fs-cache-test-user';
    final user = await EtebaseUser.create(
      username,
      'fs.cache@test.com',
    );
    account = await EtebaseAccount.signup(client, user, 'password');
    addTearDown(account.dispose);
    await user.dispose();

    final cacheDir = await Directory.systemTemp.createTemp();
    addTearDown(() => cacheDir.delete(recursive: true));
    cache = await EtebaseFileSystemCache.create(cacheDir.path, username);
    addTearDown(cache.dispose);
  });

  test('can cache and restore account', () async {
    await cache.saveAccount(account);
    final restoredAccount = await cache.loadAccount(client);
    addTearDown(restoredAccount.dispose);
    await restoredAccount.fetchToken();

    final encryptionKey = await EtebaseUtils.randombytes(32);
    await cache.saveAccount(account, encryptionKey);
    final restoredAccountEnc = await cache.loadAccount(client, encryptionKey);
    addTearDown(restoredAccountEnc.dispose);
    await restoredAccountEnc.fetchToken();
  });

  test('can cache and restore collection list stoken', () async {
    final collectionManager = await account.getCollectionManager();
    addTearDown(collectionManager.dispose);

    final meta = await EtebaseItemMetadata.create();
    addTearDown(meta.dispose);
    final collection = await collectionManager.create(
      testCollectionType,
      meta,
      Uint8List(0),
    );
    addTearDown(collection.dispose);
    await collectionManager.upload(collection);

    expect(await cache.loadStoken(), isNull);

    final response = await collectionManager.list(testCollectionType);
    addTearDown(response.dispose);
    await cache.saveStoken((await response.getStoken())!);
    final restoredToken = await cache.loadStoken();

    expect(restoredToken, await response.getStoken());

    final options = await EtebaseFetchOptions.create();
    addTearDown(options.dispose);
    await options.setStoken(restoredToken);
    final response2 = await collectionManager.list(testCollectionType, options);
    addTearDown(response2.dispose);
  });

  // test('can cache and restore collection stoken', () async {
  //   final collectionManager = await account.getCollectionManager();
  //   addTearDown(collectionManager.dispose);

  //   final meta = await EtebaseItemMetadata.create();
  //   addTearDown(meta.dispose);
  //   var collection = await collectionManager.create(
  //     testCollectionType,
  //     meta,
  //     Uint8List.fromList(List.filled(10, 10)),
  //   );
  //   addTearDown(collection.dispose);
  //   await collectionManager.upload(collection);
  //   final collectionId = await collection.getUid();

  //   final itemManager = await collectionManager.getItemManager(collection);
  //   addTearDown(itemManager.dispose);
  //   final item = await itemManager.create(meta, Uint8List(0));
  //   addTearDown(item.dispose);
  //   await itemManager.batch([item]);

  //   collection = await collectionManager.fetch(collectionId);
  //   addTearDown(collection.dispose);

  //   expect(await cache.collectionLoadStoken(collectionId), isNull);

  //   await cache.collectionSaveStoken(
  //     collectionId,
  //     (await collection.getStoken())!,
  //   );
  //   final restoredToken = await cache.collectionLoadStoken(collectionId);

  //   expect(restoredToken, await collection.getStoken());
  // });
}
