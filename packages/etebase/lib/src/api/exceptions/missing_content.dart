import 'etebase_exception.dart';

/// Required content of an item is missing.
class MissingContent extends EtebaseException {
  /// Default constructor.
  new(super.message);

  @override
  String get name => 'MissingContent';
}
