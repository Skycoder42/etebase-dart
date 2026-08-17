import 'etebase_exception.dart';

/// There was an issue with the connection (e.g. DNS lookup)
class ConnectionProblem extends EtebaseException {
  /// The original network error
  final Exception innerException;

  /// Default constructor.
  new(this.innerException) : super(innerException.toString());

  @override
  String get name => 'ConnectionProblem';
}
