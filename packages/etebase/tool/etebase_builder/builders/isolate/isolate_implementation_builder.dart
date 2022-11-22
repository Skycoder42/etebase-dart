import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../parsers/type_ref.dart';
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

    for (var argumentIndex = 0; argumentIndex < paramsLength; ++argumentIndex) {
      final param = params[argumentIndex];
      final paramType = param.type;
      final variable = declareFinal(param.name);
      final argument = arguments
          .index(literalNum(argumentIndex))
          .asA(param.type.transferType);

      if (paramType is StringTypeRef) {
        yield* _buildStringParam(param, paramType, variable, argument);
      } else if (paramType is DateTimeTypeRef) {
        yield* _buildDateTimeParam(param, paramType, variable, argument);
      } else if (paramType is StringListTypeRef) {
        yield* _buildStringListParam(param, paramType, variable, argument);
      } else if (paramType is ByteArrayTypeRef) {
        yield* _buildByteArrayParam(param, paramType, variable, argument);
      } else if (paramType is EnumTypeRef) {
        yield* _buildEnumParam(param, paramType, variable, argument);
      } else if (paramType is EtebaseClassTypeRef) {
        yield* _buildClassParam(param, paramType, variable, argument);
      } else {
        yield variable.assign(argument).statement;
      }
    }

    // var argumentIndex = 0;
    // for (final parameter in method.parameters) {
    //   final variable = declareFinal(parameter.name);

    //   if (parameter.isOutParam) {
    //     yield variable.assign(literalNull).statement;
    //     continue;
    //   }

    //   if (parameter.isRetSize) {
    //     yield variable.assign(literalNull).statement;
    //     continue;
    //   }

    //   final argument = arguments
    //       .index(literalNum(argumentIndex++))
    //       .asA(parameter.type.transferType);
    //   if (parameter.isList) {
    //     yield* _buildListParam(parameter, variable, argument);
    //     continue;
    //   }

    //   if (parameter.type.isPointer) {
    //     yield variable
    //         .assign(
    //           parameter.type.ffiType
    //               .newInstanceNamed('fromAddress', [argument]),
    //         )
    //         .statement;
    //     continue;
    //   }

    //   yield variable.assign(argument).statement;
    // }
  }

  Iterable<Code> _buildStringParam(
    ParameterRef parameter,
    StringTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    yield variable.assign(_stringToPointer(argument)).statement;
  }

  Iterable<Code> _buildDateTimeParam(
    ParameterRef parameter,
    DateTimeTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    yield variable
        .assign(_alloc.call(const [], const {}, [Types.Int64$]))
        .cascade('value')
        .assign(argument.property('millisecondsSinceEpoch'))
        .statement;
  }

  Iterable<Code> _buildStringListParam(
    ParameterRef parameter,
    StringListTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    yield* _buildListAllocation(
      parameter,
      variable,
      argument,
      Types.pointer(Types.Char$),
    );

    yield _assignPointerArray(
      refer(parameter.name),
      argument.property('map').call([
        Method(
          (b) => b
            ..requiredParameters.add(Parameter((b) => b..name = 'e'))
            ..body = _stringToPointer(refer('e')).code,
        ).closure
      ]),
    ).statement;
  }

  Iterable<Code> _buildByteArrayParam(
    ParameterRef parameter,
    ByteArrayTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    yield* _buildListAllocation(
      parameter,
      variable,
      argument,
      Types.Uint8$,
    );

    yield refer(parameter.name)
        .property('asTypedList')
        .call([refer('${parameter.name}_size')])
        .property('setAll')
        .call([literalNum(0), argument])
        .statement;
  }

  Iterable<Code> _buildEnumParam(
    ParameterRef parameter,
    EnumTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    yield variable.assign(argument.property('index')).statement;
  }

  Iterable<Code> _buildClassParam(
    ParameterRef parameter,
    EtebaseClassTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    yield variable
        .assign(
          parameterType.ffiType.newInstanceNamed(
            'fromAddress',
            [argument],
          ),
        )
        .statement;
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

  Expression _stringToPointer(Expression variable) => variable
      .property('toNativeUtf8')
      .call(const [], const {'allocator': _alloc})
      .property('cast')
      .call(const [], const {}, [Types.Char$]);

  Iterable<Code> _buildListAllocation(
    ParameterRef parameter,
    Expression variable,
    Expression argument,
    TypeReference pointerType,
  ) sync* {
    final sizeVariableName = '${parameter.name}_size';
    final sizeVariable = refer(sizeVariableName);
    yield declareFinal(sizeVariableName)
        .assign(argument.property('length'))
        .statement;

    yield variable
        .assign(_alloc.call([sizeVariable], const {}, [pointerType]))
        .statement;
  }

  Expression _assignPointerArray(Expression variable, Expression argument) =>
      argument.property('forEachIndexed').call([
        Method(
          (b) => b
            ..requiredParameters.addAll([
              Parameter((b) => b..name = 'i'),
              Parameter((b) => b..name = 'e'),
            ])
            ..body = variable.index(refer('i')).assign(refer('e')).code,
        ).closure,
      ]);
}
