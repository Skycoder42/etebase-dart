import 'package:code_builder/code_builder.dart';

import '../parsers/method_parser.dart';
import '../parsers/param_parser.dart';
import '../util/type_reference_extensions.dart';
import 'client_method_body_builder.dart';

class ClientMethodBuilder {
  final ClientMethodBodyBuilder _clientMethodBodyBuilder;

  const ClientMethodBuilder([
    this._clientMethodBodyBuilder = const ClientMethodBodyBuilder(),
  ]);

  Method buildMethod(MethodRef method, {bool global = false}) => Method(
        (b) {
          final parameters =
              method.exportedParams.map(_buildParameter).toList();

          b
            ..name = _findMethodName(method)
            ..static = method.isStatic || method.isDestroy
            ..type = method.isGetter ? MethodType.getter : null
            ..modifier = method.outOrReturnType.pointerKind.isPointer
                ? MethodModifier.async
                : null
            ..returns = TypeReference(
              (b) => b
                ..symbol = 'Future'
                ..types.add(_buildReturnType(method)),
            )
            ..requiredParameters.addAll(parameters)
            ..body = _clientMethodBodyBuilder.buildBody(method);

          final docComment = method.element.documentationComment;
          if (docComment != null) {
            b.docs.add('\n$docComment');
          }
        },
      );

  String _findMethodName(MethodRef method) {
    if (method.isNew) {
      return 'create';
    } else if (method.isDestroy) {
      return '_destroy';
    } else {
      return method.name;
    }
  }

  Parameter _buildParameter(
    ParameterRef param,
  ) =>
      Parameter(
        (b) => b
          ..name = param.name
          ..type = param.isThisParam
              ? TypeReference(
                  (b) => b
                    ..replace(param.type.dartType)
                    ..url = 'libetebase.ffi.dart',
                ).asPointer
              : param.type.dartType,
      );

  TypeReference _buildReturnType(MethodRef method) {
    final returnType = method.outOrReturnType.dartType;
    if (!method.hasOutParam && !method.isGetter && returnType.symbol == 'int') {
      return TypeReference((b) => b..symbol = 'void');
    }

    return returnType;
  }
}
