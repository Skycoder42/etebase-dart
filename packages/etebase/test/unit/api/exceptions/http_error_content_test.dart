import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/exceptions/http_error_content.dart';
import 'package:etebase/src/api/exceptions/http_field_error.dart';
import 'package:test/test.dart';

void main() {
  group('$HttpErrorContent', () {
    testData(
      'toString() returns correct result',
      const [
        (HttpErrorContent(), true, 'Unknown error'),
        (HttpErrorContent(code: 'TST1'), true, 'TST1'),
        (HttpErrorContent(detail: 'Test 2'), true, 'Test 2'),
        (
          HttpErrorContent(
            errors: [
              HttpFieldError(code: 'FLD1', detail: 'Field 1'),
              HttpFieldError(code: 'FLD2', detail: 'Field 2'),
            ],
          ),
          true,
          'Unknown error\n | FLD1: Field 1\n | FLD2: Field 2',
        ),
        (
          HttpErrorContent(
            errors: [
              HttpFieldError(code: 'FLD1', detail: 'Field 1'),
              HttpFieldError(code: 'FLD2', detail: 'Field 2'),
            ],
          ),
          false,
          'Unknown error',
        ),
        (
          HttpErrorContent(code: 'TST4', detail: 'Test 4'),
          true,
          'TST4: Test 4',
        ),
        (
          HttpErrorContent(
            code: 'TST5',
            errors: [HttpFieldError(code: 'FLD3', detail: 'Field 3')],
          ),
          true,
          'TST5\n | FLD3: Field 3',
        ),
        (
          HttpErrorContent(
            code: 'TST5',
            errors: [HttpFieldError(code: 'FLD3', detail: 'Field 3')],
          ),
          false,
          'TST5',
        ),
        (
          HttpErrorContent(
            detail: 'Test 6',
            errors: [HttpFieldError(code: 'FLD3', detail: 'Field 3')],
          ),
          true,
          'Test 6\n | FLD3: Field 3',
        ),
        (
          HttpErrorContent(
            detail: 'Test 6',
            errors: [HttpFieldError(code: 'FLD3', detail: 'Field 3')],
          ),
          false,
          'Test 6',
        ),
        (
          HttpErrorContent(
            code: 'TST7',
            detail: 'Test 7',
            errors: [HttpFieldError(code: 'FLD4', detail: 'Field 4')],
          ),
          true,
          'TST7: Test 7\n | FLD4: Field 4',
        ),
        (
          HttpErrorContent(
            code: 'TST7',
            detail: 'Test 7',
            errors: [HttpFieldError(code: 'FLD4', detail: 'Field 4')],
          ),
          false,
          'TST7: Test 7',
        ),
      ],
      (fixture) {
        expect(fixture.$1.toString(withErrors: fixture.$2), fixture.$3);
      },
    );
  });
}
