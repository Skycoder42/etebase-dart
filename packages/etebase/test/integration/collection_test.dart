import 'dart:typed_data';

// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
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

  test('can create and edit item metadata', () async {
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
    await collectionManager.upload(collection2);

    final meta3 = await EtebaseItemMetadata.create();
    addTearDown(meta3.dispose);
    final collection3 = await collectionManager.create(
      '$testCollectionType-other',
      meta3,
      Uint8List(0),
    );
    addTearDown(collection3.dispose);
    await collectionManager.upload(collection3);
  });

  test('can list and fetch collection', () async {
    final listResponse = await collectionManager.list(testCollectionType);
    addTearDown(listResponse.dispose);

    expect(await listResponse.isDone(), isTrue);
    expect(await listResponse.getStoken(), isNotEmpty);
    expect(await listResponse.getRemovedMemberships(), isEmpty);

    final collections = await listResponse.getData();
    expect(collections, hasLength(2));

    final collection1 = collections[0];
    expect(await collection1.getCollectionType(), testCollectionType);
    expect(
      await collection1.getAccessLevel(),
      EtebaseCollectionAccessLevel.admin,
    );
    expect(await collection1.getContent(), collectionTestContent1);
    expect(
      await collection1.getContent(collectionTestContent1.length),
      collectionTestContent1,
    );
    expect(await collection1.getEtag(), isNotEmpty);
    expect(await collection1.getStoken(), isNotEmpty);
    expect(await collection1.getUid(), isNotEmpty);
    final meta1 = await collection1.getMeta();
    addTearDown(meta1.dispose);
    expect(await meta1.getName(), 'create-collection-test-1');
    expect(await meta1.getDescription(), isNull);

    final collection2 = collections[1];
    expect(await collection2.getCollectionType(), testCollectionType);
    expect(await collection2.getContent(), collectionTestContent2);
    expect(
      await collection2.getContent(collectionTestContent2.length),
      collectionTestContent2,
    );
    final meta2 = await collection2.getMeta();
    addTearDown(meta2.dispose);
    expect(await meta2.getName(), 'create-collection-test-2');
    expect(await meta2.getMtime(), DateTime(2000));
  });
}
