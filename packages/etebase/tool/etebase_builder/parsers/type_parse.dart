import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../util/dart_type_extensions.dart';
import 'etebase_parser.dart';

import 'type_refs/type_ref.dart';

class TypeParser {
  const TypeParser();

  TypeRef parseType({
    required DartType type,
    bool isArray = false,
    required TypedefRef typeDefs,
  }) {
    if (type.isVoid) {
      return TypeRef.void$();
    } else if (type.isDartCoreBool) {
      return TypeRef.bool();
    } else if (type.isDartCoreInt) {
      return TypeRef.int();
    }

    if (type.isPointer) {
      final pointerType = type.asPointer;
      return isArray
          ? _mapPointerArrayType(pointerType, typeDefs)
          : _mapPointerType(pointerType, typeDefs);
    }

    throw UnsupportedError('$type is missing explicit type handling');
  }

  TypeRef _mapPointerType(
    DartType pointerType,
    TypedefRef typeDefs,
  ) {
    if (pointerType.isPointer) {
      return TypeRef.etebaseOutList(pointerType.asPointer.element!.name!);
    }

    final pointerElement = pointerType.element;
    if (pointerElement is ClassElement &&
        pointerElement.name.startsWith('Etebase')) {
      final resolvedElement = typeDefs.elementFor(pointerElement);
      return TypeRef.etebaseClass(resolvedElement.name!);
    }

    switch (pointerElement!.name) {
      case 'Char':
        return TypeRef.string();
      case 'Int64': // is always a date time in etebase context
        return TypeRef.dateTime();
      default:
        throw UnsupportedError(
          '$pointerType is missing explicit type handling',
        );
    }
  }

  TypeRef _mapPointerArrayType(
    DartType pointerType,
    TypedefRef typeDefs,
  ) {
    switch (pointerType.element!.name) {
      case 'Void':
        return TypeRef.byteArray();
      case 'String':
        return TypeRef.stringList();
      default:
        throw UnsupportedError(
          '$pointerType is missing explicit type handling',
        );
    }
  }
}
