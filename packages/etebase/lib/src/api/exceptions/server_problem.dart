import 'http_failure.dart';

/// A permanent server error occurred.
class ServerProblem extends HttpFailure {
  /// Default constructor.
  new(super.status, super.message, [super.error]);

  @override
  String get name => 'ServerProblem';
}
