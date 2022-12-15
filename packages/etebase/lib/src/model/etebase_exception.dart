// coverage:ignore-file

import 'etebase_error_code.dart';

/// An exception thrown by the library if a etebase operation fails.
class EtebaseException implements Exception {
  /// Default constructor.
  EtebaseException(
    this.code,
    this.message,
  );

  /// The error code of this exception.
  final EtebaseErrorCode code;

  /// The detailed error message of this exception.
  final String message;

  @override
  String toString() => 'EtebaseException(${code.name}): $message';
}
