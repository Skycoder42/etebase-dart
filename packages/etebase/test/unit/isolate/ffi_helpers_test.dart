// ignore_for_file: unnecessary_lambdas

import 'dart:ffi';

// ignore: test_library_import
import 'package:etebase/gen/ffi/libetebase.ffi.dart' show LibEtebaseFFI;
import 'package:etebase/src/isolate/ffi_helpers.dart';
import 'package:etebase/src/model/etebase_error_code.dart';
import 'package:ffi/ffi.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLibEtebaseFFI extends Mock implements LibEtebaseFFI {}

void main() {
  group('$FfiHelpers', () {
    final arena = Arena();
    final mockLibEtebaseFFI = MockLibEtebaseFFI();

    tearDown(() {
      arena.releaseAll(reuse: true);
    });

    test('errorResult constructs error from code and message', () {
      const testId = 42;
      const testCode = EtebaseErrorCode.encryption;
      const testMessage = 'This is an error';

      when(() => mockLibEtebaseFFI.etebase_error_get_code())
          .thenReturn(testCode.index);
      when(() => mockLibEtebaseFFI.etebase_error_get_message())
          .thenReturn(testMessage.toNativeUtf8(allocator: arena).cast());

      final result = FfiHelpers.errorResult(mockLibEtebaseFFI, testId);
      result.maybeWhen(
        failure: (id, code, message) {
          expect(id, testId);
          expect(code, testCode);
          expect(message, testMessage);
        },
        orElse: () => fail('$result is not of type MethodResult.failure'),
      );

      verify(() => mockLibEtebaseFFI.etebase_error_get_code());
      verify(() => mockLibEtebaseFFI.etebase_error_get_message());
      verifyNoMoreInteractions(mockLibEtebaseFFI);
    });

    test('assignPointerList correctly assigns data', () {
      const listLength = 10;
      final testData = List.generate(listLength, (index) => index);
      final testPtr = arena<Pointer<Int32>>(listLength);

      FfiHelpers.assignPointerList(
        testPtr,
        testData,
        (d) => arena<Int32>()..value = d,
      );

      for (var i = 0; i < listLength; ++i) {
        expect(
          testPtr[i].value,
          testData[i],
          reason: 'value at index $i is different',
        );
      }
    });

    test('extractPointerList correctly extracts data', () {
      const listLength = 10;
      final testPtr = arena<Pointer<Int32>>(listLength);
      for (var i = 0; i < listLength; ++i) {
        testPtr[i] = arena<Int32>()..value = i;
      }

      final result = FfiHelpers.extractPointerList(
        testPtr,
        listLength,
        (p) => p.value,
      );

      expect(result, List.generate(listLength, (index) => index));
    });
  });
}
