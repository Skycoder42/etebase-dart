import 'package:meta/meta.dart';

/// A base class for all etebase related exceptions.
abstract class EtebaseException implements Exception {
  /// The error message.
  final String message;

  /// @nodoc
  @protected
  new(this.message);

  /// @nodoc
  @visibleForOverriding
  String get name;

  @override
  String toString() => '$name: $message';
}
