import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sodium/sodium.dart';

import 'etebase_exception.dart';

/// An issue with the encryption/decryption or other cryptographic operations.
class CryptoFailure extends EtebaseException {
  /// The original error message, if one existed.
  ///
  /// See [SodiumException.originalMessage].
  final String? originalMessage;

  /// Default constructor.
  CryptoFailure({this.originalMessage})
      : super('A low level cryptographic operation has failed');

  /// @nodoc
  @internal
  static FT wrap<FT extends FutureOr<T>, T>(FT Function() callback) {
    try {
      final result = callback();
      if (result is Future<T>) {
        // ignore: discarded_futures
        return result.onError<SodiumException>(_rethrow) as FT;
      } else {
        return result;
      }
    } on SodiumException catch (e, s) {
      _rethrow(e, s);
    }
  }

  @override
  String get name => 'CryptoFailure';

  static Never _rethrow(SodiumException error, StackTrace stackTrace) =>
      Error.throwWithStackTrace(
        CryptoFailure(originalMessage: error.originalMessage),
        stackTrace,
      );
}
