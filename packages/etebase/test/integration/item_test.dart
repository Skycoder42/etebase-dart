@TestOn('!windows')
library;

import 'dart:convert';
import 'dart:typed_data';

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';

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
    final client = await createClient();
    addTearDown(client.dispose);

    final account = await createAccount(client, 'collection-test-user');
    addTearDown(account.dispose);

    final collectionManager = account.collectionManager;
    final collection = await collectionManager.create(
      testCollectionType,
      const EtebaseItemMetadata(),
      Uint8List(0),
    );
    addTearDown(collection.dispose);

    await collectionManager.upload(collection);
    itemManager = collectionManager.getItemManager(collection);
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

      expect(item.verify(), anyOf(completes, isNull));
      expect(item.isDeleted, isFalse);

      expect(item.etag, isNotEmpty);
      expect(item.uid, isNotEmpty);
      expect(await item.getContent(), testItemContent1);

      final loadedMeta = await item.getMeta();
      expect(loadedMeta.name, testItemName);
      expect(loadedMeta.description, isNull);
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
      itemId1 = item1.uid;

      final item2 = await itemManager.create(
        const EtebaseItemMetadata(itemType: testItemTypeA),
        testItemContent2,
      );
      addTearDown(item2.dispose);
      itemId2 = item2.uid;

      final item3 = await itemManager.create(
        const EtebaseItemMetadata(itemType: testItemTypeB),
        Uint8List(0),
      );
      addTearDown(item3.dispose);
      itemId3 = item3.uid;

      await itemManager.batch([item1, item2, item3]);
    });

    test('can list items', () async {
      final listResponse = await itemManager.list();

      expect(listResponse.isDone, isTrue);
      expect(listResponse.stoken, allOf(isNotNull, isNotEmpty));

      final items = listResponse.data;
      expect(items, hasLength(3));

      expect(items[0].uid, itemId1);
      expect(items[1].uid, itemId2);
      expect(items[2].uid, itemId3);

      final meta1 = await items[0].getMeta();
      expect(meta1.itemType, testItemTypeA);
      expect(meta1.name, testItemName);

      final changedResponse = await itemManager.list(
        EtebaseItemFetchOptions(stoken: listResponse.stoken),
      );
      expect(changedResponse.data, isEmpty);

      final selectedItems = items.take(2).toList();
      final selectedResponse = await itemManager.fetchUpdates(selectedItems);
      expect(selectedResponse.data, isEmpty);
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
        throwsA(isA<Conflict>()),
      );
    });

    test('can modify multiple items', () async {
      final listResponse = await itemManager.fetchMulti([itemId1, itemId2]);

      expect(listResponse.isDone, isTrue);
      expect(listResponse.stoken, allOf(isNotNull, isNotEmpty));

      final items = listResponse.data;
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

      final item2Old = await itemManager.fetch(itemId2);
      addTearDown(item2Old.dispose);
      final item3Old = await itemManager.fetch(itemId3);
      addTearDown(item3Old.dispose);

      await item2.setContent(testItemContent1);
      final meta3 = await item3.getMeta();
      await item3.setMeta(meta3.copyWith(mtime: DateTime.now()));

      await itemManager.batch([item2], deps: [item1]);
      await itemManager.transaction([item3], deps: [item1]);

      final meta1 = await item1.getMeta();
      await item1.setMeta(meta1.copyWith(mtime: DateTime.now()));
      await item1.setContent(Uint8List.fromList(utf8.encode('TEST!')));

      expect(
        () => itemManager.batch([item1], deps: [item2Old]),
        throwsA(isA<Conflict>()),
      );
      expect(
        () => itemManager.transaction([item1], deps: [item3Old]),
        throwsA(isA<Conflict>()),
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
      expect(item.isDeleted, isTrue);

      await itemManager.batch([item]);

      final deletedItem = await itemManager.fetch(itemId3);
      addTearDown(deletedItem.dispose);
      expect(deletedItem.isDeleted, isTrue);
    });

    test('can save and restore item from and to cache', () async {
      final item = await itemManager.fetch(itemId2);
      addTearDown(item.dispose);

      final saved = itemManager.cacheSave(item);
      final restored = itemManager.cacheLoad(saved);
      addTearDown(restored.dispose);

      expect(restored.uid, itemId2);
      expect(restored.isMissingContent, isFalse);
      expect(await restored.getContent(), testItemContent1);
      final meta = await restored.getMeta();
      expect(meta.itemType, testItemTypeA);

      final savedWithoutContent = itemManager.cacheSave(
        item,
        saveContent: false,
      );
      final restoredWithoutContent = itemManager.cacheLoad(
        savedWithoutContent,
      );
      addTearDown(restoredWithoutContent.dispose);

      expect(restoredWithoutContent.uid, itemId2);
      expect(restoredWithoutContent.isMissingContent, isTrue);
      final metaWithContent = await restoredWithoutContent.getMeta();
      expect(metaWithContent.itemType, testItemTypeA);
      expect(restoredWithoutContent.getContent, throwsA(isA<MissingContent>()));

      await itemManager.downloadContent(restoredWithoutContent);
      expect(restoredWithoutContent.isMissingContent, isFalse);
      expect(await restoredWithoutContent.getContent(), testItemContent1);
    });
  });

  group('revisions', () {
    test('can list item revisions', () async {
      final item = await itemManager.fetch(itemId1);
      addTearDown(item.dispose);

      final response = await itemManager.itemRevisions(item);

      expect(response.isDone, isTrue);
      expect(response.iterator, isNotEmpty);

      final revisions = response.data;
      expect(revisions, hasLength(3));

      final item1 = revisions[0];
      expect(item1.uid, itemId1);
      expect(item1.etag, isNotEmpty);
      final meta = await revisions[0].getMeta();
      expect(meta.itemType, testItemTypeA);
      expect(meta.name, testItemName);
      expect(meta.description, isNull);
      expect(meta.color, isNull);
      expect(meta.mtime, isNull);
    });
  });
}
