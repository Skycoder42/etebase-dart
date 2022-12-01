// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
import 'util/server_controller.dart';

void main() {
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
}
