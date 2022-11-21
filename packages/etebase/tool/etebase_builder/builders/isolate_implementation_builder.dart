import 'package:code_builder/code_builder.dart';

import '../parsers/method_parser.dart';
import '../util/expression_extensions.dart';

class IsolateImplementationBuilder {
  const IsolateImplementationBuilder();

  Code build(MethodRef method) => Block.of([
        ..._buildParameters(method),
        TypeReference((b) => b..symbol = 'UnimplementedError')
            .newInstance([])
            .thrown
            .statement,
      ]);

  Iterable<Code> _buildParameters(MethodRef method) sync* {
    final paramLength = method.exportedParams.length;

    yield refer('invocation')
        .property('length')
        .equalTo(literalNum(paramLength))
        .asserted('Invocation must have exactly $paramLength parameters')
        .statement;

    for (final parameter in method.parameters) {}
  }
}
