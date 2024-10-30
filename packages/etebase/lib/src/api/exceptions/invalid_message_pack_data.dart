import 'etebase_exception.dart';

/// Required content of an item is missing.
class InvalidMessagePackData extends EtebaseException {
  /// Default constructor.
  InvalidMessagePackData(super.message);

  @override
  String get name => 'InvalidMessagePackData';
}
