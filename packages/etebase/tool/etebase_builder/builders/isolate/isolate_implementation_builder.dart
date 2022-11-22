import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../util/expression_extensions.dart';
import '../../util/types.dart';

class IsolateImplementationBuilder {
  static const _alloc = Reference('alloc');

  const IsolateImplementationBuilder();

  Code build(MethodRef method) => Block.of([
        ..._buildParameters(method),
        TypeReference((b) => b..symbol = 'UnimplementedError')
            .newInstance([])
            .thrown
            .statement,
      ]);

  Iterable<Code> _buildParameters(MethodRef method) sync* {
    final params = method.exportedParams(withThis: true).toList();
    final paramsLength = params.length;
    final arguments = refer('invocation').property('arguments');
    yield arguments
        .property('length')
        .equalTo(literalNum(paramsLength))
        .asserted('Invocation must have exactly $paramsLength arguments')
        .statement;

    // for (var argumentIndex = 0; argumentIndex < paramsLength; ++argumentIndex) {
    //   final parameter = params[argumentIndex];
    //   final variable = declareFinal(parameter.name);
    //   final argument = arguments
    //       .index(literalNum(argumentIndex))
    //       .asA(parameter.type.transferType);
    // }

    var argumentIndex = 0;
    for (final parameter in method.parameters) {
      final variable = declareFinal(parameter.name);

      if (parameter.isOutParam) {
        yield variable.assign(literalNull).statement;
        continue;
      }

      if (parameter.isRetSize) {
        yield variable.assign(literalNull).statement;
        continue;
      }

      final argument = arguments
          .index(literalNum(argumentIndex++))
          .asA(parameter.type.transferType);
      if (parameter.isList) {
        yield* _buildListParam(parameter, variable, argument);
        continue;
      }

      if (parameter.type.isPointer) {
        yield variable
            .assign(
              parameter.type.ffiType
                  .newInstanceNamed('fromAddress', [argument]),
            )
            .statement;
        continue;
      }

      yield variable.assign(argument).statement;
    }
  }

  Iterable<Code> _buildListParam(
    ParameterRef parameter,
    Expression variable,
    Expression argument,
  ) sync* {
    yield declareFinal('${parameter.name}_size')
        .assign(
          argument.property('length'),
        )
        .statement;

    final isUint8List = parameter.type.transferType == Types.Uint8List$;
    final isStringList =
        parameter.type.transferType == Types.list(Types.String$);

    final Reference rawListType;
    if (isUint8List) {
      rawListType = Types.Uint8$;
    } else {
      // assume pointer list -> nested pointer value
      rawListType = parameter.type.ffiType.types.single;
    }

    final allocation = _alloc.call(
      [refer('${parameter.name}_size')],
      const {},
      [rawListType],
    );
    yield variable.assign(allocation).statement;

    if (isUint8List) {
      yield refer(parameter.name)
          .property('asTypedList')
          .call([refer('${parameter.name}_size')])
          .property('setAll')
          .call([literalNum(0), argument])
          .statement;
    } else {
      final Expression mappedAddresses;
      if (isStringList) {
        mappedAddresses = argument.property('map').call([
          Method(
            (b) => b
              ..requiredParameters.add(Parameter((b) => b..name = 'e'))
              ..body = refer('e')
                  .property('toNativeUtf8')
                  .call(const [], const {'allocator': _alloc})
                  .property('cast')
                  .call(const [], const {}, [Types.Char$])
                  .code,
          ).closure
        ]);
      } else {
        mappedAddresses = argument
            .property('map')
            .call([rawListType.property('fromAddress')]);
      }

      yield mappedAddresses.property('forEachIndexed').call([
        Method(
          (b) => b
            ..requiredParameters.addAll([
              Parameter((b) => b..name = 'i'),
              Parameter((b) => b..name = 'e'),
            ])
            ..body =
                refer(parameter.name).index(refer('i')).assign(refer('e')).code,
        ).closure,
      ]).statement;
    }
  }
}
