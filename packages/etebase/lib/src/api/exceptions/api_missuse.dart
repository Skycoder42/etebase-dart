import 'etebase_exception.dart';

/// API missuses.
class ApiMissuse extends EtebaseException {
  /// Default constructor.
  ApiMissuse(super.message);

  @override
  String get name => 'ApiMissuse';
}
