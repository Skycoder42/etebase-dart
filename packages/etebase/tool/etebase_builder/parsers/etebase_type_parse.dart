import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';

class EtebaseTypeParser {
  const EtebaseTypeParser();

  Reference parseType(DartType type, {bool isArray = false}) {
    if (type.isVoid) {
      return TypeReference((b) => b..symbol = 'void');
    }

    if (type is! InterfaceType) {
      return type.typeReference;
    }

    if (type.isPointer) {
      final pointerType = type.typeArguments.single;
      return isArray
          ? _mapPointerArrayType(pointerType)
          : _mapPointerType(pointerType);
    }

    return type.typeReference;
  }

  Reference _mapPointerType(DartType pointerType) {
    if (pointerType is InterfaceType && pointerType.isPointer) {
      return TypeReference((b) => b..symbol = 'dynamic');
    }

    switch (pointerType.element!.name) {
      case 'Char':
        return TypeReference((b) => b..symbol = 'String');
      case 'Int64':
        return TypeReference((b) => b..symbol = 'int');
      default:
        return pointerType.typeReference;
    }
  }

  Reference _mapPointerArrayType(DartType pointerType) {
    switch (pointerType.element!.name) {
      case 'Void':
        return TypeReference((b) => b..symbol = 'Uint8List');
      default:
        return TypeReference(
          (b) => b
            ..symbol = 'List'
            ..types.add(parseType(pointerType)),
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
