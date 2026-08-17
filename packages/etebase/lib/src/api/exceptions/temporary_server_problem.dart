import 'http_failure.dart';

/// A temporary server error occurred.
class TemporaryServerProblem extends HttpFailure {
  /// Default constructor.
  new(super.status, super.message, [super.error]);

  @override
  String get name => 'TemporaryServerProblem';
}
