import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/types.dart';
import 'client_method_body_builder.dart';

class ClientMethodBuilder {
  static const _sizeHintName = 'sizeHint';
  static const sizeHintRef = Reference(_sizeHintName);

  static const _docsMap = {
    'etebase_client_new': '/// Creates a new etebase client.',
    'etebase_client_set_server_url': '/// Sets the server URL of the client.',
  };

  final ClientMethodBodyBuilder _clientMethodBodyBuilder;

  const ClientMethodBuilder([
    this._clientMethodBodyBuilder = const ClientMethodBodyBuilder(),
  ]);

  Method buildMethod(
    MethodRef method, {
    bool global = false,
    bool isUtil = false,
  }) =>
      Method(
        (b) {
          if ((method.isNew && !method.isClientNew) || isUtil) {
            b.requiredParameters.add(
              Parameter(
                (b) => b
                  ..name = 'client'
                  ..type = TypeReference((b) => b..symbol = 'EtebaseClient'),
              ),
            );
          }

          b
            ..name = _getMethodName(method)
            ..static = method.isStatic || method.isDestroy
            ..modifier = _isAsync(method, global) ? MethodModifier.async : null
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
            ..body = _clientMethodBodyBuilder.buildBody(method, global: global);

          final docComment = method.documentation ?? _docsMap[method.ffiName];
          if (docComment != null && !method.isDestroy) {
            b.docs.add('\n$docComment');
          }
        },
      );

  bool _isAsync(MethodRef method, bool global) {
    final type = method.outOrReturnType;
    return global ||
        method.isClientDestroy ||
        (type is EtebaseClassTypeRef && !type.dataClass) ||
        type is EtebaseClassListTypeRef ||
        type is ByteArrayTypeRef;
  }

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
              ? Types.destroyReference(param.type.ffiType.types.single)
              : (param.isOptional
                  ? param.type.publicType.asNullable
                  : param.type.publicType),
      );

  TypeReference _buildReturnType(MethodRef method) {
    final returnType = method.outOrReturnType.publicType;
    return returnType;
  }
}
