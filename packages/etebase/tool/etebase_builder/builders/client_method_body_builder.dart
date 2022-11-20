import 'package:code_builder/code_builder.dart';

import '../parsers/method_parser.dart';
import '../parsers/param_parser.dart';
import '../parsers/type_parse.dart';

class ClientMethodBodyBuilder {
  const ClientMethodBodyBuilder();

  Code buildBody(MethodRef method) {
    var expression = TypeReference(
      (b) => b
        ..symbol = 'EtebaseIsolate'
        ..url = '../../src/isolate/etebase_isolate.dart',
    ).property('current').property('invoke');

    final inParams = method.parameters
        .where((param) => !param.isListLength)
        .where((param) => !param.isRetSize)
        .where((param) => !param.isOutParam)
        .map((param) => _mapCallParam(param, method))
        .toList();

    final returnType = method.outOrReturnType;
    final isPointerList = returnType.pointerKind.isPointer &&
        returnType.dartType.symbol == 'List';

    expression = expression.call([
      refer('#${method.element.name}'),
      if (inParams.isEmpty) literalConstList([]) else literalList(inParams),
    ], const {}, [
      if (isPointerList)
        TypeReference(
          (b) => b
            ..symbol = 'List'
            ..types.add(TypeReference((b) => b..symbol = 'int')),
        )
    ]);

    if (isPointerList) {
      return _buildListMethodBody(expression, returnType);
    }

    if (returnType.pointerKind.isPointer) {
      expression = _fromAddress(returnType.dartType, expression.awaited);
    }

    return expression.code;
  }

  Block _buildListMethodBody(Expression expression, TypeRef returnType) =>
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
                      ..requiredParameters
                          .add(Parameter((b) => b..name = 'address'))
                      ..body = _fromAddress(
                        returnType.dartType.types.single,
                        refer('address'),
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

    if (param.type.pointerKind.isPointer) {
      if (param.isList) {
        return refer(param.name)
            .property('map')
            .call([
              Method(
                (b) => b
                  ..requiredParameters.add(
                    Parameter((b) => b..name = 'element'),
                  )
                  ..body = _toAddress(refer('element')).code,
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
        TypeReference(
          (b) => b
            ..symbol = 'Pointer'
            ..url = 'dart:ffi',
        ).newInstanceNamed(
          'fromAddress',
          [address],
        )
      ]);
}
