import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

import '../util/dart_type_extensions.dart';
import '../util/types.dart';
import 'etebase_parser.dart';

enum PointerKind {
  none(false),
  opaque(true),
  opaqueOut(true);

  final bool isPointer;

  // ignore: avoid_positional_boolean_parameters
  const PointerKind(this.isPointer);
}

class TypeRef {
  final DartType ffiType;
  final TypeReference publicType;
  final TypeReference transferType;

  final PointerKind pointerKind;

  const TypeRef({
    required this.ffiType,
    required this.publicType,
    required this.transferType,
    this.pointerKind = PointerKind.none,
  });

  bool get isList => publicType.symbol == 'List';

  @override
  String toString() => '$ffiType --$transferType--> $publicType [$pointerKind]';
}

class TypeParser {
  const TypeParser();

  TypeRef parseType({
    required DartType type,
    bool isArray = false,
    required TypedefRef typeDefs,
  }) {
    if (type.isVoid) {
      return TypeRef(
        ffiType: type,
        publicType: Types.void$,
        transferType: Types.void$,
      );
    }

    if (type is! InterfaceType) {
      return TypeRef(
        ffiType: type,
        publicType: type.typeReference(),
        transferType: type.typeReference(),
      );
    }

    if (type.isPointer) {
      final pointerType = type.asPointer;
      return isArray
          ? _mapPointerArrayType(type, pointerType, typeDefs)
          : _mapPointerType(type, pointerType, typeDefs);
    }

    return TypeRef(
      ffiType: type,
      publicType: type.typeReference(),
      transferType: type.typeReference(),
    );
  }

  TypeRef _mapPointerType(
    DartType ffiType,
    DartType pointerType,
    TypedefRef typeDefs,
  ) {
    if (pointerType.isPointer) {
      return TypeRef(
        ffiType: ffiType,
        publicType:
            Types.list(pointerType.asPointer.typeReference(stripUrl: true)),
        transferType: Types.list(Types.int$),
        pointerKind: PointerKind.opaqueOut,
      );
    }

    final pointerElement = pointerType.element;
    var pointerKind = PointerKind.none;
    if (pointerElement is ClassElement) {
      if (pointerElement.name.startsWith('Etebase')) {
        pointerKind = PointerKind.opaque;
      }

      final resolvedElement = typeDefs.elementFor(pointerElement);
      if (!identical(resolvedElement, pointerElement)) {
        return TypeRef(
          ffiType: ffiType,
          publicType: TypeReference((b) => b..symbol = resolvedElement.name),
          transferType: Types.int$,
          pointerKind: pointerKind,
        );
      }
    }

    final TypeReference publicType;
    switch (pointerElement!.name) {
      case 'Char':
        publicType = Types.String$;
        break;
      case 'Int64': // is always a date time in etebase context
        publicType = Types.DateTime$;
        break;
      default:
        publicType = pointerType.typeReference(stripUrl: true);
        break;
    }

    return TypeRef(
      ffiType: ffiType,
      publicType: publicType,
      transferType: pointerKind.isPointer ? Types.int$ : publicType,
      pointerKind: pointerKind,
    );
  }

  TypeRef _mapPointerArrayType(
    DartType ffiType,
    DartType pointerType,
    TypedefRef typeDefs,
  ) {
    switch (pointerType.element!.name) {
      case 'Void':
        return TypeRef(
          ffiType: ffiType,
          publicType: Types.Uint8List$,
          transferType: Types.Uint8List$,
        );
      default:
        final listType = parseType(type: pointerType, typeDefs: typeDefs);
        return TypeRef(
          ffiType: ffiType,
          publicType: Types.list(listType.publicType),
          transferType: Types.list(listType.transferType),
          pointerKind: listType.pointerKind,
        );
    }
  }
}
