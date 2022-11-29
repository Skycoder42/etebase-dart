// ignore_for_file: avoid_print

import 'dart:ffi';
import 'dart:io';

import 'package:etebase/gen/ffi/libetebase.ffi.client.dart';
import 'package:etebase/src/etebase_init.dart';

Future<void> main() async {
  var ctr = 0;
  while (true) {
    print('### ${ctr++}');
    await _main();
  }
}

Future<void> _main() async {
  print('Initializing etebase');
  await Etebase.ensureInitialized(_loadLibEtebase);
  print('Etebase was initialized!');

  final serverUrl = await etebaseGetDefaultServerUrl();
  print('Server-URL: $serverUrl');
  final client = await EtebaseClient.create(
    'example-client',
    serverUrl,
  );
  print('Client is valid: ${await client.checkEtebaseServer()}');

  await Future<void>.delayed(const Duration(seconds: 10));

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
