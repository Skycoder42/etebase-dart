@TestOn('!windows')
library collection_test;

import 'dart:convert';
import 'dart:typed_data';

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
import 'util/matchers.dart';

void main() {
  const testCollectionType = 'etebase-dart.collection_test';
  final collectionTestContent1 = Uint8List.fromList(
    List.generate(20, (index) => index + 10),
  );
  final collectionTestContent2 = Uint8List.fromList(List.filled(2000, 42));

  late final EtebaseCollectionManager collectionManager;

  setUpAll(() async {
    Etebase.ensureInitialized(loadLibEtebase);

    final client = await EtebaseClient.create('collection-test', serverUri);
    addTearDown(client.dispose);

    final account = await createAccount(client, 'collection-test-user');
    addTearDown(account.dispose);

    collectionManager = await account.getCollectionManager();
    addTearDown(collectionManager.dispose);
  });

  test('item metadata can be created and edited', () async {
    const testItemType = 'test.collection';
    const testName = 'test-name';
    const testDescription = 'multiline\ntest\ndescription';
    final testMTime = DateTime(2022, 10, 11, 12, 13, 15, 678);
    const testColor = '#AABBCC';

    final testCollection = await collectionManager.create(
      '$testCollectionType-meta',
      const EtebaseItemMetadata(),
      Uint8List(0),
    );

    final collectionMeta = await testCollection.getMeta();
    expect(collectionMeta.itemType, isNull);
    expect(collectionMeta.name, isNull);
    expect(collectionMeta.description, isNull);
    expect(collectionMeta.mtime, isNull);
    expect(collectionMeta.color, isNull);

    await testCollection.setMeta(
      collectionMeta.copyWith(
        itemType: testItemType,
        name: testName,
        description: testDescription,
        mtime: testMTime,
        color: testColor,
      ),
    );

    final collectionMeta2 = await testCollection.getMeta();
    expect(collectionMeta2.itemType, testItemType);
    expect(collectionMeta2.name, testName);
    expect(collectionMeta2.description, testDescription);
    expect(collectionMeta2.mtime, testMTime);
    expect(collectionMeta2.color, testColor);

    await testCollection.setMeta(const EtebaseItemMetadata());

    final collectionMeta3 = await testCollection.getMeta();
    expect(collectionMeta3.itemType, isNull);
    expect(collectionMeta3.name, isNull);
    expect(collectionMeta3.description, isNull);
    expect(collectionMeta3.mtime, isNull);
    expect(collectionMeta3.color, isNull);
  });

  test('fetch options can be created', () async {
    const options = EtebaseFetchOptions(
      iterator: 'iterator',
      limit: 100,
      prefetch: EtebasePrefetchOption.optionMedium,
      stoken: 'stoken',
      withCollection: true,
    );

    expect(
      () => collectionManager.list('$testCollectionType-fetch', options),
      throwsEtebaseException(EtebaseErrorCode.http),
    );
  });

  group('collections', () {
    test('can create collection', () async {
      const testCollectionName = 'test-name';

      final collection = await collectionManager.create(
        testCollectionType,
        const EtebaseItemMetadata(name: testCollectionName),
        collectionTestContent1,
      );
      addTearDown(collection.dispose);

      expect(await collection.verify(), isTrue);
      expect(await collection.isDeleted(), isFalse);

      expect(
        await collection.getAccessLevel(),
        EtebaseCollectionAccessLevel.admin,
      );
      expect(await collection.getCollectionType(), testCollectionType);
      expect(await collection.getEtag(), isNotEmpty);
      expect(await collection.getStoken(), isNull);
      expect(await collection.getUid(), isNotEmpty);
      expect(await collection.getContent(), collectionTestContent1);
      expect(
        await collection.getContent(collectionTestContent1.length - 10),
        collectionTestContent1,
      );
      expect(
        await collection.getContent(collectionTestContent1.length),
        collectionTestContent1,
      );
      expect(
        await collection.getContent(collectionTestContent1.length + 10),
        collectionTestContent1,
      );

      final loadedMeta = await collection.getMeta();
      expect(loadedMeta.name, testCollectionName);
      expect(loadedMeta.mtime, isNull);

      final asItem = await collection.asItem();
      addTearDown(asItem.dispose);
      expect(await asItem.getUid(), await collection.getUid());

      final cloned = await collection.clone();
      addTearDown(cloned.dispose);
      expect(await cloned.getUid(), await collection.getUid());
    });

    test('can be updated and deleted', () async {
      const testCollectionName = 'test-name';

      final collection = await collectionManager.create(
        testCollectionType,
        const EtebaseItemMetadata(name: testCollectionName),
        collectionTestContent1,
      );
      addTearDown(collection.dispose);

      final loadedMeta = await collection.getMeta();
      await collection.setContent(collectionTestContent2);
      await collection.setMeta(
        loadedMeta.copyWith(
          mtime: DateTime.now(),
        ),
      );

      await collection.delete();
    });
  });

  group('collection manager', () {
    late String colId1;
    late String colId2;
    late String colId3;

    test('can create and upload collections', () async {
      final collection1 = await collectionManager.create(
        testCollectionType,
        const EtebaseItemMetadata(name: 'create-collection-test-1'),
        collectionTestContent1,
      );
      addTearDown(collection1.dispose);
      colId1 = await collection1.getUid();
      await collectionManager.upload(collection1);

      final collection2 = await collectionManager.create(
        testCollectionType,
        EtebaseItemMetadata(
          name: 'create-collection-test-2',
          mtime: DateTime(2000),
        ),
        collectionTestContent2,
      );
      addTearDown(collection2.dispose);
      colId2 = await collection2.getUid();
      await collectionManager.upload(collection2);

      final collection3 = await collectionManager.create(
        '$testCollectionType-other',
        const EtebaseItemMetadata(),
        Uint8List(0),
      );
      addTearDown(collection3.dispose);
      colId3 = await collection3.getUid();
      await collectionManager.upload(collection3);
    });

    test('can list collections', () async {
      final listResponse = await collectionManager.list(testCollectionType);
      addTearDown(listResponse.dispose);

      expect(await listResponse.isDone(), isTrue);
      expect(await listResponse.getStoken(), allOf(isNotNull, isNotEmpty));
      expect(await listResponse.getRemovedMemberships(), isEmpty);

      final collections = await listResponse.getData();
      expect(collections, hasLength(2));

      final collection1 = collections[0];
      expect(await collection1.getCollectionType(), testCollectionType);
      expect(await collection1.getUid(), colId1);
      final meta1 = await collection1.getMeta();
      expect(meta1.name, 'create-collection-test-1');

      final collection2 = collections[1];
      expect(await collection2.getCollectionType(), testCollectionType);
      expect(await collection2.getUid(), colId2);
      final meta2 = await collection2.getMeta();
      expect(meta2.name, 'create-collection-test-2');

      final changedResponse = await collectionManager.list(
        testCollectionType,
        EtebaseFetchOptions(
          stoken: await listResponse.getStoken(),
        ),
      );
      addTearDown(changedResponse.dispose);

      expect(await changedResponse.getData(), isEmpty);
    });

    test('can list multiple collections', () async {
      final listResponse = await collectionManager.listMulti(
        const [testCollectionType, '$testCollectionType-other'],
      );
      addTearDown(listResponse.dispose);

      expect(await listResponse.isDone(), isTrue);
      expect(await listResponse.getStoken(), isNotEmpty);
      expect(await listResponse.getRemovedMemberships(), isEmpty);
      expect(await listResponse.getData(), hasLength(3));
    });

    test('can update collection in transaction', () async {
      expect(
        () => collectionManager.fetch('invalid-id'),
        throwsEtebaseException(EtebaseErrorCode.notFound),
      );

      final collection1 = await collectionManager.fetch(colId1);
      addTearDown(collection1.dispose);
      final collection2 = await collectionManager.fetch(colId1);
      addTearDown(collection2.dispose);

      await collection1.setContent(
        Uint8List.fromList(utf8.encode('updated content')),
      );

      await collectionManager.transaction(collection1);

      await collection2.setContent(Uint8List(0));

      expect(
        () => collectionManager.transaction(collection2),
        throwsEtebaseException(EtebaseErrorCode.conflict),
      );
    });

    test('can upload deleted collection', () async {
      final collection = await collectionManager.fetch(colId3);
      addTearDown(collection.dispose);

      final meta = await collection.getMeta();

      await collection.setMeta(
        meta.copyWith(
          mtime: DateTime.now(),
          description: '--deleted--',
        ),
      );
      await collection.setContent(collectionTestContent1);
      await collection.delete();
      expect(await collection.isDeleted(), isTrue);

      await collectionManager.upload(collection);

      final deletedCollection = await collectionManager.fetch(colId3);
      addTearDown(deletedCollection.dispose);
      expect(await deletedCollection.isDeleted(), isTrue);
    });

    test('can save and restore collection from and to cache', () async {
      final collection = await collectionManager.fetch(colId2);
      addTearDown(collection.dispose);

      final saved = await collectionManager.cacheSave(collection);
      final restored = await collectionManager.cacheLoad(saved);
      addTearDown(restored.dispose);

      expect(await restored.getUid(), colId2);
      expect(await restored.getContent(), collectionTestContent2);
      final meta = await restored.getMeta();
      expect(meta.name, 'create-collection-test-2');

      final savedWithContent = await collectionManager.cacheSaveWithContent(
        collection,
      );
      final restoredWithContent = await collectionManager.cacheLoad(
        savedWithContent,
      );
      addTearDown(restoredWithContent.dispose);

      expect(await restoredWithContent.getUid(), colId2);
      expect(await restoredWithContent.getContent(), collectionTestContent2);
      final metaWithContent = await restoredWithContent.getMeta();
      expect(metaWithContent.name, 'create-collection-test-2');
    });
  });
}
