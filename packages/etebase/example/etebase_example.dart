// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:etebase/etebase.dart';

import '../test/integration/util/library_loader.dart';

Future<void> main() async {
  print('Initializing etebase...');
  Etebase.ensureInitialized(loadLibEtebase);
  print('Etebase was initialized!');

  final client = await EtebaseClient.create(
    'example-client',
    // serverUrl (optional)
    Uri.http('localhost:3735', '/'),
  );
  try {
    print('Client is valid: ${await client.checkEtebaseServer()}');

    final account = await EtebaseAccount.signup(
      client,
      const EtebaseUser(
        username: 'test',
        email: 'test@example.org',
      ),
      'hello-test-123',
    );

    final collectionManager = await account.getCollectionManager();
    final collection = await collectionManager.create(
      'example',
      EtebaseItemMetadata(
        name: 'Example collection',
        description: 'An example collection for testing out etebase-dart',
        mtime: DateTime.now(),
      ),
      Uint8List.fromList(utf8.encode('Hello, World!')),
    );
    await collectionManager.upload(collection);
  } finally {
    await client.dispose();
  }
}
