import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';

/// @nodoc
@internal
typedef DestroyMethod<T extends NativeType> = void Function(Pointer<T> pointer);

/// @nodoc
@internal
class EtebasePool implements Allocator {
  final Allocator _alloc;

  final _scopedPointers = <Pointer, Function>{};
  final _globalPointers = <Pointer, Function>{};

  /// @nodoc
  EtebasePool([this._alloc = calloc]);

  /// @nodoc
  Pointer<T> attachScoped<T extends NativeType>(
    Pointer<T> ptr, [
    DestroyMethod<T>? destroy,
  ]) {
    _scopedPointers[ptr] = destroy ?? _alloc.free;
    return ptr;
  }

  /// @nodoc
  Pointer<T> attachGlobal<T extends NativeType>(
    Pointer<T> ptr, [
    DestroyMethod<T>? destroy,
  ]) {
    _globalPointers[ptr] = destroy ?? _alloc.free;
    return ptr;
  }

  /// @nodoc
  void freeScoped<T extends NativeType>(Pointer<T> pointer) =>
      _freePointer(_scopedPointers, pointer);

  /// @nodoc
  void freeGlobal<T extends NativeType>(Pointer<T> pointer) =>
      _freePointer(_globalPointers, pointer);

  /// @nodoc
  void releaseScope() => _releasePointers(_scopedPointers);

  /// @nodoc
  void releaseAll() {
    _releasePointers(_scopedPointers);
    _releasePointers(_globalPointers);
  }

  @override
  @visibleForTesting
  Pointer<T> allocate<T extends NativeType>(int byteCount, {int? alignment}) =>
      attachScoped(_alloc.allocate<T>(byteCount, alignment: alignment));

  @override
  @visibleForTesting
  void free(Pointer<NativeType> pointer) {}

  void _freePointer(Map<Pointer, Function> pointers, Pointer pointer) {
    final destroyMethod = pointers.remove(pointer);
    if (destroyMethod != null) {
      // ignore: avoid_dynamic_calls
      destroyMethod(pointer);
    }
  }

  void _releasePointers(Map<Pointer, Function> pointers) {
    for (final entry in pointers.entries) {
      // ignore: avoid_dynamic_calls
      entry.value(entry.key);
    }
    pointers.clear();
  }
}
