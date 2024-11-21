@TestOn('!windows')
library;

import 'dart:io';
import 'dart:typed_data';

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:hive_ce/hive.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';

void main() {
  const testCollectionType = 'etebase-dart.fs_cache_test';

  late final EtebaseClient client;
  late final EtebaseAccount account;
  late final EtebaseCache cache;

  setUpAll(() async {
    client = await createClient();
    addTearDown(client.dispose);

    final username = generateUsername('fs-cache-test-user');
    account = await EtebaseAccount.signup(
      client,
      EtebaseUser(
        username: username,
        email: '$username@test.com',
      ),
      'password',
    );
    addTearDown(account.dispose);

    final cacheDir = await Directory.systemTemp.createTemp();
    addTearDown(() => cacheDir.delete(recursive: true));

    Hive.init(cacheDir.path);
    addTearDown(Hive.close);

    cache = await EtebaseCache.create(
      client,
      username,
    );
    addTearDown(cache.dispose);
  });

  test('can cache and restore account', () async {
    await cache.saveAccount(account);
    final restoredAccount = await cache.loadAccount(client);
    await restoredAccount.fetchToken();

    final encryptionKey = EtebaseUtils.randomKey(client, 32);
    await cache.saveAccount(account, encryptionKey);
    final restoredAccountEnc = await cache.loadAccount(client, encryptionKey);
    await restoredAccountEnc.fetchToken();
  });

  test('can cache and restore collection list stoken', () async {
    final collectionManager = account.collectionManager;

    final collection = await collectionManager.create(
      testCollectionType,
      const EtebaseItemMetadata(),
      Uint8List(0),
    );
    addTearDown(collection.dispose);
    await collectionManager.upload(collection);

    await expectLater(
      () => cache.loadStoken(),
      throwsA(isA<NotFound>()),
    );

    final response = await collectionManager.list(testCollectionType);
    await cache.saveStoken(response.stoken!);
    final restoredToken = await cache.loadStoken();

    expect(restoredToken, response.stoken);

    await collectionManager.list(
      testCollectionType,
      EtebaseFetchOptions(stoken: restoredToken),
    );
  });

  test('can cache and restore collection and stoken', () async {
    final testCollectionData = Uint8List.fromList(List.filled(10, 10));

    final collectionManager = account.collectionManager;

    const meta = EtebaseItemMetadata();
    var collection = await collectionManager.create(
      testCollectionType,
      meta,
      testCollectionData,
    );
    addTearDown(collection.dispose);
    await collectionManager.upload(collection);
    final collectionId = collection.uid;

    final itemManager = collectionManager.getItemManager(collection);
    addTearDown(itemManager.dispose);
    final item = await itemManager.create(meta, Uint8List(0));
    addTearDown(item.dispose);
    await itemManager.batch([item]);

    collection = await collectionManager.fetch(collectionId);
    addTearDown(collection.dispose);

    await expectLater(
      () => cache.collectionGet(collectionManager, collectionId),
      throwsA(isA<NotFound>()),
    );
    await cache.collectionSet(collectionManager, collection);
    final restoredCollection = await cache.collectionGet(
      collectionManager,
      collectionId,
    );
    expect(restoredCollection.uid, collectionId);
    expect(await restoredCollection.getContent(), testCollectionData);

    await expectLater(
      () => cache.collectionLoadStoken(collectionId),
      throwsA(isA<NotFound>()),
    );
    await cache.collectionSaveStoken(
      collectionId,
      collection.stoken!,
    );
    final restoredToken = await cache.collectionLoadStoken(collectionId);

    expect(restoredToken, collection.stoken);

    await cache.collectionUnset(collectionManager, collectionId);
    await expectLater(
      () => cache.collectionGet(collectionManager, collectionId),
      throwsA(isA<NotFound>()),
    );
    await expectLater(
      () => cache.collectionLoadStoken(collectionId),
      throwsA(isA<NotFound>()),
    );
  });

  test('can cache and restore items', () async {
    final collectionManager = account.collectionManager;

    final collection = await collectionManager.create(
      testCollectionType,
      const EtebaseItemMetadata(),
      Uint8List(0),
    );
    addTearDown(collection.dispose);
    await collectionManager.upload(collection);
    final collectionId = collection.uid;
    await cache.collectionSet(collectionManager, collection);

    final itemManager = collectionManager.getItemManager(collection);
    addTearDown(itemManager.dispose);

    const itemMeta = EtebaseItemMetadata(color: 'AABBCC');
    final itemContent = Uint8List.fromList(List.filled(42, 42));
    final item = await itemManager.create(
      itemMeta,
      itemContent,
    );
    addTearDown(item.dispose);
    await itemManager.batch([item]);
    final itemId = item.uid;

    await expectLater(
      () => cache.itemGet(itemManager, collectionId, itemId),
      throwsA(isA<NotFound>()),
    );

    await cache.itemSet(itemManager, collectionId, item);

    final restoredItem = await cache.itemGet(itemManager, collectionId, itemId);
    expect(restoredItem.uid, itemId);
    expect(await restoredItem.getMeta(), itemMeta);
    expect(await restoredItem.getContent(), itemContent);
    expect(restoredItem.etag, item.etag);

    await cache.itemUnset(itemManager, collectionId, itemId);
    await expectLater(
      () => cache.itemGet(itemManager, collectionId, itemId),
      throwsA(isA<NotFound>()),
    );
  });

  test('can clear cache data', () async {
    await cache.clearUser(reInitialize: true);
    await expectLater(
      () => cache.loadAccount(client),
      throwsA(isA<NotFound>()),
    );

    await cache.clearUser();
    await expectLater(
      () => cache.loadAccount(client),
      throwsA(isA<HiveError>()),
    );
  });
}
