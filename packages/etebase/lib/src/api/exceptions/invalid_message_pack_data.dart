import 'etebase_exception.dart';

/// Required content of an item is missing.
class InvalidMessagePackData extends EtebaseException {
  /// The original error that occurred while deserializing
  final Object? innerError;

  /// Default constructor.
  InvalidMessagePackData(super.message, [this.innerError]);

  @override
  String get name => 'InvalidMessagePackData';
}
