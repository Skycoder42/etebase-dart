import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import 'isolate_in_param_builder.dart';

class IsolateImplementationBuilder {
  final IsolateInParamBuilder _isolateInParamBuilder;

  const IsolateImplementationBuilder([
    this._isolateInParamBuilder = const IsolateInParamBuilder(),
  ]);

  Code build(MethodRef method) => Block.of([
        ..._isolateInParamBuilder.buildInParameters(method),
        TypeReference((b) => b..symbol = 'UnimplementedError')
            .newInstance([])
            .thrown
            .statement,
      ]);
}
