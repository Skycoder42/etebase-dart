import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/type_ref.dart';
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
}
