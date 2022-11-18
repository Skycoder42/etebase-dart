import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

import 'etebase_parser.dart';

class TypeRef {
  final DartType ffiType;
  final TypeReference dartType;

  final bool isOpaquePointer;
  final bool isOutParam;

  const TypeRef({
    required this.ffiType,
    required this.dartType,
    this.isOpaquePointer = false,
    this.isOutParam = false,
  });

  @override
  String toString() => '$ffiType -> $dartType [$isOpaquePointer] [$isOutParam]';
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
      final isOpaquePointer = _Ref<bool>(false);
      final typeRef = isArray
          ? _mapPointerArrayType(pointerType, typeDefs, isOpaquePointer)
          : _mapPointerType(pointerType, typeDefs, isOutParam, isOpaquePointer);
      return TypeRef(
        ffiType: type,
        dartType: typeRef,
        isOutParam: isOutParam.value,
        isOpaquePointer: isOpaquePointer.value,
      );
    }

    return TypeRef(
      ffiType: type,
      dartType: type.typeReference,
    );
  }

  TypeRef createAccessLevelFor(DartType type) {
    assert(type.isDartCoreInt, 'type should be int, but was $type');
    return TypeRef(
      ffiType: type,
      dartType: TypeReference(
        (b) => b
          ..symbol = 'EtebaseCollectionAccessLevel'
          ..url = '../../src/model/etebase_collection_access_level.dart',
      ),
    );
  }

  TypeRef createPrefetchOptionFor(DartType type) {
    assert(type.isDartCoreInt, 'type should be int, but was $type');
    return TypeRef(
      ffiType: type,
      dartType: TypeReference(
        (b) => b
          ..symbol = 'EtebasePrefetchOption'
          ..url = '../../src/model/etebase_prefetch_option.dart',
      ),
    );
  }

  TypeReference _mapPointerType(
    DartType pointerType,
    TypedefRef typeDefs,
    _Ref<bool> isOutParam,
    _Ref<bool> isOpaquePointer,
  ) {
    if (pointerType is InterfaceType && pointerType.isPointer) {
      isOutParam.value = true;
      isOpaquePointer.value = true;
      return TypeReference(
        (b) => b
          ..symbol = 'List'
          ..types.add(pointerType.typeArguments.single.typeReference),
      );
    }

    final pointerElement = pointerType.element;
    if (pointerElement is ClassElement) {
      isOpaquePointer.value = pointerElement.name.startsWith('Etebase');
      final resolvedElement = typeDefs.elementFor(pointerElement);
      if (!identical(resolvedElement, pointerElement)) {
        return TypeReference((b) => b..symbol = resolvedElement.name);
      }
    }

    switch (pointerElement!.name) {
      case 'Char':
        return TypeReference((b) => b..symbol = 'String');
      case 'Int64': // is always a date time in etebase context
        return TypeReference((b) => b..symbol = 'DateTime');
      default:
        return pointerType.typeReference;
    }
  }

  TypeReference _mapPointerArrayType(
    DartType pointerType,
    TypedefRef typeDefs,
    _Ref<bool> isOpaquePointer,
  ) {
    switch (pointerType.element!.name) {
      case 'Void':
        return TypeReference(
          (b) => b
            ..symbol = 'Uint8List'
            ..url = 'dart:typed_data',
        );
      default:
        final listType = parseType(type: pointerType, typeDefs: typeDefs);
        isOpaquePointer.value = listType.isOpaquePointer;
        return TypeReference(
          (b) => b
            ..symbol = 'List'
            ..types.add(listType.dartType),
        );
    }
  }
}

extension _DartTypeX on DartType {
  bool get isPointer => this is InterfaceType && element!.name == 'Pointer';

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

class _Ref<T> {
  T value;

  _Ref(this.value);
}
