@TestOn('!windows')
library item_test;

import 'dart:typed_data';

// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
import 'util/server_controller.dart';

void main() {
  const testCollectionType = 'etebase-dart.item_test';
  final testItemContent = Uint8List.fromList(
    List.generate(20, (index) => index + 10),
  );

  late final Uri serverUri;
  late final EtebaseItemManager itemManager;

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

      final item = await itemManager.create(meta, testItemContent);
      addTearDown(item.dispose);

      expect(await item.verify(), isTrue);
      expect(await item.isDeleted(), isFalse);

      expect(await item.getEtag(), isNotEmpty);
      expect(await item.getUid(), isNotEmpty);
      expect(await item.getContent(), testItemContent);
      expect(
        await item.getContent(testItemContent.length - 10),
        testItemContent,
      );
      expect(
        await item.getContent(testItemContent.length),
        testItemContent,
      );
      expect(
        await item.getContent(testItemContent.length + 10),
        testItemContent,
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
      final item = await itemManager.create(meta, testItemContent);
      addTearDown(item.dispose);

      final loadedMeta = await item.getMeta();
      addTearDown(loadedMeta.dispose);
      await loadedMeta.setMtime(DateTime.now());
      await item.setContent(Uint8List(0));
      await item.setMeta(loadedMeta);

      await item.delete();
    });
  });

  group('item manager', () {});
}
