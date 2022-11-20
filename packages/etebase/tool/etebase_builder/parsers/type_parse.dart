import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

import '../util/dart_type_extensions.dart';
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
  final TypeReference dartType;

  final PointerKind pointerKind;

  const TypeRef({
    required this.ffiType,
    required this.dartType,
    this.pointerKind = PointerKind.none,
  });

  @override
  String toString() => '$ffiType -> $dartType [$pointerKind]';
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
      final pointerType = type.asPointer;
      final pointerKindRef = _Ref<PointerKind>(PointerKind.none);
      final typeRef = isArray
          ? _mapPointerArrayType(pointerType, typeDefs, pointerKindRef)
          : _mapPointerType(pointerType, typeDefs, pointerKindRef);
      return TypeRef(
        ffiType: type,
        dartType: typeRef,
        pointerKind: pointerKindRef.value,
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
    _Ref<PointerKind> pointerKindRef,
  ) {
    if (pointerType.isPointer) {
      pointerKindRef.value = PointerKind.opaqueOut;
      return TypeReference(
        (b) => b
          ..symbol = 'List'
          ..types.add(pointerType.asPointer.typeReference),
      );
    }

    final pointerElement = pointerType.element;
    if (pointerElement is ClassElement) {
      pointerKindRef.value = pointerElement.name.startsWith('Etebase')
          ? PointerKind.opaque
          : PointerKind.none;
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
    _Ref<PointerKind> pointerKindRef,
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
        pointerKindRef.value = listType.pointerKind;
        return TypeReference(
          (b) => b
            ..symbol = 'List'
            ..types.add(listType.dartType),
        );
    }
  }
}

class _Ref<T> {
  T value;

  _Ref(this.value);
}
