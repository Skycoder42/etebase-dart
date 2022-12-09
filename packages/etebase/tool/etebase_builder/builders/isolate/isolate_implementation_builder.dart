import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/types.dart';
import 'isolate_builder.dart';
import 'isolate_in_param_builder.dart';
import 'isolate_out_param_builder.dart';
import 'isolate_return_builder.dart';

class IsolateImplementationBuilder {
  static const _resultName = 'result';
  static const resultRef = Reference(_resultName);

  final IsolateInParamBuilder _isolateInParamBuilder;
  final IsolateOutParamBuilder _isolateOutParamBuilder;
  final IsolateReturnBuilder _isolateReturnBuilder;

  const IsolateImplementationBuilder([
    this._isolateInParamBuilder = const IsolateInParamBuilder(),
    this._isolateOutParamBuilder = const IsolateOutParamBuilder(),
    this._isolateReturnBuilder = const IsolateReturnBuilder(),
  ]);

  Code build(MethodRef method) => Block.of([
        ..._isolateInParamBuilder.buildInParameters(method),
        ..._isolateOutParamBuilder.buildOutParameters(method),
        _buildInvocation(method),
        if (method.needsSizeHint)
          _buildNeedsSizeInvocation(method)
        else
          ..._isolateReturnBuilder.buildReturn(method),
      ]);

  Code _buildInvocation(MethodRef method) {
    var expression = IsolateBuilder.libEtebaseRef.property(method.ffiName);
    final expandedParams = method.parameters.expand(
      (parameter) => [
        if (parameter.type is ByteArrayTypeRef)
          refer(parameter.name).property('cast').call(const [])
        else
          refer(parameter.name),
        if (parameter.hasLength) refer(parameter.lengthName()),
      ],
    );

    if (method.isDestroy) {
      return IsolateBuilder.poolRef
          .property('freeGlobal')
          .call(expandedParams)
          .statement;
    }

    expression = expression.call(expandedParams);
    if (method.returnType is VoidTypeRef) {
      return expression.statement;
    } else {
      return declareFinal(_resultName).assign(expression).statement;
    }
  }

  Code _buildNeedsSizeInvocation(MethodRef method) =>
      _isolateReturnBuilder.checkIntSuccess(resultRef).elseIf$(
          resultRef.lessOrEqualTo(refer(method.outParam.lengthName())), [
        _isolateReturnBuilder.buildReturnByteArray(method, resultRef),
      ]).elseIf$(IsolateBuilder.reinvokedWithSizeRef.notEqualTo(literalNull), [
        Types.MethodResult$.newInstanceNamed('failure', [
          IsolateBuilder.invocationRef.property('id'),
          Types.EtebaseErrorCode$.property('generic'),
          literalString(
            'output size of ${method.ffiName} changed during invocation',
          ),
        ]).returned.statement,
      ]).else$([
        refer('_${method.ffiName}')
            .call(
              IsolateBuilder.handlerParams,
              {IsolateBuilder.reinvokedWithSizeRef.symbol!: resultRef},
            )
            .returned
            .statement,
      ]);
}
