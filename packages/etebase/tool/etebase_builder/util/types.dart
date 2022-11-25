// ignore_for_file: non_constant_identifier_names

import 'package:code_builder/code_builder.dart';

abstract class Types {
  Types._();

  static final dynamic$ = TypeReference((b) => b..symbol = 'dynamic');

  static final void$ = TypeReference((b) => b..symbol = 'void');

  static final bool$ = TypeReference((b) => b..symbol = 'bool');

  static final int$ = TypeReference((b) => b..symbol = 'int');

  static final String$ = TypeReference((b) => b..symbol = 'String');

  static final DateTime$ = TypeReference((b) => b..symbol = 'DateTime');

  static final List$ = TypeReference((b) => b..symbol = 'List');

  static final Uint8List$ = TypeReference(
    (b) => b
      ..symbol = 'Uint8List'
      ..url = 'dart:typed_data',
  );

  static final TransferableTypedData$ = TypeReference(
    (b) => b
      ..symbol = 'TransferableTypedData'
      ..url = 'dart:isolate',
  );

  static final Void$ = TypeReference(
    (b) => b
      ..symbol = 'Void'
      ..url = 'dart:ffi',
  );

  static final Uint8$ = TypeReference(
    (b) => b
      ..symbol = 'Uint8'
      ..url = 'dart:ffi',
  );

  static final Char$ = TypeReference(
    (b) => b
      ..symbol = 'Char'
      ..url = 'dart:ffi',
  );

  static final Int64$ = TypeReference(
    (b) => b
      ..symbol = 'Int64'
      ..url = 'dart:ffi',
  );

  static final UnsignedLong$ = TypeReference(
    (b) => b
      ..symbol = 'UnsignedLong'
      ..url = 'dart:ffi',
  );

  static final Utf8$ = TypeReference(
    (b) => b
      ..symbol = 'Utf8'
      ..url = 'package:ffi/ffi.dart',
  );

  static final EtebaseCollectionAccessLevel$ = TypeReference(
    (b) => b
      ..symbol = 'EtebaseCollectionAccessLevel'
      ..url = 'package:etebase/src/model/etebase_collection_access_level.dart',
  );

  static final EtebasePrefetchOption$ = TypeReference(
    (b) => b
      ..symbol = 'EtebasePrefetchOption'
      ..url = 'package:etebase/src/model/etebase_prefetch_option.dart',
  );

  static final EtebaseErrorCode$ = TypeReference(
    (b) => b
      ..symbol = 'EtebaseErrorCode'
      ..url = 'package:etebase/src/model/etebase_error_code.dart',
  );

  static final MethodResult$ = TypeReference(
    (b) => b
      ..symbol = 'MethodResult'
      ..url = 'package:etebase/src/isolate/method_result.dart',
  );

  static final MethodInvocation$ = TypeReference(
    (b) => b
      ..symbol = 'MethodInvocation'
      ..url = 'package:etebase/src/isolate/method_invocation.dart',
  );

  static final EtebaseArena$ = TypeReference(
    (b) => b
      ..symbol = 'EtebaseArena'
      ..url = 'package:etebase/src/isolate/etebase_arena.dart',
  );

  static final FfiHelpers$ = TypeReference(
    (b) => b
      ..symbol = 'FfiHelpers'
      ..url = 'package:etebase/src/isolate/ffi_helpers.dart',
  );

  static TypeReference list(TypeReference type) => TypeReference(
        (b) => b
          ..symbol = 'List'
          ..types.add(type),
      );

  static TypeReference future(TypeReference type) => TypeReference(
        (b) => b
          ..symbol = 'Future'
          ..types.add(type),
      );

  static TypeReference pointer(TypeReference? type) => TypeReference(
        (b) {
          b
            ..symbol = 'Pointer'
            ..url = 'dart:ffi';
          if (type != null) {
            b.types.add(type);
          }
        },
      );

  static TypeReference ffi(Reference type) => TypeReference(
        (b) => b
          ..replace(type.type as TypeReference)
          ..url = 'package:etebase/gen/ffi/libetebase.ffi.dart',
      );
}

extension TypeReferenceX on TypeReference {
  TypeReference get asNullable => TypeReference(
        (b) => b
          ..replace(this)
          ..isNullable = true,
      );
}
