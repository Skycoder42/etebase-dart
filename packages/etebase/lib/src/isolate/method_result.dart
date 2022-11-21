import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/etebase_error_code.dart';
import '../model/etebase_exception.dart';

part 'method_result.freezed.dart';

@freezed
class MethodResult with _$MethodResult {
  const factory MethodResult.success(int id, dynamic result) = _Success;
  const factory MethodResult.failure(
    int id,
    EtebaseErrorCode code,
    String message,
  ) = _Failure;
  const factory MethodResult.exception(int id, Object error) = _Exception;

  const MethodResult._();

  T asResult<T>() => when(
        success: (id, dynamic result) => result as T,
        failure: (id, code, message) => throw EtebaseException(code, message),
        // ignore: only_throw_errors
        exception: (id, error) => throw error,
      );
}
