import 'dart:ffi';

import 'package:etebase/src/etebase_init.dart';
import 'package:etebase/src/isolate/etebase_isolate.dart';
import 'package:etebase/src/model/etebase_config.dart';
import 'package:test/test.dart';

DynamicLibrary testLoadLibetebase() => DynamicLibrary.executable();

void main() {
  group('$Etebase', () {
    test('can spawn and terminate isolate', () async {
      expect(EtebaseIsolate.hasInstance, isFalse);

      await Etebase.ensureInitialized(testLoadLibetebase);

      expect(EtebaseIsolate.hasInstance, isTrue);

      await Etebase.terminate();

      expect(EtebaseIsolate.hasInstance, isFalse);
    });

    test('can spawn and terminate isolate with custom config and logging',
        () async {
      expect(EtebaseIsolate.hasInstance, isFalse);

      await Etebase.ensureInitialized(
        testLoadLibetebase,
        config: const EtebaseConfig(defaultContentBufferSize: 42),
        logLevel: 500,
      );

      expect(EtebaseIsolate.hasInstance, isTrue);

      await Etebase.terminate();

      expect(EtebaseIsolate.hasInstance, isFalse);
    });

    test('terminate does nothing if no isolate is running', () async {
      expect(EtebaseIsolate.hasInstance, isFalse);

      await Etebase.terminate();

      expect(EtebaseIsolate.hasInstance, isFalse);
    });
  });
}
