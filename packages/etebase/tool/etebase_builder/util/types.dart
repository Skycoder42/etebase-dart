// ignore_for_file: non_constant_identifier_names

import 'package:code_builder/code_builder.dart';

abstract class Types {
  Types._();

  static final dynamic$ = TypeReference((b) => b..symbol = 'dynamic');

  static final void$ = TypeReference((b) => b..symbol = 'void');

  static final bool$ = TypeReference((b) => b..symbol = 'bool');

  static final int$ = TypeReference((b) => b..symbol = 'int');

  static final Object$ = TypeReference((b) => b..symbol = 'Object');

  static final String$ = TypeReference((b) => b..symbol = 'String');

  static final Uri$ = TypeReference((b) => b..symbol = 'Uri');

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

  static final UintPtr$ = TypeReference(
    (b) => b
      ..symbol = 'UintPtr'
      ..url = 'dart:ffi',
  );

  static final Utf8$ = TypeReference(
    (b) => b
      ..symbol = 'Utf8'
      ..url = 'package:ffi/ffi.dart',
  );

  static final Arena$ = TypeReference(
    (b) => b
      ..symbol = 'Arena'
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

  static final EtebaseConfig$ = TypeReference(
    (b) => b
      ..symbol = 'EtebaseConfig'
      ..url = 'package:etebase/src/model/etebase_config.dart',
  );

  static final EtebaseIsolateReference$ = TypeReference(
    (b) => b
      ..symbol = 'EtebaseIsolateReference'
      ..url = 'package:etebase/src/isolate/etebase_isolate_reference.dart',
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

  static final EtebasePool$ = TypeReference(
    (b) => b
      ..symbol = 'EtebasePool'
      ..url = 'package:etebase/src/isolate/etebase_pool.dart',
  );

  static final FfiHelpers$ = TypeReference(
    (b) => b
      ..symbol = 'FfiHelpers'
      ..url = 'package:etebase/src/isolate/ffi_helpers.dart',
  );

  static const nullptr$ = Reference('nullptr', 'dart:ffi');

  static const internal$ = Reference('internal', 'package:meta/meta.dart');

  static const freezed$ = Reference('freezed');

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
          ..url = 'package:etebase/src/gen/ffi/libetebase.ffi.dart',
      );

  static TypeReference client(Reference type) => TypeReference(
        (b) => b
          ..replace(type.type as TypeReference)
          ..url = 'package:etebase/src/gen/ffi/libetebase.ffi.client.dart',
      );

  static TypeReference destroyReference(Reference? type) => TypeReference(
        (b) {
          b
            ..symbol = 'DestroyReference'
            ..url = 'package:etebase/src/isolate/destroy_reference.dart';
          if (type != null) {
            b.types.add(type);
          }
        },
      );
}

extension TypeReferenceX on TypeReference {
  TypeReference get asNullable => TypeReference(
        (b) => b
          ..replace(this)
          ..isNullable = true,
      );
}
