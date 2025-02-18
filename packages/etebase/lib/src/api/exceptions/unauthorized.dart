import 'package:meta/meta.dart';

import 'http_error_content.dart';
import 'http_failure.dart';

/// Authorization is required to access the resource.
class Unauthorized extends HttpFailure {
  /// @nodoc
  @internal
  static const statusCode = 401;

  /// Default constructor.
  Unauthorized(String message, [HttpErrorContent? error])
    : super(statusCode, message, error);

  @override
  String get name => 'Unauthorized';
}
