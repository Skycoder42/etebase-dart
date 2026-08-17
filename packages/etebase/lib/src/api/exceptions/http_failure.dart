import 'etebase_exception.dart';
import 'http_error_content.dart';

/// A http error occurred.
class HttpFailure extends EtebaseException {
  /// The HTTP status code.
  final int status;

  /// The contents of the HTTP error response.
  final HttpErrorContent? error;

  /// Default constructor.
  new(this.status, String message, [this.error]) : super(message);

  @override
  String get name => 'HttpFailure';

  @override
  String toString() => '$name($status): ${error ?? message}';
}
