import 'package:etebase/src/isolate/method_result.dart';
import 'package:etebase/src/model/etebase_error_code.dart';
import 'package:etebase/src/model/etebase_exception.dart';
import 'package:test/test.dart';

void main() {
  group('$MethodResult', () {
    const testId = 111;

    test('successTypes returns success result', () {
      const testData = 42.5;

      final result = MethodResult.successTyped<num>(testId, testData);

      result.maybeWhen(
        success: (id, dynamic result) {
          expect(id, testId);
          expect(result, testData);
        },
        orElse: () => fail('Unexpected type: $result'),
      );
    });

    group('unwrap', () {
      test('.success returns result with correct type', () {
        const result = MethodResult.success(testId, true);

        expect(result.unwrap<bool>(), isTrue);
      });

      test('.success throws exception with different type', () {
        const result = MethodResult.success(testId, 42);

        expect(
          () => result.unwrap<String>(),
          throwsA(isA<AssertionError>()),
        );
      });

      test('.failure throws exception with code and message', () {
        const testErrorCode = EtebaseErrorCode.msgPack;
        const testErrorMessage = 'This is an error';
        const result = MethodResult.failure(
          testId,
          testErrorCode,
          testErrorMessage,
        );

        expect(
          () => result.unwrap<String>(),
          throwsA(
            isA<EtebaseException>()
                .having((e) => e.code, 'code', testErrorCode)
                .having((e) => e.message, 'message', testErrorMessage),
          ),
        );
      });

      test('.exception throws wrapped exception if', () {
        final testException = Exception('error');
        final result = MethodResult.exception(testId, testException);

        expect(
          () => result.unwrap<String>(),
          throwsA(same(testException)),
        );
      });
    });
  });
}
