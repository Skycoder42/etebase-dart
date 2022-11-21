import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../util/types.dart';
import 'client_method_body_builder.dart';

class ClientMethodBuilder {
  final ClientMethodBodyBuilder _clientMethodBodyBuilder;

  const ClientMethodBuilder([
    this._clientMethodBodyBuilder = const ClientMethodBodyBuilder(),
  ]);

  Method buildMethod(MethodRef method, {bool global = false}) => Method(
        (b) {
          final parameters = method
              .exportedParams(withThis: false)
              .map(_buildParameter)
              .toList();

          b
            ..name = _findMethodName(method)
            ..static = method.isStatic || method.isDestroy
            ..type = method.isGetter ? MethodType.getter : null
            ..modifier = method.outOrReturnType.pointerKind.isPointer
                ? MethodModifier.async
                : null
            ..returns = Types.future(_buildReturnType(method))
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
              ? Types.pointer(Types.ffi(param.type.publicType)) // TODO
              : param.type.publicType,
      );

  TypeReference _buildReturnType(MethodRef method) {
    final returnType = method.outOrReturnType.publicType;
    // TODO
    if (!method.hasOutParam && !method.isGetter && returnType.symbol == 'int') {
      return Types.void$;
    }

    return returnType;
  }
}
