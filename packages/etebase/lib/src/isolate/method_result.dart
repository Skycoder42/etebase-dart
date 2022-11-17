import '../model/etebase_error_code.dart';

class MethodResult {
  final int id;
  final dynamic result;
  final EtebaseErrorCode? errorCode;
  final String? errorMessage;

  const MethodResult.success(this.id, this.result)
      : errorCode = null,
        errorMessage = null;

  const MethodResult.error(
    this.id,
    EtebaseErrorCode errorCode,
    String errorMessage,
  )   : result = null,
        // ignore: prefer_initializing_formals
        errorCode = errorCode,
        // ignore: prefer_initializing_formals
        errorMessage = errorMessage;

  bool get isError => errorCode != null;
}
