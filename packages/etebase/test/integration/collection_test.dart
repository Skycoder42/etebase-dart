import 'dart:convert';
import 'dart:typed_data';

// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
import 'util/matchers.dart';
import 'util/server_controller.dart';

void main() {
  const testCollectionType = 'etebase-dart.collection_test';
  final collectionTestContent1 = Uint8List.fromList(
    List.generate(20, (index) => index + 10),
  );
  final collectionTestContent2 = Uint8List.fromList(List.filled(2000, 42));

  late final Uri serverUri;
  late final EtebaseCollectionManager collectionManager;

  setUpAll(() async {
    await Etebase.ensureInitialized(loadLibEtebase);
    serverUri = await ServerController().start();

    final client = await EtebaseClient.create('collection-test', serverUri);
    addTearDown(client.dispose);

    final user = await EtebaseUser.create(
      'collection-test-user',
      'collection@test.com',
    );
    final account = await EtebaseAccount.signup(client, user, 'password');
    addTearDown(account.dispose);
    await user.dispose();

    collectionManager = await account.getCollectionManager();
    addTearDown(collectionManager.dispose);
  });

  test('item metadata can be created and edited', () async {
    const testItemType = 'test.collection';
    const testName = 'test-name';
    const testDescription = 'multiline\ntest\ndescription';
    final testMTime = DateTime(2022, 10, 11, 12, 13, 15, 678);
    const testColor = '#AABBCC';

    final collectionMeta = await EtebaseItemMetadata.create();
    addTearDown(collectionMeta.dispose);

    expect(await collectionMeta.getItemType(), isNull);
    expect(await collectionMeta.getName(), isNull);
    expect(await collectionMeta.getDescription(), isNull);
    expect(await collectionMeta.getMtime(), isNull);
    expect(await collectionMeta.getColor(), isNull);

    await collectionMeta.setItemType(testItemType);
    await collectionMeta.setName(testName);
    await collectionMeta.setDescription(testDescription);
    await collectionMeta.setMtime(testMTime);
    await collectionMeta.setColor(testColor);

    expect(await collectionMeta.getItemType(), testItemType);
    expect(await collectionMeta.getName(), testName);
    expect(await collectionMeta.getDescription(), testDescription);
    expect(await collectionMeta.getMtime(), testMTime);
    expect(await collectionMeta.getColor(), testColor);

    await collectionMeta.setItemType(null);
    await collectionMeta.setName(null);
    await collectionMeta.setDescription(null);
    await collectionMeta.setMtime(null);
    await collectionMeta.setColor(null);

    expect(await collectionMeta.getItemType(), isNull);
    expect(await collectionMeta.getName(), isNull);
    expect(await collectionMeta.getDescription(), isNull);
    expect(await collectionMeta.getMtime(), isNull);
    expect(await collectionMeta.getColor(), isNull);
  });

  test('fetch options can be created', () async {
    final options = await EtebaseFetchOptions.create();
    addTearDown(options.dispose);

    await options.setIterator('iterator');
    await options.setIterator(null);
    await options.setLimit(100);
    await options.setPrefetch(EtebasePrefetchOption.optionMedium);
    await options.setStoken('stoken');
    await options.setStoken(null);
    await options.setWithCollection(true);
  });

  group('collections', () {
    test('can create collection', () async {
      const testCollectionName = 'test-name';

      final meta = await EtebaseItemMetadata.create();
      addTearDown(meta.dispose);
      await meta.setName(testCollectionName);
      final collection = await collectionManager.create(
        testCollectionType,
        meta,
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
      addTearDown(loadedMeta.dispose);
      expect(await loadedMeta.getName(), testCollectionName);
      expect(await loadedMeta.getMtime(), isNull);

      final asItem = await collection.asItem();
      addTearDown(asItem.dispose);
      expect(await asItem.getUid(), await collection.getUid());

      final cloned = await collection.clone();
      addTearDown(cloned.dispose);
      expect(await cloned.getUid(), await collection.getUid());
    });

    test('can be updated and deleted', () async {
      const testCollectionName = 'test-name';

      final meta = await EtebaseItemMetadata.create();
      addTearDown(meta.dispose);
      await meta.setName(testCollectionName);
      final collection = await collectionManager.create(
        testCollectionType,
        meta,
        collectionTestContent1,
      );
      addTearDown(collection.dispose);

      final loadedMeta = await collection.getMeta();
      addTearDown(loadedMeta.dispose);
      await loadedMeta.setMtime(DateTime.now());
      await collection.setContent(collectionTestContent2);
      await collection.setMeta(loadedMeta);

      await collection.delete();
    });
  });

  group('collection manager', () {
    late String colId1;
    late String colId2;
    late String colId3;

    test('can create and upload collections', () async {
      final meta1 = await EtebaseItemMetadata.create();
      addTearDown(meta1.dispose);
      await meta1.setName('create-collection-test-1');
      final collection1 = await collectionManager.create(
        testCollectionType,
        meta1,
        collectionTestContent1,
      );
      addTearDown(collection1.dispose);
      colId1 = await collection1.getUid();
      await collectionManager.upload(collection1);

      final meta2 = await EtebaseItemMetadata.create();
      addTearDown(meta2.dispose);
      await meta2.setName('create-collection-test-2');
      await meta2.setMtime(DateTime(2000));
      final collection2 = await collectionManager.create(
        testCollectionType,
        meta2,
        collectionTestContent2,
      );
      addTearDown(collection2.dispose);
      colId2 = await collection2.getUid();
      await collectionManager.upload(collection2);

      final meta3 = await EtebaseItemMetadata.create();
      addTearDown(meta3.dispose);
      final collection3 = await collectionManager.create(
        '$testCollectionType-other',
        meta3,
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
      expect(await listResponse.getRemovedMemberships(), allOf(isEmpty));

      final collections = await listResponse.getData();
      expect(collections, hasLength(2));

      final collection1 = collections[0];
      expect(await collection1.getCollectionType(), testCollectionType);
      expect(await collection1.getUid(), colId1);
      final meta1 = await collection1.getMeta();
      addTearDown(meta1.dispose);
      expect(await meta1.getName(), 'create-collection-test-1');

      final collection2 = collections[1];
      expect(await collection2.getCollectionType(), testCollectionType);
      expect(await collection2.getUid(), colId2);
      final meta2 = await collection2.getMeta();
      addTearDown(meta2.dispose);
      expect(await meta2.getName(), 'create-collection-test-2');
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
      addTearDown(meta.dispose);

      await meta.setMtime(DateTime.now());
      await meta.setDescription('--deleted--');
      await collection.setMeta(meta);
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
      addTearDown(meta.dispose);
      expect(await meta.getName(), 'create-collection-test-2');

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
      addTearDown(metaWithContent.dispose);
      expect(await metaWithContent.getName(), 'create-collection-test-2');
    });
  });
}
