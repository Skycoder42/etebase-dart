import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/etebase_error_code.dart';
import '../model/etebase_exception.dart';

part 'method_result.freezed.dart';

/// @nodoc
@freezed
@internal
class MethodResult with _$MethodResult {
  /// @nodoc
  static MethodResult successTyped<T>(int id, T result) =>
      MethodResult.success(id, result);

  /// @nodoc
  const factory MethodResult.success(int id, dynamic result) = _Success;

  /// @nodoc
  const factory MethodResult.failure(
    int id,
    EtebaseErrorCode code,
    String message,
  ) = _Failure;

  /// @nodoc
  const factory MethodResult.exception(int id, Object error) = _Exception;

  const MethodResult._();

  /// @nodoc
  T unwrap<T>() => when(
        success: (id, dynamic result) {
          assert(result is T, 'result must be of type $T');
          return result as T;
        },
        failure: (id, code, message) => throw EtebaseException(code, message),
        // ignore: only_throw_errors
        exception: (id, error) => throw error,
      );
}
