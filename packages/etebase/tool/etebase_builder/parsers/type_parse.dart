import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

import 'etebase_parser.dart';

class TypeRef {
  final DartType ffiType;
  final TypeReference dartType;

  final bool isOutParam;

  const TypeRef({
    required this.ffiType,
    required this.dartType,
    this.isOutParam = false,
  });
}

class TypeContext {
  final DartType type;
  final bool isArray;

  final TypedefRef typeDefs;

  const TypeContext({
    required this.type,
    required this.isArray,
    required this.typeDefs,
  });
}

class TypeParser {
  const TypeParser();

  TypeRef parseType(TypeContext context) {
    final type = context.type;
    if (type.isVoid) {
      return TypeRef(
        ffiType: type,
        dartType: TypeReference((b) => b..symbol = 'void'),
      );
    }

    if (type is! InterfaceType) {
      return TypeRef(
        ffiType: type,
        dartType: type.typeReference,
      );
    }

    if (type.isPointer) {
      final pointerType = type.typeArguments.single;
      final isOutParam = _Ref<bool>(false);
      final typeRef = context.isArray
          ? _mapPointerArrayType(context, pointerType)
          : _mapPointerType(context, pointerType, isOutParam);
      return TypeRef(
        ffiType: type,
        dartType: typeRef,
        isOutParam: isOutParam.value,
      );
    }

    return TypeRef(
      ffiType: type,
      dartType: type.typeReference,
    );
  }

  TypeReference _mapPointerType(
    TypeContext context,
    DartType pointerType,
    _Ref<bool> isOutParam,
  ) {
    if (pointerType is InterfaceType && pointerType.isPointer) {
      isOutParam.value = true;
      return pointerType.typeArguments.single.typeReference;
    }

    final pointerElement = pointerType.element;
    if (pointerElement is ClassElement) {
      final resolvedElement = context.typeDefs.elementFor(pointerElement);
      if (!identical(resolvedElement, pointerElement)) {
        return TypeReference((b) => b..symbol = resolvedElement.name);
      }
    }

    switch (pointerElement!.name) {
      case 'Char':
        return TypeReference((b) => b..symbol = 'String');
      case 'Int64':
        return TypeReference((b) => b..symbol = 'int');
      default:
        return pointerType.typeReference;
    }
  }

  TypeReference _mapPointerArrayType(
    TypeContext context,
    DartType pointerType,
  ) {
    switch (pointerType.element!.name) {
      case 'Void':
        return TypeReference(
          (b) => b
            ..symbol = 'Uint8List'
            ..url = 'dart:typed_data',
        );
      default:
        return TypeReference(
          (b) => b
            ..symbol = 'List'
            ..types.add(
              parseType(
                TypeContext(
                  type: pointerType,
                  isArray: false,
                  typeDefs: context.typeDefs,
                ),
              ).dartType,
            ),
        );
    }
  }
}

extension _DartTypeX on DartType {
  TypeReference get typeReference => TypeReference(
        (b) {
          b
            ..symbol = element!.name
            ..isNullable = nullabilitySuffix != NullabilitySuffix.none;

          final self = this;
          if (self is InterfaceType) {
            b.types.addAll(self.typeArguments.map((t) => t.typeReference));
          }
        },
      );
}

extension _InterfaceTypeX on InterfaceType {
  bool get isPointer => element.name == 'Pointer';
}

class _Ref<T> {
  T value;

  _Ref(this.value);
}
