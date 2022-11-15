import 'package:code_builder/code_builder.dart';

import '../parsers/class_parser.dart';
import '../parsers/etebase_parser.dart';
import '../parsers/method_parser.dart';

class ClientBuilder {
  const ClientBuilder();

  Library build(EtebaseRef etebase) => Library(
        (b) => b
          ..body.addAll(etebase.classes.map(_buildClass))
          ..body.add(_buildUtilsClass(etebase)),
      );

  Class _buildClass(ClassRef clazz) => Class(
        (b) => b
          ..name = clazz.name
          ..methods.addAll(
            clazz.methods
                .where((method) => !method.isDestroy)
                .where((method) => !method.isPubkeySize)
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
        (b) => b
          ..name = method.isNew ? 'create' : method.name
          ..static = method.isStatic
          ..modifier = MethodModifier.async
          ..returns = TypeReference(
            (b) => b
              ..symbol = 'Future'
              ..types.add(method.returnType.dartType),
          )
          ..requiredParameters.addAll(
            method.parameters
                .where((param) => !param.isThisParam)
                .where((param) => !param.isListLength)
                .where((param) => !param.isRetSize)
                .map(_buildParameter),
          )
          ..body = TypeReference((b) => b..symbol = 'UnimplementedError')
              .newInstance(const [])
              .thrown
              .code,
      );

  Parameter _buildParameter(
    ParameterRef param,
  ) =>
      Parameter(
        (b) => b
          ..name = param.name
          ..type = param.type.dartType,
      );
}
