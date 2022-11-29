// ignore_for_file: avoid_print

import 'dart:ffi';
import 'dart:io';

import 'package:etebase/gen/ffi/libetebase.ffi.client.dart';
import 'package:etebase/src/etebase_init.dart';

Future<void> main() async {
  print('Initializing etebase');
  await Etebase.ensureInitialized(_loadLibEtebase);
  print('Etebase was initialized!');

  final serverUrl = await etebaseGetDefaultServerUrl();
  print('Server-URL: $serverUrl');
  final client = await EtebaseClient.create(
    'example-client',
    // serverUrl,
    Uri.http('localhost:3735', '/'),
  );
  print('Client is valid: ${await client.checkEtebaseServer()}');

  final user = await EtebaseUser.create('test', 'test@example.org');
  print(await user.getUsername());
  print(await user.getEmail());

  final account = await EtebaseAccount.signup(client, user, 'hello-test-123');
  print(await account.save());

  await account.dispose();
  await user.dispose();
  await client.dispose();
  print('Client disposed');

  Etebase.terminate();
  print('Isolate terminated');
}

DynamicLibrary _loadLibEtebase() => DynamicLibrary.open(
      Platform.isLinux
          ? '/usr/lib/libetebase.so.0'
          : '/Library/Repos/other/rust/libetebase/target/release/libetebase.dylib',
    );
