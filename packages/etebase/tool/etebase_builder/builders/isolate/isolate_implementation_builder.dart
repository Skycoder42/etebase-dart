import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/types.dart';
import 'isolate_in_param_builder.dart';
import 'isolate_out_param_builder.dart';
import 'isolate_return_builder.dart';

class IsolateImplementationBuilder {
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
          ..._buildNeedsSizeInvocation(method)
        else
          ..._isolateReturnBuilder.buildReturn(method),
      ]);

  Code _buildInvocation(MethodRef method) {
    var expression = refer('libEtebase').property(method.ffiName);

    if (!method.isGetter) {
      expression = expression.call(
        method.parameters.expand(
          (parameter) => [
            if (parameter.type is ByteArrayTypeRef)
              refer(parameter.name).property('cast').call(const [])
            else
              refer(parameter.name),
            if (parameter.hasLength) refer('${parameter.name}_size'),
          ],
        ),
      );
    }

    if (method.returnType is VoidTypeRef) {
      return expression.statement;
    } else {
      return declareFinal('result').assign(expression).statement;
    }
  }

  Iterable<Code> _buildNeedsSizeInvocation(MethodRef method) sync* {
    final resultRef = refer('result');

    yield _isolateReturnBuilder
        .checkIntSuccess(resultRef)
        .elseIf$(resultRef.lessOrEqualTo(refer('buf_size')), [
      _isolateReturnBuilder.buildReturnByteArray(method, resultRef),
    ]).elseIf$(refer('reinvokedWithSize').notEqualTo(literalNull), [
      Types.MethodResult$.newInstanceNamed('failure', [
        refer('invocation').property('id'),
        Types.EtebaseErrorCode$.property('generic'),
        literalString(
          'output size of ${method.ffiName} changed during invocation',
        ),
      ]).returned.statement,
    ]).else$([
      refer('_${method.ffiName}')
          .call(
            [refer('libEtebase'), refer('invocation'), refer('arena')],
            {'reinvokedWithSize': resultRef},
          )
          .returned
          .statement,
    ]);
  }
}
