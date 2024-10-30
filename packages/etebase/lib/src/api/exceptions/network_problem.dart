import 'etebase_exception.dart';

/// Problems with establishing the connection to the server.
class NetworkProblem extends EtebaseException {
  /// Default constructor.
  NetworkProblem(super.message);

  @override
  String get name => 'NetworkProblem';
}
