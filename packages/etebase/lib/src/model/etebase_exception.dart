// coverage:ignore-file

import 'etebase_error_code.dart';

class EtebaseException implements Exception {
  EtebaseException(
    this.code,
    this.message,
  );

  final EtebaseErrorCode code;

  final String message;

  @override
  String toString() => 'EtebaseException(${code.name}): $message';
}
