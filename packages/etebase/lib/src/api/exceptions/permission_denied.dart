import 'package:meta/meta.dart';

import 'http_error_content.dart';
import 'http_failure.dart';

/// Access to the resource has not been granted.
class PermissionDenied extends HttpFailure {
  /// @nodoc
  @internal
  static const statusCode = 403;

  /// Default constructor.
  PermissionDenied(String message, [HttpErrorContent? error])
    : super(statusCode, message, error);

  @override
  String get name => 'PermissionDenied';
}
