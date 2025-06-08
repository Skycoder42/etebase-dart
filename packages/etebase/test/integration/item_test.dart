@TestOn('!windows')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:async/async.dart';
// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/custom_metadata.dart';
import 'util/js_client_wrapper.dart';
import 'util/library_loader.dart';
import 'util/test_helpers.dart';

void main() {
  const testCollectionType = 'etebase-dart.item_test';
  final testItemContent1 = Uint8List.fromList(
    List.generate(20, (index) => index + 10),
  );
  final testItemContent2 = Uint8List.fromList(List.filled(1024 * 1024, 0x42));
  const testItemName = 'test-name';
  const testItemTypeA = 'type-a';
  const testItemTypeB = 'type-b';

  final jsClientWrapper = JsClientWrapper();
  late final EtebaseClient client;
  late final EtebaseItemManager itemManager;

  late String itemId1;
  late String itemId2;
  late String itemId3;
  late String itemId4;

  setUpAll(() async {
    client = await createClient()
      ..registerCustomMetadata(CustomMetadata.fromJson);
    addTearDown(client.dispose);

    final account = await createAccount(client, 'collection-test-user');
    addTearDown(account.dispose);

    final collectionManager = account.collectionManager;
    final collection = await collectionManager.create(
      testCollectionType,
      const ItemMetadata(),
      Uint8List(0),
    );
    addTearDown(collection.dispose);

    await collectionManager.upload(collection);
    itemManager = collectionManager.getItemManager(collection);
    addTearDown(itemManager.dispose);

    jsClientWrapper.configureAccount(account, collection);
  });

  var previous = -1;
  var prefix = '';
  void printProgress(int current, int total) {
    final currentPercent = current / total;
    final progress = 50 * currentPercent;
    final filled = progress.floor();
    if (filled == previous) {
      return;
    }
    previous = filled;
    final buffer = StringBuffer(prefix)
      ..write('[')
      ..write('#' * filled)
      ..write(' ' * (50 - filled))
      ..write(']');
    // ignore: avoid_print
    print(buffer);
  }

  group('items', () {
    test('can create item', () async {
      const testItemName = 'test-name';

      final item = await itemManager.create(
        const ItemMetadata(name: testItemName),
        testItemContent1,
      );
      addTearDown(item.dispose);

      expect(item.verify(), anyOf(completes, isNull));

      expect(item.uid, isNotEmpty);
      expect(item.etag, isNotEmpty);
      expect(item.isDeleted, isFalse);
      expect(item.isMissingContent, isFalse);
      expect(await item.getContent(), testItemContent1);

      final loadedMeta = await item.getMeta();
      expect(loadedMeta.name, testItemName);
      expect(loadedMeta.description, isNull);
    });

    test('can be updated', () async {
      const testItemName = 'test-name';
      final testNow = DateTime.now();

      final item = await itemManager.create(
        const ItemMetadata(name: testItemName),
        testItemContent1,
      );
      addTearDown(item.dispose);

      final loadedMeta = await item.getMeta();
      await item.setContent(testItemContent2);
      await item.setMeta(loadedMeta.copyWith(mtime: testNow));

      expect(item.verify(), completes);
      expect(await item.getContent(), testItemContent2);

      final updatedMeta = await item.getMeta();
      expect(updatedMeta.name, testItemName);
      expect(updatedMeta.mtime, dtEquals(testNow));
    });

    test('can be deleted', () async {
      const testItemName = 'test-name';

      final item = await itemManager.create(
        const ItemMetadata(name: testItemName),
        testItemContent1,
      );
      addTearDown(item.dispose);

      await item.delete();

      expect(item.verify(), completes);
      expect(item.isDeleted, isTrue);
      expect(await item.getContent(), isEmpty);

      final loadedMeta = await item.getMeta();
      expect(loadedMeta.name, testItemName);
    });
  });

  group('item manager', () {
    test('can create items', () async {
      final item1 = await itemManager.create(
        const ItemMetadata(name: testItemName, itemType: testItemTypeA),
        testItemContent1,
      );
      addTearDown(item1.dispose);
      itemId1 = item1.uid;

      final item2 = await itemManager.create(
        const ItemMetadata(itemType: testItemTypeA),
        testItemContent2,
      );
      addTearDown(item2.dispose);
      itemId2 = item2.uid;

      final item3 = await itemManager.create(
        const ItemMetadata(itemType: testItemTypeB),
        Uint8List(0),
      );
      addTearDown(item3.dispose);
      itemId3 = item3.uid;

      await itemManager.batch([item1, item2, item3]);

      // validate items exits in JS
      final jsItemIds = await jsClientWrapper
          .executeForCollection<List<String>>(const Action.listItems());
      expect(jsItemIds, [itemId1, itemId2, itemId3]);

      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(
          itemId1,
          meta: await item1.getMeta(),
          content: testItemContent1,
          isDeleted: false,
        ),
      );
      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(
          itemId2,
          meta: await item2.getMeta(),
          content: testItemContent2,
          isDeleted: false,
        ),
      );
      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(
          itemId3,
          meta: await item3.getMeta(),
          content: Uint8List(0),
          isDeleted: false,
        ),
      );
    });

    test('can list items', () async {
      // create a fourth via JS
      itemId4 = await jsClientWrapper.executeForCollection<String>(
        Action.createItem(
          const ItemMetadata(itemType: testItemTypeB, name: 'js-item'),
          testItemContent1,
        ),
      );

      final listResponse = await itemManager.list();

      expect(listResponse.isDone, isTrue);
      expect(listResponse.stoken, allOf(isNotNull, isNotEmpty));

      final items = listResponse.data;
      expect(items, hasLength(4));

      expect(items[0].uid, itemId1);
      expect(items[1].uid, itemId2);
      expect(items[2].uid, itemId3);
      expect(items[3].uid, itemId4);

      final meta1 = await items[0].getMeta();
      expect(meta1.itemType, testItemTypeA);
      expect(meta1.name, testItemName);

      // no further updates
      final changedResponse = await itemManager.list(
        ItemFetchOptions(stoken: listResponse.stoken),
      );
      expect(changedResponse.data, isEmpty);

      final selectedItems = items.take(2).toList();
      final selectedResponse = await itemManager.fetchUpdates(selectedItems);
      expect(selectedResponse.data, isEmpty);

      // can also fetch items directly
      final fetchedResponse = await itemManager.fetchMulti([
        itemId1,
        itemId3,
        itemId4,
      ]);

      expect(fetchedResponse.isDone, isTrue);
      expect(fetchedResponse.stoken, allOf(isNotNull, isNotEmpty));

      final fetchedItems = fetchedResponse.data;
      expect(fetchedItems, hasLength(3));
      expect(
        fetchedItems,
        unorderedEquals([
          isA<EtebaseItem>().having((m) => m.uid, 'uid', itemId1),
          isA<EtebaseItem>().having((m) => m.uid, 'uid', itemId3),
          isA<EtebaseItem>().having((m) => m.uid, 'uid', itemId4),
        ]),
      );
    });

    test('can modify single item', () async {
      final item1 = await itemManager.fetch(itemId1);
      addTearDown(item1.dispose);
      final item2 = await itemManager.fetch(itemId1);
      addTearDown(item2.dispose);

      final updatedContent = Uint8List.fromList(utf8.encode('updated content'));
      await item1.setContent(updatedContent);
      await itemManager.transaction([item1]);

      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(
          itemId1,
          meta: await item1.getMeta(),
          content: updatedContent,
          isDeleted: false,
        ),
      );

      // fetch updates
      final item1Updates = await itemManager.fetchUpdates([item1]);
      expect(item1Updates.data, isEmpty);
      final item2Updates = await itemManager.fetchUpdates([item2]);
      expect(item2Updates.data, hasLength(1));
      expect(item2Updates.isDone, isTrue);

      final updatedItem2 = item2Updates.data.single;
      expect(updatedItem2.etag, item1.etag);
      expect(updatedItem2.getContent(), completion(updatedContent));

      // try update
      await item2.setContent(Uint8List.fromList([1, 2, 3]));

      expect(() => itemManager.transaction([item2]), throwsA(isA<Conflict>()));

      // now update in js and try the same thing
      await jsClientWrapper.executeForCollection<void>(
        Action.updateItem(
          itemId1,
          meta: (await item1.getMeta()).copyWith(color: '#123456'),
        ),
      );

      // fetch updates
      final jsUpdates = await itemManager.fetchUpdates([item1]);
      expect(jsUpdates.data, hasLength(1));
      expect(jsUpdates.isDone, isTrue);

      final jsItem = jsUpdates.data.single;
      expect(
        jsItem.getMeta(),
        completion(
          isA<ItemMetadata>().having((m) => m.color, 'color', '#123456'),
        ),
      );

      // try update
      await item1.setContent(Uint8List(0));

      expect(() => itemManager.transaction([item1]), throwsA(isA<Conflict>()));
    });

    test('can modify multiple items', () async {
      final listResponse = await itemManager.fetchMulti([
        itemId1,
        itemId2,
        itemId4,
      ]);

      expect(listResponse.isDone, isTrue);
      expect(listResponse.stoken, allOf(isNotNull, isNotEmpty));

      final items = listResponse.data;
      expect(items, hasLength(3));

      for (final item in items) {
        await item.setContent(testItemContent2);
      }

      await itemManager.transaction(items);

      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(itemId1, content: testItemContent2),
      );
      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(itemId2, content: testItemContent2),
      );
      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(itemId4, content: testItemContent2),
      );
    });

    test('can upload and transact with dependencies', () async {
      final item1 = await itemManager.fetch(itemId1);
      addTearDown(item1.dispose);
      final item2 = await itemManager.fetch(itemId2);
      addTearDown(item2.dispose);
      final item3 = await itemManager.fetch(itemId3);
      addTearDown(item3.dispose);
      final item4 = await itemManager.fetch(itemId4);
      addTearDown(item4.dispose);

      final item2Old = await itemManager.fetch(itemId2);
      addTearDown(item2Old.dispose);
      final item3Old = await itemManager.fetch(itemId3);
      addTearDown(item3Old.dispose);

      await item2.setContent(testItemContent1);
      final meta4 = await item4.getMeta();
      await item4.setMeta(meta4.copyWith(description: 'updated'));

      await itemManager.batch([item2], deps: [item1]);
      await itemManager.transaction([item4], deps: [item1, item3]);

      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(itemId2, content: testItemContent1),
      );
      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(itemId4, meta: await item4.getMeta()),
      );

      await jsClientWrapper.executeForCollection<void>(
        Action.updateItem(
          itemId3,
          meta: (await item3.getMeta()).copyWith(description: 'updated'),
        ),
      );

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
      final item = await itemManager.fetch(itemId4);
      addTearDown(item.dispose);

      final meta = await item.getMeta();
      final updatedMeta = meta.copyWith(description: '--deleted--');

      await item.setMeta(updatedMeta);
      await item.delete();
      expect(item.isDeleted, isTrue);
      expect(item.getMeta(), completion(updatedMeta));
      expect(item.getContent(), completion(isEmpty));

      await itemManager.batch([item]);

      final deletedItem = await itemManager.fetch(itemId4);
      addTearDown(deletedItem.dispose);
      expect(deletedItem.isDeleted, isTrue);
      expect(deletedItem.getMeta(), completion(updatedMeta));
      expect(deletedItem.getContent(), completion(isEmpty));

      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(
          itemId4,
          meta: updatedMeta,
          content: Uint8List(0),
          isDeleted: true,
        ),
      );

      // now delete from js
      await jsClientWrapper.executeForCollection<void>(
        Action.updateItem(itemId3, delete: true),
      );

      final jsDeletedCol = await itemManager.fetch(itemId3);
      addTearDown(jsDeletedCol.dispose);
      expect(jsDeletedCol.isDeleted, isTrue);
      expect(jsDeletedCol.getContent(), completion(isEmpty));
    });

    test('can preserve content of deleted items', () async {
      final delTest1 = await itemManager.create(
        const ItemMetadata(),
        testItemContent1,
      );
      final delTest2 = await itemManager.create(
        const ItemMetadata(),
        testItemContent2,
      );

      await itemManager.batch([delTest1, delTest2]);

      // delete first from dart
      await delTest1.delete(preserveContent: true);
      await itemManager.transaction([delTest1]);

      expect(delTest1.getContent(), completion(testItemContent1));
      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(
          delTest1.uid,
          content: testItemContent1,
          isDeleted: true,
        ),
      );

      // delete from js
      await jsClientWrapper.executeForCollection<void>(
        Action.updateItem(delTest2.uid, delete: true, preserveContent: true),
      );

      final updatedTest2 = await itemManager.fetch(delTest2.uid);
      expect(updatedTest2.getContent(), completion(testItemContent2));
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
      final restoredWithoutContent = itemManager.cacheLoad(savedWithoutContent);
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

    test('can save and restore item from different client', () async {
      final item4 = await itemManager.fetch(itemId4);
      addTearDown(item4.dispose);
      final savedDart = itemManager.cacheSave(item4);

      await jsClientWrapper.executeForCollection<void>(
        Action.restoreItem(
          savedDart,
          meta: const ItemMetadata(
            itemType: testItemTypeB,
            name: 'js-item',
            description: '--deleted--',
          ),
          content: Uint8List(0),
          isDeleted: true,
        ),
      );

      final savedJs = await jsClientWrapper.executeForCollection<Uint8List>(
        Action.saveItem(itemId2),
      );
      final restored = itemManager.cacheLoad(savedJs);
      addTearDown(restored.dispose);

      expect(restored.uid, itemId2);
      expect(restored.isMissingContent, isFalse);
      expect(await restored.getContent(), testItemContent1);
      final meta = await restored.getMeta();
      expect(meta.itemType, testItemTypeA);

      final item2 = await itemManager.fetch(itemId2);
      addTearDown(item2.dispose);
      final savedWithoutContentDart = itemManager.cacheSave(
        item2,
        saveContent: false,
      );

      await jsClientWrapper.executeForCollection<void>(
        Action.restoreItem(
          savedWithoutContentDart,
          meta: const ItemMetadata(itemType: testItemTypeA),
          noContent: true,
          isDeleted: false,
        ),
      );

      final savedWithoutContentJs = await jsClientWrapper
          .executeForCollection<Uint8List>(
            Action.saveItem(itemId2, preserveContent: false),
          );
      final restoredWithoutContent = itemManager.cacheLoad(
        savedWithoutContentJs,
      );
      addTearDown(restoredWithoutContent.dispose);

      expect(restoredWithoutContent.uid, itemId2);
      expect(restoredWithoutContent.isMissingContent, isTrue);
      final metaWithoutContent = await restored.getMeta();
      expect(metaWithoutContent.itemType, testItemTypeA);
      expect(restoredWithoutContent.getContent, throwsA(isA<MissingContent>()));
    });
  });

  test('can list item revisions', () async {
    final item = await itemManager.fetch(itemId1);
    addTearDown(item.dispose);

    final response = await itemManager.itemRevisions(item);

    expect(response.isDone, isTrue);
    expect(response.iterator, isNotEmpty);

    final revisions = response.data;
    expect(revisions, hasLength(4));

    final item1 = revisions[0];
    expect(item1.uid, itemId1);
    expect(item1.etag, isNotEmpty);
    final meta = await revisions[0].getMeta();
    expect(meta.itemType, testItemTypeA);
    expect(meta.name, testItemName);
    expect(meta.description, isNull);
    expect(meta.color, '#123456');
    expect(meta.mtime, isNull);
  });

  test(
    'can upload and download content separately',
    timeout: const Timeout.factor(3),
    () async {
      final bigContentChunks = List.generate(
        13,
        (_) => client.randombytes(1234567),
      );
      final bigContentBuilder = BytesBuilder(copy: false);
      bigContentChunks.forEach(bigContentBuilder.add);
      final bigContent = bigContentBuilder.takeBytes();

      final item = await itemManager.fetch(itemId1);
      final originalEtag = item.etag;
      await item.setContentStream(Stream.fromIterable(bigContentChunks));

      prefix = 'Uploading - ';
      await itemManager.uploadContent(item, onProgress: printProgress);

      var updated = await itemManager.fetch(itemId1);
      expect(updated.etag, originalEtag);
      expect(await updated.getContent(), testItemContent2);
      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(item.uid, content: testItemContent2),
      );

      await itemManager.batch([item]);

      updated = await itemManager.fetch(itemId1);
      expect(updated.etag, item.etag);
      expect(await updated.getContent(), bigContent);
      await jsClientWrapper.executeForCollection<void>(
        Action.validateItem(item.uid, content: bigContent),
      );

      final itemWithoutContent = await itemManager.fetch(
        itemId1,
        const ItemFetchOptions(prefetch: PrefetchOption.medium),
      );

      expect(itemWithoutContent.isMissingContent, isTrue);

      prefix = 'Downloading - ';
      await itemManager.downloadContent(
        itemWithoutContent,
        onProgress: printProgress,
      );
      expect(itemWithoutContent.isMissingContent, isFalse);

      var offset = 0;
      await for (final chunk in updated.getContentStream()) {
        expect(
          chunk,
          Uint8List.sublistView(bigContent, offset, offset + chunk.length),
        );
        offset += chunk.length;
      }
      expect(offset, bigContent.length);
    },
  );

  test('can subscribe to changes', testOn: 'linux || browser', () async {
    final listResponse = await itemManager.list();
    final stoken = listResponse.stoken;

    final stream = itemManager.subscribeChanges(
      ItemFetchOptions(stoken: stoken),
    );
    final queue = StreamQueue(stream);

    // create single item
    final item1 = await itemManager.create(const ItemMetadata(), Uint8List(0));
    await itemManager.batch([item1]);

    final event1 = await queue.next;
    expect(event1.isDone, isTrue);
    expect(event1.data, hasLength(1));
    expect(
      event1.data,
      contains(isA<EtebaseItem>().having((m) => m.uid, 'uid', item1.uid)),
    );

    // create another
    final item2 = await itemManager.create(const ItemMetadata(), Uint8List(0));
    await itemManager.batch([item2]);

    final event2 = await queue.next;
    expect(event2.isDone, isTrue);
    expect(event2.data, hasLength(1));
    expect(
      event2.data,
      contains(isA<EtebaseItem>().having((m) => m.uid, 'uid', item2.uid)),
    );

    // update both
    await item1.setMeta(const ItemMetadata(name: 'updated'));
    await item1.setContent(testItemContent2);
    await item2.delete();
    await itemManager.batch([item1, item2]);

    final event3 = await queue.next;
    expect(event3.isDone, isTrue);
    expect(event3.data, hasLength(2));
    expect(
      event3.data,
      contains(isA<EtebaseItem>().having((m) => m.uid, 'uid', item1.uid)),
    );
    expect(
      event3.data,
      contains(isA<EtebaseItem>().having((m) => m.uid, 'uid', item2.uid)),
    );
    final update1 = event3.data.singleWhere((i) => i.uid == item1.uid);
    expect(await update1.getMeta(), const ItemMetadata(name: 'updated'));
    expect(await update1.getContent(), testItemContent2);
    final update2 = event3.data.singleWhere((i) => i.uid == item2.uid);
    expect(update2.isDeleted, isTrue);

    // create from JS
    final jsItemId = await jsClientWrapper.executeForCollection<String>(
      Action.createItem(const ItemMetadata(name: 'js-item'), testItemContent1),
    );

    final event4 = await queue.next;
    expect(event4.isDone, isTrue);
    expect(event4.data, hasLength(1));
    final jsItem = event4.data.single;
    expect(jsItem.uid, jsItemId);
    expect(await jsItem.getMeta(), const ItemMetadata(name: 'js-item'));
    expect(await jsItem.getContent(), testItemContent1);

    // update from JS
    await jsClientWrapper.executeForCollection<void>(
      Action.updateItem(
        item1.uid,
        meta: const ItemMetadata(name: 'js-updated'),
      ),
    );

    final event5 = await queue.next;
    expect(event5.isDone, isTrue);
    expect(event5.data, hasLength(1));
    final jsUpdatedItem = event5.data.single;
    expect(jsUpdatedItem.uid, item1.uid);
    expect(
      await jsUpdatedItem.getMeta(),
      const ItemMetadata(name: 'js-updated'),
    );

    // ensure no further events are received
    final restSub = queue.rest.listen(
      (data) => fail('Did not expect any more events but got: $data'),
      cancelOnError: false,
    );
    expect(
      Future.delayed(const Duration(seconds: 3), restSub.cancel),
      completes,
    );
  });

  test(
    'uses deduplication on identical chunks and correctly restores them',
    timeout: const Timeout.factor(3),
    () async {
      final compressableContent = Uint8List.fromList(
        [
          List.filled(1 << 16, 0),
          List.filled(1 << 16, 0),
          List.filled(1 << 16, 1),
          List.filled(1 << 16, 1),
          List.filled(1 << 16, 0),
          List.filled(1 << 16, 1),
          List.filled(1 << 16, 0),
          List.filled(1 << 16, 1),
          List.filled(1 << 16, 0),
          List.filled(25, 1),
        ].expand((i) => i).toList(),
      );
      const totalChunks = 4; // <0s> + <1s> + <rest> + <indices>

      final uploadItem = await itemManager.create(
        const ItemMetadata(name: 'deduplicated'),
        compressableContent,
      );

      prefix = 'Uploading - ';
      await itemManager.uploadContent(
        uploadItem,
        onProgress: (current, total) {
          printProgress(current, total);
          expect(total, totalChunks); // would be much more without duplication
        },
      );
      await itemManager.batch([uploadItem]);

      final downloadItem = await itemManager.fetch(
        uploadItem.uid,
        const ItemFetchOptions(prefetch: PrefetchOption.medium),
      );

      prefix = 'Downloading - ';
      await itemManager.downloadContent(
        downloadItem,
        onProgress: (current, total) {
          printProgress(current, total);
          expect(total, totalChunks); // same number as uploads
        },
      );
      expect(downloadItem.isMissingContent, isFalse);
      expect(await downloadItem.getContent(), compressableContent);
    },
  );

  test('can handle custom metadata', () async {
    final customItem = await itemManager.create(
      const CustomMetadata(name: 'custom'),
      Uint8List(0),
    );
    await customItem.verify();
    await itemManager.batch([customItem]);

    final customMeta = await customItem.getMeta<CustomMetadata>();
    expect(customMeta, isA<CustomMetadata>());
    expect(customMeta.name, 'custom');
    expect(customMeta.confirmed, isFalse);

    await jsClientWrapper.executeForCollection<void>(
      Action.validateItem(customItem.uid, meta: customMeta),
    );

    await jsClientWrapper.executeForCollection<void>(
      Action.updateItem(
        customItem.uid,
        meta: customMeta.copyWith(confirmed: true),
      ),
    );

    final updatedItem = await itemManager.fetch(customItem.uid);
    await updatedItem.verify();

    final updatedMeta = await updatedItem.getMeta<CustomMetadata>();
    expect(updatedMeta, isA<CustomMetadata>());
    expect(updatedMeta.name, 'custom');
    expect(updatedMeta.confirmed, isTrue);
  });
}
