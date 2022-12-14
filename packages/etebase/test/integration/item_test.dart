@TestOn('!windows')
library item_test;

import 'dart:convert';
import 'dart:typed_data';

// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
import 'util/matchers.dart';

void main() {
  const testCollectionType = 'etebase-dart.item_test';
  final testItemContent1 = Uint8List.fromList(
    List.generate(20, (index) => index + 10),
  );
  final testItemContent2 = Uint8List.fromList(List.filled(1024 * 1024, 0x42));
  const testItemName = 'test-name';
  const testItemTypeA = 'type-a';
  const testItemTypeB = 'type-b';

  late final EtebaseItemManager itemManager;

  late String itemId1;
  late String itemId2;
  late String itemId3;

  setUpAll(() async {
    await Etebase.ensureInitialized(loadLibEtebase);

    final client = await EtebaseClient.create('item-test', serverUri);
    addTearDown(client.dispose);

    final account = await createAccount(client, 'item-test-user');
    addTearDown(account.dispose);

    final collectionManager = await account.getCollectionManager();
    addTearDown(collectionManager.dispose);

    final collection = await collectionManager.create(
      testCollectionType,
      const EtebaseItemMetadata(),
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

      final item = await itemManager.create(
        const EtebaseItemMetadata(name: testItemName),
        testItemContent1,
      );
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
      expect(loadedMeta.name, testItemName);
      expect(loadedMeta.description, isNull);

      final cloned = await item.clone();
      addTearDown(cloned.dispose);
      expect(await cloned.getUid(), await item.getUid());
    });

    test('can be updated and deleted', () async {
      const testItemName = 'test-name';

      final item = await itemManager.create(
        const EtebaseItemMetadata(name: testItemName),
        testItemContent1,
      );
      addTearDown(item.dispose);

      final loadedMeta = await item.getMeta();
      await item.setContent(Uint8List(0));
      await item.setMeta(
        loadedMeta.copyWith(
          mtime: DateTime.now(),
        ),
      );

      await item.delete();
    });
  });

  group('item manager', () {
    test('can create items', () async {
      final item1 = await itemManager.create(
        const EtebaseItemMetadata(
          name: testItemName,
          itemType: testItemTypeA,
        ),
        testItemContent1,
      );
      addTearDown(item1.dispose);
      itemId1 = await item1.getUid();

      final item2 = await itemManager.create(
        const EtebaseItemMetadata(itemType: testItemTypeA),
        testItemContent2,
      );
      addTearDown(item2.dispose);
      itemId2 = await item2.getUid();

      final item3 = await itemManager.create(
        const EtebaseItemMetadata(itemType: testItemTypeB),
        Uint8List(0),
      );
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
      expect(meta1.itemType, testItemTypeA);
      expect(meta1.name, testItemName);

      final changedResponse = await itemManager.list(
        EtebaseFetchOptions(
          stoken: await listResponse.getStoken(),
        ),
      );
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
      await item3.setMeta(meta3.copyWith(mtime: DateTime.now()));

      await itemManager.batchDeps([item2], [item1]);
      await itemManager.transactionDeps([item3], [item1]);

      final meta1 = await item1.getMeta();
      await item1.setMeta(meta1.copyWith(mtime: DateTime.now()));
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

      await item.setMeta(
        meta.copyWith(
          mtime: DateTime.now(),
          description: '--deleted--',
        ),
      );
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
      expect(meta.itemType, testItemTypeA);

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
      expect(metaWithContent.itemType, testItemTypeA);
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
      expect(meta.itemType, testItemTypeA);
      expect(meta.name, testItemName);
      expect(meta.description, isNull);
      expect(meta.color, isNull);
      expect(meta.mtime, isNull);
    });
  });
}
