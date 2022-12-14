import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/expression_extensions.dart';
import '../../util/if_then.dart';
import '../../util/string_extensions.dart';
import '../../util/types.dart';
import '../client/client_method_builder.dart';
import 'isolate_builder.dart';

class IsolateInParamBuilder {
  const IsolateInParamBuilder();

  Iterable<Code> buildInParameters(MethodRef method) sync* {
    final params = method.exportedParams(withThis: true).toList();
    final paramsLength = params.length;
    final arguments = IsolateBuilder.invocationRef.property('arguments');
    yield* _buildAssertions(method, paramsLength, arguments, params);

    for (var argumentIndex = 0; argumentIndex < paramsLength; ++argumentIndex) {
      final param = params[argumentIndex];
      final argument =
          arguments.index(literalNum(argumentIndex)).asA(_castType(param.type));
      yield* buildInParameter(param, argument);
    }

    if (method.needsSizeHint) {
      final param = method.parameters.where((p) => p.needsSizeHint).single;

      yield declareFinal(param.lengthName())
          .assign(IsolateBuilder.reinvokedWithSizeRef)
          .ifNullThen(
            arguments
                .index(literalNum(paramsLength))
                .asA(Types.int$.asNullable),
          )
          .ifNullThen(
            IsolateBuilder.configRef.property('defaultContentBufferSize'),
          )
          .statement;
    }
  }

  Iterable<Code> buildInParameter(
    ParameterRef param,
    Expression argument,
  ) sync* {
    final paramType = param.type;
    final variable = declareFinal(param.name);

    if (paramType is StringTypeRef) {
      yield* _buildStringParam(param, paramType, variable, argument);
    } else if (paramType is UriTypeRef) {
      yield* _buildUrlParam(param, paramType, variable, argument);
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

  TypeReference _castType(TypeRef typeRef) =>
      typeRef is EtebaseClassTypeRef && typeRef.dataClass
          ? Types.client(typeRef.transferType)
          : typeRef.transferType;

  Iterable<Code> _buildAssertions(
    MethodRef method,
    int paramsLength,
    Expression arguments,
    List<ParameterRef> params,
  ) sync* {
    final assertLength = method.needsSizeHint ? paramsLength + 1 : paramsLength;
    yield arguments
        .property('length')
        .equalTo(literalNum(assertLength))
        .asserted('Invocation must have exactly $assertLength arguments');

    for (var i = 0; i < paramsLength; ++i) {
      final param = params[i];
      final transferType = _castType(param.type);
      yield arguments.index(literalNum(i)).isA(transferType).asserted(
            'Parameter ${param.name} must be of type '
            '${transferType.accept(DartEmitter(useNullSafetySyntax: true))}',
          );
    }
    if (method.needsSizeHint) {
      yield arguments
          .index(literalNum(paramsLength))
          .isA(Types.int$.asNullable)
          .asserted(
            'Parameter ${ClientMethodBuilder.sizeHintRef.symbol!} '
            'must be of type int?',
          );
    }
  }

  Iterable<Code> _buildStringParam(
    ParameterRef parameter,
    StringTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    yield variable
        .assign(_stringToPointer(argument, isNullable: parameterType.nullable))
        .statement;
  }

  Iterable<Code> _buildUrlParam(
    ParameterRef parameter,
    UriTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    yield variable
        .assign(_stringToPointer(argument.property('toString').call(const [])))
        .statement;
  }

  Iterable<Code> _buildDateTimeParam(
    ParameterRef parameter,
    DateTimeTypeRef parameterType,
    Expression variable,
    Expression argument,
  ) sync* {
    yield variable
        .assign(
          IsolateBuilder.poolRef
              .call(const [], const {}, [Types.Int64$])
              .cascade('value')
              .assign(argument.property('millisecondsSinceEpoch')),
        )
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
        .call([refer(parameter.lengthName())])
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
    if (parameterType.dataClass) {
      yield variable
          .assign(
            refer('_${parameterType.name.lowerFirstChar()}ToNative').call([
              IsolateBuilder.libEtebaseRef,
              IsolateBuilder.poolRef,
              argument
            ]),
          )
          .statement;
    } else if (parameterType.optional) {
      final addressVarName = '${parameter.name}_address';
      final addressVarRef = refer(addressVarName);
      yield declareFinal(addressVarName).assign(argument).statement;

      final assignment = addressVarRef.equalTo(literalNull).conditional(
            Types.nullptr$,
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

  Expression _stringToPointer(Expression variable, {bool isNullable = false}) {
    final convertExpression = variable
        .nullableProperty('toNativeUtf8', isNullable: isNullable)
        .call(const [], const {'allocator': IsolateBuilder.poolRef})
        .property('cast')
        .call(const [], const {}, [Types.Char$]);

    return isNullable
        ? convertExpression.ifNullThen(Types.nullptr$)
        : convertExpression;
  }

  Iterable<Code> _buildListAllocation(
    ParameterRef parameter,
    Expression variable,
    Expression argument,
    TypeReference pointerType,
    bool isNullable,
  ) sync* {
    final sizeVariable = refer(parameter.lengthName());
    yield declareFinal(parameter.lengthName())
        .assign(
          argument.nullableProperty(
            'length',
            isNullable: isNullable,
            withDefault: literalNum(0),
          ),
        )
        .statement;

    // TODO generalize, as property from parser (or maybe remove?)
    if (parameter.name == 'encryptionKey') {
      yield if$(
          argument
              .notEqualTo(literalNull)
              .and(sizeVariable.notEqualTo(literalNum(32))),
          [
            TypeReference((b) => b..symbol = 'ArgumentError')
                .newInstance([
                  literalString(
                    'should be 32 bytes long, '
                    'but has \$${sizeVariable.symbol} bytes',
                  ),
                  literalString(parameter.name)
                ])
                .thrown
                .statement,
          ]);
    }

    final allocation = IsolateBuilder.poolRef.call(
      [sizeVariable],
      const {},
      [pointerType],
    );

    if (isNullable) {
      yield variable
          .assign(
            argument
                .equalTo(literalNull)
                .conditional(Types.nullptr$, allocation),
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
