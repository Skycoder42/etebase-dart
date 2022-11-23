import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/types.dart';
import 'client_method_body_builder.dart';

class ClientMethodBuilder {
  final ClientMethodBodyBuilder _clientMethodBodyBuilder;

  const ClientMethodBuilder([
    this._clientMethodBodyBuilder = const ClientMethodBodyBuilder(),
  ]);

  Method buildMethod(MethodRef method, {bool global = false}) => Method(
        (b) {
          b
            ..name = _findMethodName(method)
            ..static = method.isStatic || method.isDestroy
            ..type = method.isGetter ? MethodType.getter : null
            ..modifier =
                _isAsync(method.outOrReturnType) ? MethodModifier.async : null
            ..returns = Types.future(_buildReturnType(method))
            ..requiredParameters.addAll(
              method
                  .exportedParams(withThis: false)
                  .where((param) => !param.isOptional)
                  .map(
                    (param) => Parameter(
                      (b) => b
                        ..name = param.name
                        ..type = method.isDestroy && param.isThisParam
                            ? param.type.ffiType
                            : param.type.publicType,
                    ),
                  )
                  .toList(),
            )
            ..optionalParameters.addAll(
              method
                  .exportedParams(withThis: false)
                  .where((param) => param.isOptional)
                  .map(
                    (param) => Parameter(
                      (b) => b
                        ..name = param.name
                        ..type = param.type.publicType,
                    ),
                  )
                  .toList(),
            )
            ..body = _clientMethodBodyBuilder.buildBody(method);

          final docComment = method.documentation;
          if (docComment != null && !method.isDestroy) {
            b.docs.add('\n$docComment');
          }
        },
      );

  bool _isAsync(TypeRef type) =>
      type is EtebaseClassTypeRef ||
      type is EtebaseClassListTypeRef ||
      type is ByteArrayTypeRef;

  String _findMethodName(MethodRef method) {
    if (method.isNew) {
      return 'create';
    } else if (method.isDestroy) {
      return '_destroy';
    } else {
      return method.name;
    }
  }

  TypeReference _buildReturnType(MethodRef method) {
    final returnType = method.outOrReturnType.publicType;
    return returnType;
  }
}