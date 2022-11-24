import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/expression_extensions.dart';
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
    if (method.needsSizeHint) {
      inParams.add(refer('sizeHint'));
    }

    final returnType = method.outOrReturnType;
    expression = expression.call(
      [
        refer('#${method.ffiName}'),
        if (inParams.isEmpty)
          literalConstList([], Types.dynamic$)
        else
          literalList(inParams, Types.dynamic$),
      ],
      const {},
      [returnType.transferType],
    );

    if (returnType is EtebaseOutListTypeRef) {
      return _buildOutListMethodBody(expression, returnType);
    } else if (returnType is ByteArrayTypeRef) {
      return _buildByteArrayMethodBody(expression, returnType);
    } else if (returnType is EtebaseClassTypeRef) {
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

  Block _buildByteArrayMethodBody(
    Expression expression,
    ByteArrayTypeRef returnType,
  ) =>
      Block(
        (b) => b
          ..addExpression(declareFinal('data').assign(expression.awaited))
          ..addExpression(
            refer('data')
                .property('materialize')
                .call(const [])
                .property('asUint8List')
                .call(const [])
                .returned,
          ),
      );

  Expression _mapCallParam(ParameterRef param, MethodRef method) {
    if (param.isThisParam) {
      final ref = method.isDestroy ? refer(param.name) : refer('_pointer');
      return ref.property('address');
    } else if (param.type is ByteArrayTypeRef) {
      final expression = Types.TransferableTypedData$.newInstanceNamed(
        'fromList',
        [
          literalList([refer(param.name)]),
        ],
      );

      if (param.isOptional) {
        return refer(param.name)
            .equalTo(literalNull)
            .conditional(literalNull, expression);
      } else {
        return expression;
      }
    } else if (param.type is EtebaseClassTypeRef) {
      return _toAddress(refer(param.name), param.type.publicType);
    } else if (param.type is EtebaseClassListTypeRef) {
      return refer(param.name)
          .property('map')
          .call([
            Method(
              (b) => b
                ..requiredParameters.add(Parameter((b) => b..name = 'e'))
                ..body = _toAddress(refer('e'), param.type.publicType).code,
            ).closure,
          ])
          .property('toList')
          .call(const []);
    } else {
      return refer(param.name);
    }
  }

  Expression _toAddress(Reference reference, TypeReference publicType) =>
      (reference.nullableProperty(
        '_pointer',
        isNullable: publicType.isNullable ?? false,
      )).property('address');

  Expression _fromAddress(Reference classType, Expression address) =>
      classType.newInstanceNamed('_', [
        Types.pointer(null).newInstanceNamed(
          'fromAddress',
          [address],
        )
      ]);
}
