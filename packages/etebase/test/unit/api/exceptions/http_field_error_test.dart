import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/exceptions/http_field_error.dart';
import 'package:test/test.dart';

void main() {
  group('$HttpFieldError', () {
    testData(
      'toString returns correct result',
      const [
        (HttpFieldError(code: 'TST1', detail: 'Test 1'), 'TST1: Test 1'),
        (
          HttpFieldError(code: 'TST2', detail: 'Test 2', field: 'test_field'),
          'test_field => TST2: Test 2',
        ),
      ],
      (fixture) {
        expect(fixture.$1.toString(), fixture.$2);
      },
    );
  });
}
