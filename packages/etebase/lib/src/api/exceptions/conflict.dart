import 'package:meta/meta.dart';

import 'http_error_content.dart';
import 'http_failure.dart';

/// A conflict between local and remote changes has been detected.
class Conflict extends HttpFailure {
  /// @nodoc
  @internal
  static const statusCode = 409;

  /// Default constructor.
  new(String message, [HttpErrorContent? error])
    : super(statusCode, message, error);

  @override
  String get name => 'Conflict';
}
