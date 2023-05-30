import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/expression_extensions.dart';
import '../../util/try_catch.dart';
import '../../util/types.dart';
import 'client_class_builder.dart';
import 'client_method_builder.dart';

class ClientMethodBodyBuilder {
  static const _clientIsolateName = 'isolate';
  static const _clientIsolateRef = Reference(_clientIsolateName);

  const ClientMethodBodyBuilder();

  Code buildBody(MethodRef method, {bool global = false}) {
    final isolateRef = _getIsolateRef(method, global);
    var expression = method.isDestroy
        ? isolateRef.property('maybeInvoke')
        : isolateRef.property('invoke');
    final inParams = method
        .exportedParams(withThis: true)
        .map((param) => _mapCallParam(param, method))
        .toList();
    if (method.needsSizeHint) {
      inParams.add(ClientMethodBuilder.sizeHintRef);
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

    if (global) {
      return _buildGlobal(expression, isolateRef);
    } else if (method.isClientNew) {
      return _buildClientNew(expression, returnType, isolateRef);
    } else if (method.isClientDestroy) {
      return _buildClientDestroy(expression, isolateRef);
    } else if (returnType is EtebaseOutListTypeRef) {
      return _buildOutListMethodBody(expression, returnType, isolateRef);
    } else if (returnType is ByteArrayTypeRef) {
      return _buildByteArrayMethodBody(expression, returnType);
    } else if (returnType is EtebaseClassTypeRef && !returnType.dataClass) {
      expression = _fromAddress(
        returnType.publicType,
        expression.awaited,
        isolateRef,
      );
    }

    return expression.code;
  }

  Expression _getIsolateRef(MethodRef method, bool global) {
    if (method.isClientNew || global) {
      return _clientIsolateRef;
    } else if (method.isDestroy) {
      return refer(
        method.parameters.singleWhere((p) => p.isThisParam).name,
      ).property('isolate');
    } else if (method.isNew || method.isStatic) {
      return refer('client').property(ClientClassBuilder.isolateRef.symbol!);
    } else {
      return ClientClassBuilder.isolateRef;
    }
  }

  Expression _mapCallParam(ParameterRef param, MethodRef method) {
    final paramType = param.type;

    if (param.isThisParam) {
      final ref = method.isDestroy
          ? refer(param.name).property('pointer')
          : ClientClassBuilder.pointerRef;
      return ref.property('address');
    } else if (paramType is ByteArrayTypeRef) {
      final expression = Types.TransferableTypedData$.newInstanceNamed(
        'fromList',
        [
          literalList([refer(param.name)])
        ],
      );

      if (param.isOptional) {
        return refer(param.name)
            .equalTo(literalNull)
            .conditional(literalNull, expression);
      } else {
        return expression;
      }
    } else if (paramType is EtebaseClassTypeRef) {
      return paramType.dataClass
          ? refer(param.name)
          : _toAddress(refer(param.name), paramType.publicType);
    } else if (paramType is EtebaseClassListTypeRef) {
      return refer(param.name)
          .property('map')
          .call([
            Method(
              (b) => b
                ..requiredParameters.add(Parameter((b) => b..name = 'e'))
                ..body = _toAddress(refer('e'), paramType.publicType).code,
            ).closure,
          ])
          .property('toList')
          .call(const []);
    } else {
      return refer(param.name);
    }
  }

  Expression _toAddress(Reference reference, TypeReference publicType) =>
      reference
          .nullableProperty(
            ClientClassBuilder.pointerName,
            isNullable: publicType.isNullable ?? false,
          )
          .property('address');

  Expression _fromAddress(
    Reference classType,
    Expression address,
    Expression isolateRef, {
    bool withOwner = false,
  }) =>
      classType.newInstanceNamed('_', [
        isolateRef,
        Types.pointer(null).newInstanceNamed(
          'fromAddress',
          [address],
        ),
        if (withOwner) literalThis,
      ]);

  Code _buildGlobal(
    Expression expression,
    Expression isolateRef,
  ) =>
      Block.of([
        declareFinal(_clientIsolateName)
            .assign(
              Types.EtebaseIsolateReference$.property('create')
                  .call(const []).awaited,
            )
            .statement,
        try$([
          expression.awaited.returned.statement,
        ]).finally$([
          isolateRef.property('dispose').call(const []).awaited.statement,
        ]),
      ]);

  Code _buildClientNew(
    Expression expression,
    TypeRef returnType,
    Expression isolateRef,
  ) =>
      Block.of([
        declareFinal(_clientIsolateName)
            .assign(
              Types.EtebaseIsolateReference$.property('create')
                  .call(const []).awaited,
            )
            .statement,
        _fromAddress(
          returnType.publicType,
          expression.awaited,
          isolateRef,
        ).returned.statement,
      ]);

  Code _buildClientDestroy(
    Expression expression,
    Expression isolateRef,
  ) =>
      Block.of([
        expression.awaited.statement,
        isolateRef.property('dispose').call(const []).awaited.statement,
      ]);

  Code _buildOutListMethodBody(
    Expression expression,
    EtebaseOutListTypeRef returnType,
    Expression isolateRef,
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
                        isolateRef,
                        withOwner: true,
                      ).code,
                  ).closure
                ])
                .property('toList')
                .call(const [])
                .returned,
          ),
      );

  Code _buildByteArrayMethodBody(
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
}
