// ignore_for_file: discarded_futures

@TestOn('!windows')
library;

import 'dart:convert';
import 'dart:typed_data';

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/custom_metadata.dart';
import 'util/js_client_wrapper.dart';
import 'util/library_loader.dart';
import 'util/test_helpers.dart';

void main() {
  const testCollectionType = 'etebase-dart.collection_test';
  final collectionTestContent1 = Uint8List.fromList(
    List.generate(20, (index) => index + 10),
  );
  final collectionTestContent2 = Uint8List.fromList(List.filled(2000, 42));

  final jsClientWrapper = JsClientWrapper();
  late final EtebaseCollectionManager collectionManager;

  setUpAll(() async {
    final client = await createClient();
    client.registerCustomMetadata(CustomMetadata.fromJson);
    addTearDown(client.dispose);

    final account = await createAccount(
      client,
      'collection-test-user',
      jsClientWrapper,
    );
    addTearDown(account.dispose);

    collectionManager = account.collectionManager;
  });

  test('item metadata can be created and edited', () async {
    const testItemType = 'test.collection';
    const testName = 'test-name';
    const testDescription = 'multiline\ntest\ndescription';
    final testMTime = DateTime.utc(2022, 10, 11, 12, 13, 15, 678);
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

  test('fetch options can be created', () {
    const options = EtebaseFetchOptions(
      limit: 100,
      prefetch: EtebasePrefetchOption.medium,
      stoken: 'stoken',
    );

    expect(
      () => collectionManager.list('$testCollectionType-fetch', options),
      throwsA(isA<HttpFailure>()),
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

      expect(collection.verify(), completes);

      expect(collection.accessLevel, EtebaseCollectionAccessLevel.admin);
      expect(collection.collectionType, testCollectionType);
      expect(collection.etag, isNotEmpty);
      expect(collection.stoken, isNull);
      expect(collection.uid, isNotEmpty);
      expect(collection.isDeleted, isFalse);
      expect(await collection.getContent(), collectionTestContent1);

      final loadedMeta = await collection.getMeta();
      expect(loadedMeta.name, testCollectionName);
      expect(loadedMeta.mtime, isNull);
    });

    test('can be updated', () async {
      const testCollectionName = 'test-name';
      final testNow = DateTime.now();

      final collection = await collectionManager.create(
        testCollectionType,
        const EtebaseItemMetadata(name: testCollectionName),
        collectionTestContent1,
      );
      addTearDown(collection.dispose);

      final updatedMeta = await collection.getMeta();
      await collection.setContent(collectionTestContent2);
      await collection.setMeta(updatedMeta.copyWith(mtime: testNow));

      expect(collection.verify(), completes);
      expect(await collection.getContent(), collectionTestContent2);

      final loadedMeta = await collection.getMeta();
      expect(loadedMeta.name, testCollectionName);
      expect(loadedMeta.mtime, dtEquals(testNow));
    });

    test('can be deleted', () async {
      const testCollectionName = 'test-name';

      final collection = await collectionManager.create(
        testCollectionType,
        const EtebaseItemMetadata(name: testCollectionName),
        collectionTestContent1,
      );
      addTearDown(collection.dispose);

      await collection.delete();

      expect(collection.verify(), completes);
      expect(collection.isDeleted, isTrue);
      expect(await collection.getContent(), isEmpty);

      final loadedMeta = await collection.getMeta();
      expect(loadedMeta.name, testCollectionName);
    });
  });

  group('collection manager', () {
    late String colId1;
    late String colId2;
    late String colId3;
    late String colId4; // from JS

    test('can create and upload collections', () async {
      final collection1 = await collectionManager.create(
        testCollectionType,
        const EtebaseItemMetadata(name: 'create-collection-test-1'),
        collectionTestContent1,
      );
      addTearDown(collection1.dispose);
      colId1 = collection1.uid;
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
      colId2 = collection2.uid;
      await collectionManager.upload(collection2);

      final collection3 = await collectionManager.create(
        '$testCollectionType-other',
        const EtebaseItemMetadata(),
        Uint8List(0),
      );
      addTearDown(collection3.dispose);
      colId3 = collection3.uid;
      await collectionManager.upload(collection3);

      // validate collections exits in JS
      final jsColIds = await jsClientWrapper.executeSignedIn<List<String>>(
        const Action.listCollections([
          testCollectionType,
          '$testCollectionType-other',
        ]),
      );
      expect(jsColIds, [colId1, colId2, colId3]);

      await jsClientWrapper.executeSignedIn<void>(
        Action.validateCollection(
          colId1,
          meta: await collection1.getMeta(),
          content: collectionTestContent1,
          isDeleted: false,
        ),
      );
      await jsClientWrapper.executeSignedIn<void>(
        Action.validateCollection(
          colId2,
          meta: await collection2.getMeta(),
          content: collectionTestContent2,
          isDeleted: false,
        ),
      );
      await jsClientWrapper.executeSignedIn<void>(
        Action.validateCollection(
          colId3,
          meta: await collection3.getMeta(),
          content: Uint8List(0),
          isDeleted: false,
        ),
      );
    });

    test('can list collections', () async {
      // create a fourth via JS
      colId4 = await jsClientWrapper.executeSignedIn<String>(
        Action.createCollection(
          testCollectionType,
          const EtebaseItemMetadata(name: 'js-collection'),
          collectionTestContent1,
        ),
      );

      final listResponse = await collectionManager.list(testCollectionType);

      expect(listResponse.isDone, isTrue);
      expect(listResponse.stoken, allOf(isNotNull, isNotEmpty));
      expect(listResponse.removedMemberships, isNull);

      final collections = listResponse.data;
      expect(collections, hasLength(3));

      final collection1 = collections[0];
      expect(collection1.collectionType, testCollectionType);
      expect(collection1.uid, colId1);
      final meta1 = await collection1.getMeta();
      expect(meta1.name, 'create-collection-test-1');

      final collection2 = collections[1];
      expect(collection2.collectionType, testCollectionType);
      expect(collection2.uid, colId2);
      final meta2 = await collection2.getMeta();
      expect(meta2.name, 'create-collection-test-2');

      final collection3 = collections[2];
      expect(collection3.collectionType, testCollectionType);
      expect(collection3.uid, colId4);
      final meta3 = await collection3.getMeta();
      expect(meta3.name, 'js-collection');

      final changedResponse = await collectionManager.list(
        testCollectionType,
        EtebaseFetchOptions(stoken: listResponse.stoken),
      );

      expect(changedResponse.data, isEmpty);
    });

    test('can list multiple collections', () async {
      final listResponse = await collectionManager.listMulti(const [
        testCollectionType,
        '$testCollectionType-other',
      ]);

      expect(listResponse.isDone, isTrue);
      expect(listResponse.stoken, allOf(isNotNull, isNotEmpty));
      expect(listResponse.removedMemberships, isNull);
      expect(listResponse.data, hasLength(4));
    });

    test('can update collection in transaction', () async {
      expect(
        () => collectionManager.fetch('invalid-id'),
        throwsA(isA<NotFound>()),
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
        throwsA(isA<Conflict>()),
      );

      await jsClientWrapper.executeSignedIn<void>(
        Action.validateCollection(
          colId1,
          meta: await collection1.getMeta(),
          content: Uint8List.fromList(utf8.encode('updated content')),
          isDeleted: false,
        ),
      );

      // now update in js and try the same thing
      await jsClientWrapper.executeSignedIn<void>(
        Action.updateCollection(
          colId1,
          meta: (await collection1.getMeta()).copyWith(color: '#123456'),
        ),
      );

      await collection1.setContent(Uint8List(0));

      expect(
        () => collectionManager.transaction(collection1),
        throwsA(isA<Conflict>()),
      );
    });

    test('can upload deleted collection', () async {
      final collection = await collectionManager.fetch(colId3);
      addTearDown(collection.dispose);

      final meta = await collection.getMeta();

      await collection.setMeta(
        meta.copyWith(mtime: DateTime.now(), description: '--deleted--'),
      );
      await collection.setContent(collectionTestContent1);
      await collection.delete();
      expect(collection.isDeleted, isTrue);

      await collectionManager.upload(collection);

      final deletedCollection = await collectionManager.fetch(colId3);
      addTearDown(deletedCollection.dispose);
      expect(deletedCollection.isDeleted, isTrue);
      expect(deletedCollection.getContent(), completion(isEmpty));

      await jsClientWrapper.executeSignedIn<void>(
        Action.validateCollection(
          colId3,
          meta: await collection.getMeta(),
          content: Uint8List(0),
          isDeleted: true,
        ),
      );

      // now delete from js
      await jsClientWrapper.executeSignedIn<void>(
        Action.updateCollection(colId1, delete: true),
      );

      final jsDeletedCol = await collectionManager.fetch(colId1);
      addTearDown(jsDeletedCol.dispose);
      expect(jsDeletedCol.isDeleted, isTrue);
      expect(jsDeletedCol.getContent(), completion(isEmpty));
    });

    test('can preserve content of deleted collections', () async {
      final delTest1 = await collectionManager.create(
        testCollectionType,
        const EtebaseItemMetadata(),
        collectionTestContent1,
      );
      final delTest2 = await collectionManager.create(
        testCollectionType,
        const EtebaseItemMetadata(),
        collectionTestContent2,
      );

      await collectionManager.upload(delTest1);
      await collectionManager.upload(delTest2);

      // delete first from dart
      await delTest1.delete(preserveContent: true);
      await collectionManager.upload(delTest1);

      expect(delTest1.getContent(), completion(collectionTestContent1));
      await jsClientWrapper.executeSignedIn<void>(
        Action.validateCollection(
          delTest1.uid,
          content: collectionTestContent1,
          isDeleted: true,
        ),
      );

      // delete from js
      await jsClientWrapper.executeSignedIn<void>(
        Action.updateCollection(
          delTest2.uid,
          delete: true,
          preserveContent: true,
        ),
      );

      final updatedTest2 = await collectionManager.fetch(delTest2.uid);
      expect(updatedTest2.getContent(), completion(collectionTestContent2));
    });

    test('can save and restore collection from and to cache', () async {
      final collection = await collectionManager.fetch(colId2);
      addTearDown(collection.dispose);

      final saved = collectionManager.cacheSave(collection);
      final restored = collectionManager.cacheLoad(saved);
      addTearDown(restored.dispose);

      expect(restored.uid, colId2);
      expect(restored.isMissingContent, isFalse);
      expect(await restored.getContent(), collectionTestContent2);
      final meta = await restored.getMeta();
      expect(meta.name, 'create-collection-test-2');

      final savedWithoutContent = collectionManager.cacheSave(
        collection,
        saveContent: false,
      );
      final restoredWithoutContent = collectionManager.cacheLoad(
        savedWithoutContent,
      );
      addTearDown(restoredWithoutContent.dispose);

      expect(restoredWithoutContent.uid, colId2);
      expect(restoredWithoutContent.isMissingContent, isTrue);
      final metaWithoutContent = await restoredWithoutContent.getMeta();
      expect(metaWithoutContent.name, 'create-collection-test-2');
      expect(restoredWithoutContent.getContent, throwsA(isA<MissingContent>()));
    });

    test('can handle custom metadata', () async {
      final customCol = await collectionManager.create(
        testCollectionType,
        const CustomMetadata(name: 'custom'),
        Uint8List(0),
      );
      await customCol.verify();
      await collectionManager.upload(customCol);

      final customMeta = await customCol.getMeta<CustomMetadata>();
      expect(customMeta, isA<CustomMetadata>());
      expect(customMeta.name, 'custom');
      expect(customMeta.confirmed, isFalse);

      await jsClientWrapper.executeSignedIn<void>(
        Action.validateCollection(customCol.uid, meta: customMeta),
      );

      await jsClientWrapper.executeSignedIn<void>(
        Action.updateCollection(
          customCol.uid,
          meta: customMeta.copyWith(confirmed: true),
        ),
      );

      final updatedCol = await collectionManager.fetch(customCol.uid);
      await updatedCol.verify();

      final updatedMeta = await updatedCol.getMeta<CustomMetadata>();
      expect(updatedMeta, isA<CustomMetadata>());
      expect(updatedMeta.name, 'custom');
      expect(updatedMeta.confirmed, isTrue);
    });

    test('can save and restore collection from different client', () async {
      final collection = await collectionManager.fetch(colId4);
      addTearDown(collection.dispose);

      final savedDart = collectionManager.cacheSave(collection);

      await jsClientWrapper.executeSignedIn<void>(
        Action.restoreCollection(
          savedDart,
          meta: const EtebaseItemMetadata(name: 'js-collection'),
          content: collectionTestContent1,
          isDeleted: false,
        ),
      );

      final savedJs = await jsClientWrapper.executeSignedIn<Uint8List>(
        Action.saveCollection(colId2),
      );
      final restored = collectionManager.cacheLoad(savedJs);
      addTearDown(restored.dispose);

      expect(restored.uid, colId2);
      expect(restored.isMissingContent, isFalse);
      expect(await restored.getContent(), collectionTestContent2);
      final meta = await restored.getMeta();
      expect(meta.name, 'create-collection-test-2');

      final savedWithoutContentDart = collectionManager.cacheSave(
        collection,
        saveContent: false,
      );

      await jsClientWrapper.executeSignedIn<void>(
        Action.restoreCollection(
          savedWithoutContentDart,
          meta: const EtebaseItemMetadata(name: 'js-collection'),
          noContent: true,
          isDeleted: false,
        ),
      );

      final savedWithoutContentJs = await jsClientWrapper
          .executeSignedIn<Uint8List>(
            Action.saveCollection(colId2, preserveContent: false),
          );
      final restoredWithoutContent = collectionManager.cacheLoad(
        savedWithoutContentJs,
      );
      addTearDown(restoredWithoutContent.dispose);

      expect(restoredWithoutContent.uid, colId2);
      expect(restoredWithoutContent.isMissingContent, isTrue);
      final metaWithoutContent = await restoredWithoutContent.getMeta();
      expect(metaWithoutContent.name, 'create-collection-test-2');
      expect(restoredWithoutContent.getContent, throwsA(isA<MissingContent>()));
    });
  });
}
