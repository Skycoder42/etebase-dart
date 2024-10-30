import 'etebase_exception.dart';

/// The integrity of the data was compromised.
class IntegrityCompromised extends EtebaseException {
  /// Default constructor.
  IntegrityCompromised(super.message);

  @override
  String get name => 'IntegrityCompromised';
}
