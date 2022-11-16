import 'package:code_builder/code_builder.dart';

import '../parsers/class_parser.dart';
import '../parsers/etebase_parser.dart';
import '../parsers/method_parser.dart';

class ClientBuilder {
  const ClientBuilder();

  Library build(EtebaseRef etebase) => Library(
        (b) => b
          ..body.addAll(etebase.classes.map(_buildClass))
          ..body.add(_buildUtilsClass(etebase))
          ..body.add(_buildEtebaseError()),
      );

  Class _buildClass(ClassRef clazz) => Class(
        (b) => b
          ..name = clazz.name
          ..methods.addAll(
            clazz.methods
                .where((method) => !method.isDestroy)
                .where((method) => !method.isPubkeySize)
                .where((method) => !method.isGetLength)
                .map(_buildMethod),
          ),
      );

  Class _buildUtilsClass(EtebaseRef etebase) => Class(
        (b) => b
          ..name = 'EtebaseUtils'
          ..abstract = true
          ..constructors.add(Constructor((b) => b..name = '_'))
          ..methods.addAll(etebase.utilsFunctions.map(_buildMethod)),
      );

  Method _buildMethod(MethodRef method) => Method(
        (b) {
          b
            ..name = method.isNew ? 'create' : method.name
            ..static = method.isStatic
            ..modifier = MethodModifier.async
            ..returns = TypeReference(
              (b) => b
                ..symbol = 'Future'
                ..types.add(_buildReturnType(method)),
            )
            ..requiredParameters.addAll(
              method.parameters
                  .where((param) => !param.isThisParam)
                  .where((param) => !param.isListLength)
                  .where((param) => !param.isRetSize)
                  .where((param) => !param.isOutParam)
                  .map(_buildParameter),
            )
            ..body = TypeReference((b) => b..symbol = 'UnimplementedError')
                .newInstance(const [])
                .thrown
                .code;
          final docComment = method.element.documentationComment;
          if (docComment != null) {
            b.docs.add('\n$docComment');
          }
        },
      );

  Parameter _buildParameter(
    ParameterRef param,
  ) =>
      Parameter(
        (b) => b
          ..name = param.name
          ..type = param.type.dartType,
      );

  TypeReference _buildReturnType(MethodRef method) {
    final returnType = method.outOrReturnType.dartType;
    if (!method.hasOutParam && returnType.symbol == 'int') {
      return TypeReference((b) => b..symbol = 'void');
    }

    return returnType;
  }

  Class _buildEtebaseError() => Class(
        (b) => b
          ..name = 'EtebaseException'
          ..implements.add(TypeReference((b) => b..symbol = 'Exception'))
          ..fields.add(
            Field(
              (b) => b
                ..name = 'code'
                ..type = TypeReference(
                  (b) => b
                    ..symbol = 'EtebaseErrorCode'
                    ..url = '../../src/model/etebase_error_code.dart',
                )
                ..modifier = FieldModifier.final$,
            ),
          )
          ..fields.add(
            Field(
              (b) => b
                ..name = 'message'
                ..type = TypeReference((b) => b..symbol = 'String')
                ..modifier = FieldModifier.final$,
            ),
          )
          ..constructors.add(
            Constructor(
              (b) => b
                ..name = '_'
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = 'code'
                      ..toThis = true,
                  ),
                )
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = 'message'
                      ..toThis = true,
                  ),
                ),
            ),
          )
          ..methods.add(
            Method(
              (b) => b
                ..name = 'toString'
                ..annotations.add(const Reference('override'))
                ..returns = TypeReference((b) => b..symbol = 'String')
                ..body =
                    literalString(r'EtebaseError(${code.name}): $message').code,
            ),
          ),
      );
}
