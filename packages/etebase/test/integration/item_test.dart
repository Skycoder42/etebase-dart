@TestOn('!windows')
library item_test;

import 'dart:convert';
import 'dart:typed_data';

// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
import 'util/matchers.dart';
import 'util/server_controller.dart';

void main() {
  const testCollectionType = 'etebase-dart.item_test';
  final testItemContent1 = Uint8List.fromList(
    List.generate(20, (index) => index + 10),
  );
  final testItemContent2 = Uint8List.fromList(List.filled(1024 * 1024, 0x42));
  const testItemName = 'test-name';
  const testItemTypeA = 'type-a';
  const testItemTypeB = 'type-b';

  late final Uri serverUri;
  late final EtebaseItemManager itemManager;

  late String itemId1;
  late String itemId2;
  late String itemId3;

  setUpAll(() async {
    await Etebase.ensureInitialized(loadLibEtebase);
    serverUri = await ServerController().start();

    final client = await EtebaseClient.create('item-test', serverUri);
    addTearDown(client.dispose);

    final user = await EtebaseUser.create(
      'item-test-user',
      'item@test.com',
    );
    final account = await EtebaseAccount.signup(client, user, 'password');
    addTearDown(account.dispose);
    await user.dispose();

    final collectionManager = await account.getCollectionManager();
    addTearDown(collectionManager.dispose);

    final collectionMeta = await EtebaseItemMetadata.create();
    addTearDown(collectionMeta.dispose);
    final collection = await collectionManager.create(
      testCollectionType,
      collectionMeta,
      Uint8List(0),
    );
    addTearDown(collection.dispose);

    await collectionManager.upload(collection);
    itemManager = await collectionManager.getItemManager(collection);
    addTearDown(itemManager.dispose);
  });

  group('items', () {
    test('can create item', () async {
      const testItemName = 'test-name';

      final meta = await EtebaseItemMetadata.create();
      addTearDown(meta.dispose);
      await meta.setName(testItemName);

      final item = await itemManager.create(meta, testItemContent1);
      addTearDown(item.dispose);

      expect(await item.verify(), isTrue);
      expect(await item.isDeleted(), isFalse);

      expect(await item.getEtag(), isNotEmpty);
      expect(await item.getUid(), isNotEmpty);
      expect(await item.getContent(), testItemContent1);
      expect(
        await item.getContent(testItemContent1.length - 10),
        testItemContent1,
      );
      expect(
        await item.getContent(testItemContent1.length),
        testItemContent1,
      );
      expect(
        await item.getContent(testItemContent1.length + 10),
        testItemContent1,
      );

      final loadedMeta = await item.getMeta();
      addTearDown(loadedMeta.dispose);
      expect(await loadedMeta.getName(), testItemName);
      expect(await loadedMeta.getDescription(), isNull);

      final cloned = await item.clone();
      addTearDown(cloned.dispose);
      expect(await cloned.getUid(), await item.getUid());
    });

    test('can be updated and deleted', () async {
      const testItemName = 'test-name';

      final meta = await EtebaseItemMetadata.create();
      addTearDown(meta.dispose);
      await meta.setName(testItemName);
      final item = await itemManager.create(meta, testItemContent1);
      addTearDown(item.dispose);

      final loadedMeta = await item.getMeta();
      addTearDown(loadedMeta.dispose);
      await loadedMeta.setMtime(DateTime.now());
      await item.setContent(Uint8List(0));
      await item.setMeta(loadedMeta);

      await item.delete();
    });
  });

  group('item manager', () {
    test('can create items', () async {
      final meta1 = await EtebaseItemMetadata.create();
      addTearDown(meta1.dispose);
      await meta1.setName(testItemName);
      await meta1.setItemType(testItemTypeA);
      final item1 = await itemManager.create(meta1, testItemContent1);
      addTearDown(item1.dispose);
      itemId1 = await item1.getUid();

      final meta2 = await EtebaseItemMetadata.create();
      addTearDown(meta2.dispose);
      await meta2.setItemType(testItemTypeA);
      final item2 = await itemManager.create(meta2, testItemContent2);
      addTearDown(item2.dispose);
      itemId2 = await item2.getUid();

      final meta3 = await EtebaseItemMetadata.create();
      addTearDown(meta3.dispose);
      await meta3.setItemType(testItemTypeB);
      final item3 = await itemManager.create(meta3, Uint8List(0));
      addTearDown(item3.dispose);
      itemId3 = await item3.getUid();

      await itemManager.batch([item1, item2, item3]);
    });

    test('can list items', () async {
      final listResponse = await itemManager.list();
      addTearDown(listResponse.dispose);

      expect(await listResponse.isDone(), isTrue);
      expect(await listResponse.getStoken(), allOf(isNotNull, isNotEmpty));

      final items = await listResponse.getData();
      expect(items, hasLength(3));

      expect(await items[0].getUid(), itemId1);
      expect(await items[1].getUid(), itemId2);
      expect(await items[2].getUid(), itemId3);

      final meta1 = await items[0].getMeta();
      addTearDown(meta1.dispose);
      expect(await meta1.getItemType(), testItemTypeA);
      expect(await meta1.getName(), testItemName);

      final fetchOptions = await EtebaseFetchOptions.create();
      addTearDown(fetchOptions.dispose);
      await fetchOptions.setStoken(await listResponse.getStoken());
      final changedResponse = await itemManager.list(fetchOptions);
      addTearDown(changedResponse.dispose);
      expect(await changedResponse.getData(), isEmpty);

      final selectedItems = items.take(2).toList();
      final selectedResponse = await itemManager.fetchUpdates(selectedItems);
      addTearDown(selectedResponse.dispose);
      expect(await selectedResponse.getData(), isEmpty);
    });

    test('can modify single item', () async {
      final item1 = await itemManager.fetch(itemId1);
      addTearDown(item1.dispose);
      final item2 = await itemManager.fetch(itemId1);
      addTearDown(item2.dispose);

      await item1.setContent(Uint8List(0));
      await itemManager.transaction([item1]);

      await item2.setContent(Uint8List.fromList([1, 2, 3]));

      expect(
        () => itemManager.transaction([item2]),
        throwsEtebaseException(EtebaseErrorCode.conflict),
      );
    });

    test('can modify multiple items', () async {
      final listResponse = await itemManager.fetchMulti([itemId1, itemId2]);
      addTearDown(listResponse.dispose);

      expect(await listResponse.isDone(), isTrue);
      expect(await listResponse.getStoken(), allOf(isNotNull, isNotEmpty));

      final items = await listResponse.getData();
      expect(items, hasLength(2));

      for (final item in items) {
        await item.setContent(testItemContent2);
      }

      await itemManager.transaction(items);
    });

    test('can upload and transact with dependencies', () async {
      final item1 = await itemManager.fetch(itemId1);
      addTearDown(item1.dispose);
      final item2 = await itemManager.fetch(itemId2);
      addTearDown(item2.dispose);
      final item3 = await itemManager.fetch(itemId3);
      addTearDown(item3.dispose);

      final item2Old = await item2.clone();
      addTearDown(item2Old.dispose);
      final item3Old = await item3.clone();
      addTearDown(item3Old.dispose);

      await item2.setContent(testItemContent1);
      final meta3 = await item3.getMeta();
      addTearDown(meta3.dispose);
      await meta3.setMtime(DateTime.now());
      await item3.setMeta(meta3);

      await itemManager.batchDeps([item2], [item1]);
      await itemManager.transactionDeps([item3], [item1]);

      final meta1 = await item1.getMeta();
      addTearDown(meta1.dispose);
      await meta1.setMtime(DateTime.now());
      await item1.setMeta(meta1);
      await item1.setContent(Uint8List.fromList(utf8.encode('TEST!')));

      expect(
        () => itemManager.batchDeps([item1], [item2Old]),
        throwsEtebaseException(EtebaseErrorCode.conflict),
      );
      expect(
        () => itemManager.transactionDeps([item1], [item3Old]),
        throwsEtebaseException(EtebaseErrorCode.conflict),
      );
    });

    test('can upload deleted item', () async {
      final item = await itemManager.fetch(itemId3);
      addTearDown(item.dispose);

      final meta = await item.getMeta();
      addTearDown(meta.dispose);

      await meta.setMtime(DateTime.now());
      await meta.setDescription('--deleted--');
      await item.setMeta(meta);
      await item.delete();
      expect(await item.isDeleted(), isTrue);

      await itemManager.batch([item]);

      final deletedItem = await itemManager.fetch(itemId3);
      addTearDown(deletedItem.dispose);
      expect(await deletedItem.isDeleted(), isTrue);
    });

    test('can save and restore item from and to cache', () async {
      final item = await itemManager.fetch(itemId2);
      addTearDown(item.dispose);

      final saved = await itemManager.cacheSave(item);
      final restored = await itemManager.cacheLoad(saved);
      addTearDown(restored.dispose);

      expect(await restored.getUid(), itemId2);
      expect(await restored.getContent(), testItemContent1);
      final meta = await restored.getMeta();
      addTearDown(meta.dispose);
      expect(await meta.getItemType(), testItemTypeA);

      final savedWithContent = await itemManager.cacheSaveWithContent(
        item,
      );
      final restoredWithContent = await itemManager.cacheLoad(
        savedWithContent,
      );
      addTearDown(restoredWithContent.dispose);

      expect(await restoredWithContent.getUid(), itemId2);
      expect(await restoredWithContent.getContent(), testItemContent1);
      final metaWithContent = await restoredWithContent.getMeta();
      addTearDown(metaWithContent.dispose);
      expect(await metaWithContent.getItemType(), testItemTypeA);
    });
  });

  group('revisions', () {
    test('can list item revisions', () async {
      final item = await itemManager.fetch(itemId1);
      addTearDown(item.dispose);

      final response = await itemManager.itemRevisions(item);
      addTearDown(response.dispose);

      expect(await response.isDone(), isTrue);
      expect(await response.getIterator(), isNotEmpty);

      final revisions = await response.getData();
      expect(revisions, hasLength(3));

      final item1 = revisions[0];
      expect(await item1.getUid(), itemId1);
      expect(await item1.getEtag(), isNotEmpty);
      final meta = await revisions[0].getMeta();
      addTearDown(meta.dispose);
      expect(await meta.getItemType(), testItemTypeA);
      expect(await meta.getName(), testItemName);
      expect(await meta.getDescription(), isNull);
      expect(await meta.getColor(), isNull);
      expect(await meta.getMtime(), isNull);
    });
  });
}
