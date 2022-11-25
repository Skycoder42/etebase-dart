import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/expression_extensions.dart';
import '../../util/if_then.dart';
import '../../util/types.dart';

class IsolateInParamBuilder {
  static const _arena = Reference('arena');
  static const _nullptrRef = Reference('nullptr', 'dart:ffi');

  const IsolateInParamBuilder();

  Iterable<Code> buildInParameters(MethodRef method) sync* {
    final params = method.exportedParams(withThis: true).toList();
    final paramsLength = params.length;
    final assertLength = method.needsSizeHint ? paramsLength + 1 : paramsLength;
    final arguments = refer('invocation').property('arguments');
    yield arguments
        .property('length')
        .equalTo(literalNum(assertLength))
        .asserted('Invocation must have exactly $assertLength arguments');

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
      } else if (paramType is EtebaseClassListTypeRef) {
        yield* _buildClassListParam(param, paramType, variable, argument);
      } else {
        yield variable.assign(argument).statement;
      }
    }

    if (method.needsSizeHint) {
      final paramName = method.parameters
          .where((p) => p.needsSizeHint)
          .map((p) => p.name)
          .single;

      yield declareFinal('${paramName}_size')
          .assign(refer('reinvokedWithSize'))
          .ifNullThen(
            arguments
                .index(literalNum(paramsLength))
                .asA(Types.int$.asNullable),
          )
          .ifNullThen(literalNum(1024)) // TODO global constant/param
          .statement;
    }
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
        .assign(_arena.call(const [], const {}, [Types.Int64$]))
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
      false,
    );

    yield _assignPointerArray(
      parameter.name,
      argument,
      Method(
        (b) => b
          ..requiredParameters.add(Parameter((b) => b..name = 's'))
          ..body = _stringToPointer(refer('s')).code,
      ).closure,
    ).statement;
  }

  Iterable<Code> _buildByteArrayParam(
    ParameterRef parameter,
    ByteArrayTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    final bufferName = '${parameter.name}_buffer';
    final bufferRef = refer(bufferName);
    final isNullable = parameterType.transferType.isNullable ?? false;
    yield declareFinal(bufferName)
        .assign(
          argument
              .nullableProperty('materialize', isNullable: isNullable)
              .call(const [])
              .property('asUint8List')
              .call(const []),
        )
        .statement;

    yield* _buildListAllocation(
      parameter,
      variable,
      bufferRef,
      Types.Uint8$,
      isNullable,
    );

    final assignment = refer(parameter.name)
        .property('asTypedList')
        .call([refer('${parameter.name}_size')])
        .property('setAll')
        .call([literalNum(0), bufferRef])
        .statement;

    if (isNullable) {
      yield if$(bufferRef.notEqualTo(literalNull), [assignment]);
    } else {
      yield assignment;
    }
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
    if (parameterType.optional) {
      final addressVarName = '${parameter.name}_address';
      final addressVarRef = refer(addressVarName);
      yield declareFinal(addressVarName).assign(argument).statement;

      final assignment = addressVarRef.equalTo(literalNull).conditional(
            _nullptrRef,
            parameterType.ffiType.newInstanceNamed(
              'fromAddress',
              [addressVarRef],
            ),
          );

      yield variable.assign(assignment).statement;
    } else {
      yield variable
          .assign(
            parameterType.ffiType.newInstanceNamed(
              'fromAddress',
              [argument],
            ),
          )
          .statement;
    }
  }

  Iterable<Code> _buildClassListParam(
    ParameterRef parameter,
    EtebaseClassListTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    yield* _buildListAllocation(
      parameter,
      variable,
      argument,
      parameterType.ffiInnerType,
      false,
    );

    yield _assignPointerArray(
      parameter.name,
      argument,
      parameterType.ffiInnerType.property('fromAddress'),
    ).statement;
  }

  Expression _stringToPointer(Expression variable) => variable
      .property('toNativeUtf8')
      .call(const [], const {'allocator': _arena})
      .property('cast')
      .call(const [], const {}, [Types.Char$]);

  Iterable<Code> _buildListAllocation(
    ParameterRef parameter,
    Expression variable,
    Expression argument,
    TypeReference pointerType,
    bool isNullable,
  ) sync* {
    final sizeVariableName = '${parameter.name}_size';
    final sizeVariable = refer(sizeVariableName);
    yield declareFinal(sizeVariableName)
        .assign(
          argument.nullableProperty(
            'length',
            isNullable: isNullable,
            withDefault: literalNum(0),
          ),
        )
        .statement;

    final allocation = _arena.call([sizeVariable], const {}, [pointerType]);

    if (isNullable) {
      yield variable
          .assign(
            argument.equalTo(literalNull).conditional(_nullptrRef, allocation),
          )
          .statement;
    } else {
      yield variable.assign(allocation).statement;
    }
  }

  Expression _assignPointerArray(
    String variableName,
    Expression argument,
    Expression map,
  ) =>
      Types.FfiHelpers$.property('assignPointerList').call([
        refer(variableName),
        argument,
        map,
      ]);
}
