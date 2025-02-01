import '../managers/crypto_executor.dart';
import 'etebase_exception.dart';

/// A wrapper exception type for error that occur on the background isolate of
/// the [CryptoExecutor.async].
class AsyncCryptoExecutorIsolateFailure extends EtebaseException {
  /// The toString() result of the original exception.
  final String originalMessage;

  /// Default constructor.
  AsyncCryptoExecutorIsolateFailure(this.originalMessage)
      : super(originalMessage);

  @override
  String get name => 'AsyncCryptoExecutorIsolateFailure';

  @override
  String toString() => originalMessage;
}
