import 'package:meta/meta.dart';

import 'http_error_content.dart';
import 'http_failure.dart';

/// The resource was not found on the server.
class NotFound extends HttpFailure {
  /// @nodoc
  @internal
  static const statusCode = 404;

  /// Default constructor.
  new(String message, [HttpErrorContent? error])
    : super(statusCode, message, error);

  @override
  String get name => 'NotFound';
}
