// ignore: test_library_import
import 'package:etebase/gen/ffi/libetebase.ffi.dart' hide EtebaseErrorCode;
import 'package:etebase/src/isolate/logging_invocation_handler_wrapper.dart';
import 'package:etebase/src/isolate/method_invocation.dart';
import 'package:etebase/src/isolate/method_result.dart';
import 'package:etebase/src/model/etebase_config.dart';
import 'package:etebase/src/model/etebase_error_code.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class Callable<R, T1, T2, T3> {
  R call(T1 t1, T2 t2, T3 t3);
}

class MockCallable<R, T1, T2, T3> extends Mock
    implements Callable<R, T1, T2, T3> {}

class FakeLibEtebaseFFI extends Fake implements LibEtebaseFFI {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLibEtebaseFFI());
    registerFallbackValue(const EtebaseConfig());
    registerFallbackValue(const MethodInvocation(0, #x, <dynamic>[]));
  });

  group('$LoggingInvocationHandlerWrapper', () {
    final mockHandler = MockCallable<MethodResult, LibEtebaseFFI, EtebaseConfig,
        MethodInvocation>();

    late LoggingInvocationHandlerWrapper sut;

    setUp(() {
      reset(mockHandler);

      sut = LoggingInvocationHandlerWrapper(mockHandler);
    });

    test('invokes handler and returns success result', () {
      final testLibEtebaseFFI = FakeLibEtebaseFFI();
      const testConfig = EtebaseConfig();
      const testInvocation = MethodInvocation(
        42,
        #etebase_fake_method,
        <dynamic>[1, 'a', true],
      );
      const testResult = MethodResult.success(42, 12345);

      when(() => mockHandler(any(), any(), any())).thenReturn(testResult);

      final result = sut(testLibEtebaseFFI, testConfig, testInvocation);

      expect(result, same(testResult));

      verify(
        () => mockHandler(
          any(that: same(testLibEtebaseFFI)),
          any(that: same(testConfig)),
          any(that: same(testInvocation)),
        ),
      );
    });

    test('invokes handler and returns failure result', () {
      final testLibEtebaseFFI = FakeLibEtebaseFFI();
      const testConfig = EtebaseConfig();
      const testInvocation = MethodInvocation(
        43,
        #etebase_fake_method,
        <dynamic>[1, 'a', true],
      );
      const testResult = MethodResult.failure(
        43,
        EtebaseErrorCode.encryption,
        'test-error',
      );

      when(() => mockHandler(any(), any(), any())).thenReturn(testResult);

      final result = sut(testLibEtebaseFFI, testConfig, testInvocation);

      expect(result, same(testResult));

      verify(
        () => mockHandler(
          any(that: same(testLibEtebaseFFI)),
          any(that: same(testConfig)),
          any(that: same(testInvocation)),
        ),
      );
    });

    test('invokes handler and returns exception result', () {
      final testLibEtebaseFFI = FakeLibEtebaseFFI();
      const testConfig = EtebaseConfig();
      const testInvocation = MethodInvocation(
        44,
        #etebase_fake_method,
        <dynamic>[1, 'a', true],
      );
      final testResult = MethodResult.exception(44, Exception('test'));

      when(() => mockHandler(any(), any(), any())).thenReturn(testResult);

      final result = sut(testLibEtebaseFFI, testConfig, testInvocation);

      expect(result, same(testResult));

      verify(
        () => mockHandler(
          any(that: same(testLibEtebaseFFI)),
          any(that: same(testConfig)),
          any(that: same(testInvocation)),
        ),
      );
    });

    test('invokes handler and rethrows exceptions', () {
      final testLibEtebaseFFI = FakeLibEtebaseFFI();
      const testConfig = EtebaseConfig();
      const testInvocation = MethodInvocation(
        44,
        #etebase_fake_method,
        <dynamic>[1, 'a', true],
      );
      final testException = Exception('test');

      when(() => mockHandler(any(), any(), any())).thenThrow(testException);

      expect(
        () => sut(testLibEtebaseFFI, testConfig, testInvocation),
        throwsA(same(testException)),
      );

      verify(
        () => mockHandler(
          any(that: same(testLibEtebaseFFI)),
          any(that: same(testConfig)),
          any(that: same(testInvocation)),
        ),
      );
    });
  });
}
