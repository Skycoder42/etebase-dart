import 'dart:ffi';

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

  static void assignPointerList<TPtr extends NativeType, TData>(
    Pointer<Pointer<TPtr>> pointerList,
    List<TData> dataList,
    Pointer<TPtr> Function(TData) mapper,
  ) {
    for (var i = 0; i < dataList.length; ++i) {
      pointerList[i] = mapper(dataList[i]);
    }
  }

  static List<TData> extractPointerList<TPtr extends NativeType, TData>(
    Pointer<Pointer<TPtr>> pointerList,
    int pointerListLength,
    TData Function(Pointer<TPtr>) mapper,
  ) =>
      List.generate(
        pointerListLength,
        (index) => mapper(pointerList[index]),
        growable: false,
      );
}