import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/type_ref.dart';
import 'isolate_in_param_builder.dart';
import 'isolate_out_param_builder.dart';

class IsolateImplementationBuilder {
  final IsolateInParamBuilder _isolateInParamBuilder;
  final IsolateOutParamBuilder _isolateOutParamBuilder;

  const IsolateImplementationBuilder([
    this._isolateInParamBuilder = const IsolateInParamBuilder(),
    this._isolateOutParamBuilder = const IsolateOutParamBuilder(),
  ]);

  Code build(MethodRef method) => Block.of([
        ..._isolateInParamBuilder.buildInParameters(method),
        ..._isolateOutParamBuilder.buildOutParameters(method),
        _buildInvocation(method).statement,
        TypeReference((b) => b..symbol = 'UnimplementedError')
            .newInstance([])
            .thrown
            .statement,
      ]);

  Expression _buildInvocation(MethodRef method) {
    if (method.isGetter) {
      return refer('libEtebase').property(method.ffiName);
    }

    return refer('libEtebase').property(method.ffiName).call(
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
}
