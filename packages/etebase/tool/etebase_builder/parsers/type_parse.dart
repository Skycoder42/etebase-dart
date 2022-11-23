import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../util/dart_type_extensions.dart';
import 'etebase_parser.dart';

import 'type_ref.dart';

class TypeParser {
  const TypeParser();

  TypeRef parseType({
    required DartType type,
    bool isArray = false,
    bool asReturn = false,
    bool isOptional = false,
    required TypedefRef typeDefs,
  }) {
    if (type.isVoid) {
      return TypeRef.void$();
    } else if (type.isDartCoreBool) {
      return TypeRef.bool();
    } else if (type.isDartCoreInt) {
      return TypeRef.int(asReturn);
    }

    if (type.isPointer) {
      final pointerType = type.asPointer;
      return isArray
          ? _mapPointerArrayType(pointerType, isOptional, typeDefs)
          : _mapPointerType(pointerType, isOptional, typeDefs);
    }

    throw UnsupportedError('$type is missing explicit type handling');
  }

  TypeRef _mapPointerType(
    DartType pointerType,
    bool isOptional,
    TypedefRef typeDefs,
  ) {
    if (pointerType.isPointer) {
      return TypeRef.etebaseOutList(pointerType.asPointer.element!.name!);
    }

    final pointerElement = pointerType.element;
    if (pointerElement is ClassElement &&
        pointerElement.name.startsWith('Etebase')) {
      final resolvedElement = typeDefs.elementFor(pointerElement);
      return TypeRef.etebaseClass(resolvedElement.name!, optional: isOptional);
    }

    switch (pointerElement!.name) {
      case 'Char':
        return TypeRef.string();
      case 'UnsignedLong':
        return TypeRef.returnSize();
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
    bool isOptional,
    TypedefRef typeDefs,
  ) {
    final typeName = pointerType.element!.name!;
    if (typeName == 'Void') {
      return TypeRef.byteArray(optional: isOptional);
    }

    if (pointerType.isPointer) {
      final innerPointerTypeName = pointerType.asPointer.element!.name!;
      if (innerPointerTypeName == 'Char') {
        return TypeRef.stringList();
      } else if (innerPointerTypeName.startsWith('Etebase')) {
        return TypeRef.etebaseClassList(innerPointerTypeName);
      }
    }

    throw UnsupportedError(
      '$pointerType is missing explicit type handling',
    );
  }
}
