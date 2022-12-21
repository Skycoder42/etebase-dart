import 'dart:ffi';

import 'package:etebase/src/gen/ffi/libetebase.ffi.dart';
import 'package:etebase/src/isolate/etebase_isolate_error.dart';
import 'package:etebase/src/isolate/etebase_isolate_reference.dart';
import 'package:etebase/src/isolate/etebase_pool.dart';
import 'package:etebase/src/isolate/method_invocation.dart';
import 'package:etebase/src/isolate/method_result.dart';
import 'package:etebase/src/model/etebase_config.dart';
import 'package:test/test.dart';

DynamicLibrary testLoadLibetebase() => DynamicLibrary.executable();

MethodResult testInvocationHandler(
  LibEtebaseFFI libEtebaseFFI,
  EtebasePool pool,
  EtebaseConfig config,
  MethodInvocation invocation,
) {
  if (invocation.method == #test_error_method) {
    throw Exception('test-error');
  }

  return MethodResult.success(invocation.id, {
    'id': invocation.id,
    'config': config,
    'method': invocation.method,
    'arguments': invocation.arguments,
  });
}

void main() {
  group('$EtebaseIsolateReference', () {
    group('uninitialized', () {
      test('create throws exception if not initialized', () {
        expect(
          EtebaseIsolateReference.create,
          throwsA(isA<EtebaseIsolateError>()),
        );
      });
    });

    group('initialized', () {
      const testConfig = EtebaseConfig(
        defaultContentBufferSize: 4200,
      );
      const testMethod = #test_method;
      const testArguments = [1, 'a', false];

      setUp(() {
        EtebaseIsolateReference.initialize(
          loadLibetebase: testLoadLibetebase,
          etebaseConfig: testConfig,
          methodInvocationHandler: testInvocationHandler,
          terminationTimeout: null,
          overwrite: true,
        );
      });

      test('spawns new isolate that can be invoked', () async {
        final ref = await EtebaseIsolateReference.create();
        addTearDown(ref.dispose);

        final result1 = await ref.invoke<Map<String, dynamic>>(
          testMethod,
          testArguments,
        );
        expect(result1, const {
          'id': 0,
          'config': testConfig,
          'method': testMethod,
          'arguments': testArguments,
        });

        final result2 = await ref.maybeInvoke<Map<String, dynamic>>(
          testMethod,
          testArguments,
        );
        expect(result2, const {
          'id': 1,
          'config': testConfig,
          'method': testMethod,
          'arguments': testArguments,
        });
      });

      test('terminates isolate after having been disposed', () async {
        final ref = await EtebaseIsolateReference.create();
        await ref.dispose();

        expect(
          () =>
              ref.invoke<Map<String, dynamic>>(#test_method, const <dynamic>[]),
          throwsA(isA<EtebaseIsolateError>()),
        );

        final result2 = await ref.maybeInvoke<Map<String, dynamic>>(
          testMethod,
          testArguments,
        );
        expect(result2, isNull);
      });

      test('does not spawn a new isolate if another already exists', () async {
        final ref1 = await EtebaseIsolateReference.create();
        addTearDown(ref1.dispose);
        final ref2 = await EtebaseIsolateReference.create();
        addTearDown(ref2.dispose);

        final result1 = await ref1.invoke<Map<String, dynamic>>(
          testMethod,
          testArguments,
        );
        expect(result1, const {
          'id': 0,
          'config': testConfig,
          'method': testMethod,
          'arguments': testArguments,
        });

        final result2 = await ref2.invoke<Map<String, dynamic>>(
          testMethod,
          testArguments,
        );
        expect(result2, const {
          'id': 1,
          'config': testConfig,
          'method': testMethod,
          'arguments': testArguments,
        });
      });

      test(
        'only disposes isolate once all references have been cleaned',
        () async {
          final ref1 = await EtebaseIsolateReference.create();
          final ref2 = await EtebaseIsolateReference.create();
          await expectLater(
            ref1.invoke<Map<String, dynamic>>(#test_method, const <dynamic>[]),
            completes,
          );
          await expectLater(
            ref2.invoke<Map<String, dynamic>>(#test_method, const <dynamic>[]),
            completes,
          );

          await ref1.dispose();
          await expectLater(
            ref1.invoke<Map<String, dynamic>>(#test_method, const <dynamic>[]),
            completes,
          );
          await expectLater(
            ref2.invoke<Map<String, dynamic>>(#test_method, const <dynamic>[]),
            completes,
          );

          await ref2.dispose();
          await expectLater(
            () => ref1
                .invoke<Map<String, dynamic>>(#test_method, const <dynamic>[]),
            throwsA(isA<EtebaseIsolateError>()),
          );
          await expectLater(
            () => ref2
                .invoke<Map<String, dynamic>>(#test_method, const <dynamic>[]),
            throwsA(isA<EtebaseIsolateError>()),
          );
        },
      );
    });
  });
}
