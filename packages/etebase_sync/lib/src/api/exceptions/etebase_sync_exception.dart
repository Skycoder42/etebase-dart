import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

/// A base class for all etebase_sync related exceptions.
abstract class EtebaseSyncException extends EtebaseException {
  /// @nodoc
  @protected
  EtebaseSyncException(super.message);
}
