// ignore_for_file: avoid_print

import 'package:etebase/etebase.dart';

import '../test/integration/util/library_loader.dart';

Future<void> main() async {
  print('Initializing etebase');
  Etebase.ensureInitialized(loadLibEtebase);
  print('Etebase was initialized!');

  final client = await EtebaseClient.create(
    'example-client',
    // serverUrl,
    Uri.http('localhost:3735', '/'),
  );
  try {
    print('Client is valid: ${await client.checkEtebaseServer()}');

    final serverUrl = await etebaseGetDefaultServerUrl();
    print('Server-URL: $serverUrl');

    final account = await EtebaseAccount.signup(
      client,
      const EtebaseUser(
        username: 'test',
        email: 'test@example.org',
      ),
      'hello-test-123',
    );
    print(await account.save());
  } finally {
    await client.dispose();
  }
}
