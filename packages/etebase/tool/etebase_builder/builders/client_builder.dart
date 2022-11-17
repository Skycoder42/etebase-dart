import 'package:code_builder/code_builder.dart';

import '../parsers/class_parser.dart';
import '../parsers/etebase_parser.dart';
import '../parsers/method_parser.dart';

class ClientBuilder {
  const ClientBuilder();

  Library build(EtebaseRef etebase) => Library(
        (b) => b
          ..body.addAll(etebase.functions.map(_buildMethod))
          ..body.addAll(etebase.classes.map(_buildClass))
          ..body.add(_buildUtilsClass(etebase)),
      );

  Class _buildClass(ClassRef clazz) => Class(
        (b) => b
          ..name = clazz.name
          ..fields.add(
            Field(
              (b) => b
                ..name = '_pointer'
                ..type = TypeReference(
                  (b) => b
                    ..symbol = 'Pointer'
                    ..types.add(
                      TypeReference(
                        (b) => b
                          ..symbol = clazz.name
                          ..url = 'libetebase.ffi.dart',
                      ),
                    )
                    ..url = 'dart:ffi',
                )
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
                      ..name = '_pointer'
                      ..toThis = true,
                  ),
                ),
            ),
          )
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
}
