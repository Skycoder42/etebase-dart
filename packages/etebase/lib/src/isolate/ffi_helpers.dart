import 'package:ffi/ffi.dart';

import '../../gen/ffi/libetebase.ffi.dart' as ffi;
import '../model/etebase_error_code.dart';
import 'etebase_arena.dart';
import 'method_result.dart';

abstract class FfiHelpers {
  FfiHelpers._();

  static MethodResult errorResult(
    ffi.LibEtebaseFFI libEtebase,
    EtebaseArena arena,
    int invocationId,
  ) {
    final errorCode = libEtebase.etebase_error_get_code();
    final errorMessage = arena.attach(libEtebase.etebase_error_get_message());
    return MethodResult.failure(
      invocationId,
      EtebaseErrorCode.values[errorCode],
      errorMessage.cast<Utf8>().toDartString(),
    );
  }
}
