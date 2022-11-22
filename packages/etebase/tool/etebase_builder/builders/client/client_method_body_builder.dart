import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/types.dart';

class ClientMethodBodyBuilder {
  const ClientMethodBodyBuilder();

  Code buildBody(MethodRef method) {
    var expression = TypeReference(
      (b) => b
        ..symbol = 'EtebaseIsolate'
        ..url = 'package:etebase/src/isolate/etebase_isolate.dart',
    ).property('current').property('invoke');

    final inParams = method
        .exportedParams(withThis: true)
        .map((param) => _mapCallParam(param, method))
        .toList();

    final returnType = method.outOrReturnType;
    expression = expression.call(
      [
        refer('#${method.ffiName}'),
        if (inParams.isEmpty) literalConstList([]) else literalList(inParams),
      ],
      const {},
      [returnType.transferType],
    );

    if (returnType is EtebaseOutListTypeRef) {
      return _buildOutListMethodBody(expression, returnType);
    }

    if (returnType.isPointer) {
      expression = _fromAddress(returnType.publicType, expression.awaited);
    }

    return expression.code;
  }

  Block _buildOutListMethodBody(
    Expression expression,
    EtebaseOutListTypeRef returnType,
  ) =>
      Block(
        (p) => p
          ..addExpression(
            declareFinal('addressList').assign(expression.awaited),
          )
          ..addExpression(
            refer('addressList')
                .property('map')
                .call([
                  Method(
                    (b) => b
                      ..requiredParameters.add(Parameter((b) => b..name = 'a'))
                      ..body = _fromAddress(
                        returnType.publicInnerType,
                        refer('a'),
                      ).code,
                  ).closure
                ])
                .property('toList')
                .call(const [])
                .returned,
          ),
      );

  Expression _mapCallParam(ParameterRef param, MethodRef method) {
    if (param.isThisParam) {
      final ref = method.isDestroy ? refer(param.name) : refer('_pointer');
      return ref.property('address');
    }

    if (param.type.isPointer) {
      if (param.type.isListType) {
        return refer(param.name)
            .property('map')
            .call([
              Method(
                (b) => b
                  ..requiredParameters.add(Parameter((b) => b..name = 'e'))
                  ..body = _toAddress(refer('e')).code,
              ).closure,
            ])
            .property('toList')
            .call(const []);
      } else {
        return _toAddress(refer(param.name));
      }
    }

    return refer(param.name);
  }

  Expression _toAddress(Reference reference) =>
      reference.property('_pointer').property('address');

  Expression _fromAddress(Reference classType, Expression address) =>
      classType.newInstanceNamed('_', [
        Types.pointer(null).newInstanceNamed(
          'fromAddress',
          [address],
        )
      ]);
}
