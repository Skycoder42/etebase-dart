@TestOn('!windows')
library fs_cache_test;

import 'dart:io';
import 'dart:typed_data';

// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
import 'util/matchers.dart';

void main() {
  const testCollectionType = 'etebase-dart.fs_cache_test';

  late final EtebaseClient client;
  late final EtebaseAccount account;
  late final EtebaseFileSystemCache cache;

  setUpAll(() async {
    Etebase.ensureInitialized(loadLibEtebase);

    client = await EtebaseClient.create('fs-cache-test', serverUri);
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
    cache = await EtebaseFileSystemCache.create(
      client,
      cacheDir.path,
      username,
    );
    addTearDown(cache.dispose);
  });

  test('can cache and restore account', () async {
    await cache.saveAccount(account);
    final restoredAccount = await cache.loadAccount(client);
    addTearDown(restoredAccount.dispose);
    await restoredAccount.fetchToken();

    final encryptionKey = await EtebaseUtils.randombytes(client, 32);
    await cache.saveAccount(account, encryptionKey);
    final restoredAccountEnc = await cache.loadAccount(client, encryptionKey);
    addTearDown(restoredAccountEnc.dispose);
    await restoredAccountEnc.fetchToken();
  });

  test('can cache and restore collection list stoken', () async {
    final collectionManager = await account.getCollectionManager();
    addTearDown(collectionManager.dispose);

    final collection = await collectionManager.create(
      testCollectionType,
      const EtebaseItemMetadata(),
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

    final response2 = await collectionManager.list(
      testCollectionType,
      EtebaseFetchOptions(stoken: restoredToken),
    );
    addTearDown(response2.dispose);
  });

  test('can cache and restore collection and stoken', () async {
    final testCollectionData = Uint8List.fromList(List.filled(10, 10));

    final collectionManager = await account.getCollectionManager();
    addTearDown(collectionManager.dispose);

    const meta = EtebaseItemMetadata();
    var collection = await collectionManager.create(
      testCollectionType,
      meta,
      testCollectionData,
    );
    addTearDown(collection.dispose);
    await collectionManager.upload(collection);
    final collectionId = await collection.getUid();

    final itemManager = await collectionManager.getItemManager(collection);
    addTearDown(itemManager.dispose);
    final item = await itemManager.create(meta, Uint8List(0));
    addTearDown(item.dispose);
    await itemManager.batch([item]);

    collection = await collectionManager.fetch(collectionId);
    addTearDown(collection.dispose);

    await expectLater(
      () => cache.collectionGet(collectionManager, collectionId),
      throwsEtebaseException(EtebaseErrorCode.urlParse),
    );
    await cache.collectionSet(collectionManager, collection);
    final restoredCollection = await cache.collectionGet(
      collectionManager,
      collectionId,
    );
    expect(await restoredCollection.getUid(), collectionId);
    expect(await restoredCollection.getContent(), testCollectionData);

    expect(await cache.collectionLoadStoken(collectionId), isNull);
    await cache.collectionSaveStoken(
      collectionId,
      (await collection.getStoken())!,
    );
    final restoredToken = await cache.collectionLoadStoken(collectionId);

    expect(restoredToken, await collection.getStoken());

    await cache.collectionUnset(collectionManager, collectionId);
    await expectLater(
      () => cache.collectionGet(collectionManager, collectionId),
      throwsEtebaseException(EtebaseErrorCode.urlParse),
    );
    expect(await cache.collectionLoadStoken(collectionId), isNull);
  });

  test('can cache and restore items', () async {
    final collectionManager = await account.getCollectionManager();
    addTearDown(collectionManager.dispose);

    final collection = await collectionManager.create(
      testCollectionType,
      const EtebaseItemMetadata(),
      Uint8List(0),
    );
    addTearDown(collection.dispose);
    await collectionManager.upload(collection);
    final collectionId = await collection.getUid();
    await cache.collectionSet(collectionManager, collection);

    final itemManager = await collectionManager.getItemManager(collection);
    addTearDown(itemManager.dispose);

    const itemMeta = EtebaseItemMetadata(color: 'AABBCC');
    final itemContent = Uint8List.fromList(List.filled(42, 42));
    final item = await itemManager.create(
      itemMeta,
      itemContent,
    );
    addTearDown(item.dispose);
    await itemManager.batch([item]);
    final itemId = await item.getUid();

    await expectLater(
      () => cache.itemGet(itemManager, collectionId, itemId),
      throwsEtebaseException(EtebaseErrorCode.urlParse),
    );

    await cache.itemSet(itemManager, collectionId, item);

    final restoredItem = await cache.itemGet(itemManager, collectionId, itemId);
    expect(await restoredItem.getUid(), itemId);
    expect(await restoredItem.getMeta(), itemMeta);
    expect(await restoredItem.getContent(), itemContent);
    expect(await restoredItem.getEtag(), await item.getEtag());

    await cache.itemUnset(itemManager, collectionId, itemId);
    await expectLater(
      () => cache.itemGet(itemManager, collectionId, itemId),
      throwsEtebaseException(EtebaseErrorCode.urlParse),
    );
  });

  test('can clear cache data', () async {
    await cache.clearUser();
    await expectLater(
      () => cache.loadAccount(client),
      throwsEtebaseException(EtebaseErrorCode.urlParse),
    );
  });
}
