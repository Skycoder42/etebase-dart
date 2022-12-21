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

  if (invocation.method == #test_blocking_method) {
    sleep(const Duration(seconds: 2));
    return MethodResult.success(invocation.id, null);
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

    test('spawn creates new isolate', () async {
      final instance = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );
      addTearDown(instance.terminate);
    });

    test('spawn can create multiple isolates', () async {
      final instance1 = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );
      addTearDown(instance1.terminate);
      final instance2 = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );
      addTearDown(instance2.terminate);

      expect(instance2, isNot(same(instance1)));
    });

    test('spawn throws if creation of isolate fails', () async {
      await expectLater(
        () => EtebaseIsolate.spawn(
          loadLibetebase: testAlwaysThrow,
          etebaseConfig: testConfig,
          methodInvocationHandler: testInvocationHandler,
        ),
        throwsException,
      );
    });

    test('invoke sends call to message handler and waits for result', () async {
      final instance = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );
      addTearDown(instance.terminate);

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
      addTearDown(instance.terminate);

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
      addTearDown(instance.terminate);

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
      addTearDown(instance.terminate);

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

      await instance.terminate();

      expect(
        () => instance.invoke<Map<String, dynamic>>(
          #test_method,
          const <dynamic>[],
        ),
        throwsA(isA<EtebaseIsolateError>()),
      );
    });

    test('terminate with timeout kills isolate if timeout is reached',
        () async {
      final instance = await EtebaseIsolate.spawn(
        loadLibetebase: testLoadLibetebase,
        etebaseConfig: testConfig,
        methodInvocationHandler: testInvocationHandler,
      );

      instance.invoke<void>(#test_blocking_method, const <dynamic>[]).ignore();
      await instance.terminate(timeout: const Duration(milliseconds: 500));

      expect(
        () => instance.invoke<Map<String, dynamic>>(
          #test_method,
          const <dynamic>[],
        ),
        throwsA(isA<EtebaseIsolateError>()),
      );
    });
  });
}
