// ignore_for_file: avoid_print

import 'package:etebase/src/etebase_init.dart';
import 'package:etebase/src/gen/ffi/libetebase.ffi.client.dart';

import '../test/integration/util/library_loader.dart';

Future<void> main() async {
  try {
    print('Initializing etebase');
    await Etebase.ensureInitialized(loadLibEtebase);
    print('Etebase was initialized!');

    final serverUrl = await etebaseGetDefaultServerUrl();

    print('Server-URL: $serverUrl');
    final client = await EtebaseClient.create(
      'example-client',
      // serverUrl,
      Uri.http('localhost:3735', '/'),
    );
    print('Client is valid: ${await client.checkEtebaseServer()}');

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
    await Etebase.terminate();
    print('Isolate terminated');
  }
}
