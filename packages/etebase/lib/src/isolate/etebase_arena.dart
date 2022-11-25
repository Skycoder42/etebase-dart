import 'dart:ffi';

import 'package:ffi/ffi.dart';

class EtebaseArena extends Arena {
  EtebaseArena() : super(malloc);

  Pointer<T> attach<T extends NativeType>(Pointer<T> pointer) =>
      this.using<Pointer<T>>(pointer, malloc.free);
}
