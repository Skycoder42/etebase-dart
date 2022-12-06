import 'package:etebase/src/model/etebase_error_code.dart';
import 'package:etebase/src/model/etebase_exception.dart';
import 'package:test/test.dart';

Matcher isEtebaseException([EtebaseErrorCode? code]) {
  final matcher = isA<EtebaseException>();
  return code == null ? matcher : matcher.having((e) => e.code, 'code', code);
}

Matcher throwsEtebaseException([EtebaseErrorCode? code]) =>
    throwsA(isEtebaseException(code));
