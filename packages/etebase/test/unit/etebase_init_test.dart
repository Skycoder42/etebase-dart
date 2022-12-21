// ignore_for_file: unnecessary_lambdas

import 'dart:ffi';

import 'package:etebase/src/etebase_init.dart';
import 'package:etebase/src/isolate/etebase_isolate_error.dart';
import 'package:etebase/src/isolate/etebase_isolate_reference.dart';
import 'package:etebase/src/model/etebase_config.dart';
import 'package:test/test.dart';

DynamicLibrary testLoadLibetebase() => DynamicLibrary.executable();

void main() {
  group('$Etebase', () {
    test('can configure isolate reference', () async {
      await expectLater(
        () => EtebaseIsolateReference.create(),
        throwsA(isA<EtebaseIsolateError>()),
      );

      Etebase.ensureInitialized(
        testLoadLibetebase,
        config: const EtebaseConfig(defaultContentBufferSize: 2048),
        logLevel: 1000,
      );

      final ref = await EtebaseIsolateReference.create();
      await ref.dispose();
    });
  });
}
