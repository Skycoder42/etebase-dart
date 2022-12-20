import 'dart:ffi';

import 'package:meta/meta.dart';

import 'etebase_isolate_reference.dart';

/// @nodoc
@internal
class DestroyReference<T extends NativeType> {
  /// @nodoc
  final EtebaseIsolateReference isolate;

  /// @nodoc
  final Pointer<T> pointer;

  /// @nodoc
  const DestroyReference(this.isolate, this.pointer);
}
