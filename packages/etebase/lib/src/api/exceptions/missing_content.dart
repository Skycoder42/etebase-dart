import 'etebase_exception.dart';

/// Required content of an item is missing.
class MissingContent extends EtebaseException {
  /// Default constructor.
  MissingContent(super.message);

  @override
  String get name => 'MissingContent';
}
