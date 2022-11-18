import 'package:code_builder/code_builder.dart';

extension TypeReferenceX on TypeReference {
  TypeReference get asPointer => TypeReference(
        (b) => b
          ..symbol = 'Pointer'
          ..url = 'dart:ffi'
          ..types.add(this),
      );
}
