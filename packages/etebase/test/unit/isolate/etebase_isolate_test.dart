import 'dart:ffi';
import 'dart:io';

import 'package:etebase/src/gen/ffi/libetebase.ffi.dart';
import 'package:etebase/src/isolate/etebase_isolate.dart';
import 'package:etebase/src/isolate/etebase_isolate_error.dart';
import 'package:etebase/src/isolate/etebase_pool.dart';
import 'package:etebase/src/isolate/method_invocation.dart';
import 'package:etebase/src/isolate/method_result.dart';
import 'package:etebase/src/model/etebase_config.dart';
import 'package:test/test.dart';

abstract class Callable<R, T1, T2, T3> {
  R call(T1 t1, T2 t2, T3 t3);
}

DynamicLibrary testLoadLibetebase() => DynamicLibrary.executable();

Never testAlwaysThrow() => throw Exception();

MethodResult testInvocationHandler(
  LibEtebaseFFI libEtebaseFFI,
  EtebasePool pool,
  EtebaseConfig config,
  MethodInvocation invocation,
) {
  sleep(const Duration(milliseconds: 500));

  if (invocation.method == #test_error_method) {
    throw Exception('test-error');
  }

  return MethodResult.success(invocation.id, {
    'config': config,
    'method': invocation.method,
    'arguments': invocation.arguments,
  });
}

void main() {
  group('$EtebaseIsolate', () {
    const testConfig = EtebaseConfig(
      defaultContentBufferSize: 111,
    );

    tearDown(() async {
      if (EtebaseIsolate.hasInstance) {
        await EtebaseIsolate.current.terminate();
      }
    });

    test('current throws state error if not spawned yet', () {
      expect(
        () => EtebaseIsolate.current,
        throwsA(isA<EtebaseIsolateError>()),
      );
    });

    test('spawn creates new isolate', () async {
      expect(EtebaseIsolate.hasInstance, isFalse);

      final instance = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );

      expect(EtebaseIsolate.hasInstance, isTrue);
      expect(instance, same(EtebaseIsolate.current));
    });

    test('spawn does nothing if already spawned', () async {
      final instance1 = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );
      final instance2 = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );

      expect(instance2, same(instance1));
    });

    test('spawn throws if creation of isolate fails', () async {
      expect(EtebaseIsolate.hasInstance, isFalse);

      await expectLater(
        () => EtebaseIsolate.spawn(
          loadLibetebase: testAlwaysThrow,
          etebaseConfig: testConfig,
          methodInvocationHandler: testInvocationHandler,
        ),
        throwsException,
      );

      expect(EtebaseIsolate.hasInstance, isFalse);
    });

    test('invoke sends call to message handler and waits for result', () async {
      final instance = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );

      const testMethod = #test_method;
      const testArguments = [1, 'a', false];

      final result = await instance.invoke<Map<String, dynamic>>(
        testMethod,
        testArguments,
      );

      expect(result, const {
        'config': testConfig,
        'method': testMethod,
        'arguments': testArguments,
      });
    });

    test('invoke rethrows captured exception if handler throws', () async {
      final instance = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );

      expect(
        () => instance.invoke<void>(#test_error_method, const <dynamic>[]),
        throwsException,
      );
    });

    test('invoke can handle parallel messages', () async {
      final instance = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );

      const testMethod1 = #test_method1;
      const testMethod2 = #test_method2;
      const testArguments1 = [1, 'a', false];
      const testArguments2 = [2, 'b', true];

      final results = await Future.wait([
        instance.invoke<Map<String, dynamic>>(testMethod1, testArguments1),
        instance.invoke<Map<String, dynamic>>(testMethod2, testArguments2),
      ]);
      expect(results, [
        const {
          'config': testConfig,
          'method': testMethod1,
          'arguments': testArguments1,
        },
        const {
          'config': testConfig,
          'method': testMethod2,
          'arguments': testArguments2,
        },
      ]);
    });

    test('invoke throws if result type is different', () async {
      final instance = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );

      expect(
        () => instance.invoke<String>(#test_method, const <dynamic>[]),
        throwsA(isA<AssertionError>()),
      );
    });

    test('terminate stops isolate and prevents further invocations', () async {
      final instance = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );

      expect(EtebaseIsolate.hasInstance, isTrue);

      await instance.terminate(timeout: Duration.zero);

      expect(EtebaseIsolate.hasInstance, isFalse);

      expect(
        () => instance.invoke<String>(#test_method, const <dynamic>[]),
        throwsA(isA<EtebaseIsolateError>()),
      );
    });

    test('invoke throws if already been terminated', () async {
      final instance = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );

      await instance.terminate(timeout: Duration.zero);

      expect(
        () => instance.invoke<String>(#test_method, const <dynamic>[]),
        throwsA(isA<EtebaseIsolateError>()),
      );
    });
  });
}
