import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../util/expression_extensions.dart';
import '../../util/types.dart';

class IsolateImplementationBuilder {
  static const _malloc = Reference('malloc', 'package:ffi/ffi.dart');

  const IsolateImplementationBuilder();

  Code build(MethodRef method) => Block.of([
        ..._buildParameters(method),
        TypeReference((b) => b..symbol = 'UnimplementedError')
            .newInstance([])
            .thrown
            .statement,
      ]);

  Iterable<Code> _buildParameters(MethodRef method) sync* {
    final paramLength = method.exportedParams(withThis: true).length;
    final arguments = refer('invocation').property('arguments');

    if (paramLength == 0) {
      yield arguments
          .property('isEmpty')
          .asserted('Invocation must not have any arguments')
          .statement;
    } else {
      yield arguments
          .property('length')
          .equalTo(literalNum(paramLength))
          .asserted('Invocation must have exactly $paramLength arguments')
          .statement;
    }

    final autoFree = <String>[]; // TODO use

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
        yield* _buildListParam(parameter, variable, argument, autoFree);
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
    List<String> autoFree,
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

    final allocation = _malloc.call(
      [refer('${parameter.name}_size')],
      const {},
      [rawListType],
    );
    yield variable.assign(allocation).statement;
    autoFree.add(parameter.name);

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
                  .call(const [], const {'allocator': _malloc})
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
