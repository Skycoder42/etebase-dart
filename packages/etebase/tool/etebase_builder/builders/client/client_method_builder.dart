import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/types.dart';
import 'client_method_body_builder.dart';

class ClientMethodBuilder {
  static const _sizeHintName = 'sizeHint';
  static const sizeHintRef = Reference(_sizeHintName);

  final ClientMethodBodyBuilder _clientMethodBodyBuilder;

  const ClientMethodBuilder([
    this._clientMethodBodyBuilder = const ClientMethodBodyBuilder(),
  ]);

  Method buildMethod(MethodRef method, {bool global = false}) => Method(
        (b) {
          b
            ..name = _getMethodName(method)
            ..static = method.isStatic || method.isDestroy
            ..modifier =
                _isAsync(method.outOrReturnType) ? MethodModifier.async : null
            ..returns = Types.future(_buildReturnType(method))
            ..requiredParameters.addAll(
              method
                  .exportedParams(withThis: false)
                  .where((p) => !p.isOptional)
                  .map((p) => _buildParam(p, isDestroy: method.isDestroy))
                  .toList(),
            )
            ..optionalParameters.addAll([
              if (method.needsSizeHint)
                Parameter(
                  (b) => b
                    ..name = _sizeHintName
                    ..type = Types.int$.asNullable,
                ),
              ...method
                  .exportedParams(withThis: false)
                  .where((p) => p.isOptional)
                  .map(_buildParam),
            ])
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

  String _getMethodName(MethodRef method) {
    if (method.isNew) {
      return 'create';
    } else if (method.isDestroy) {
      return '_destroy';
    } else {
      return method.name;
    }
  }

  Parameter _buildParam(ParameterRef param, {bool isDestroy = false}) =>
      Parameter(
        (b) => b
          ..name = param.name
          ..type = isDestroy && param.isThisParam
              ? param.type.ffiType
              : param.type.publicType,
      );

  TypeReference _buildReturnType(MethodRef method) {
    final returnType = method.outOrReturnType.publicType;
    return returnType;
  }
}
