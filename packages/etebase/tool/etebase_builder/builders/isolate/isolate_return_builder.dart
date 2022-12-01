import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/if_then.dart';
import '../../util/types.dart';
import 'isolate_builder.dart';
import 'isolate_implementation_builder.dart';
import 'isolate_out_param_builder.dart';

class IsolateReturnBuilder {
  final IsolateOutParamBuilder _isolateOutParamBuilder;

  const IsolateReturnBuilder([
    this._isolateOutParamBuilder = const IsolateOutParamBuilder(),
  ]);

  Iterable<Code> buildReturn(MethodRef method) sync* {
    const resultRef = IsolateImplementationBuilder.resultRef;

    final Expression transformedResult;
    if (method.hasOutParam) {
      final returnParam = method.outParam;
      final returnParamRef = refer(returnParam.name);
      final returnType = returnParam.type;

      yield checkIntSuccess(resultRef);
      if (returnType is StringTypeRef) {
        transformedResult = _transformString(
          returnParamRef,
          returnType,
          // TODO check if needed - might be null terminated already, so actual
          // size is ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE - 1
          length: _isolateOutParamBuilder.getOutSizeRef(method, returnParam),
        );
      } else if (returnType is ByteArrayTypeRef) {
        transformedResult = _transformByteArray(
          method,
          returnParamRef,
          returnType,
          listLength:
              _isolateOutParamBuilder.getOutSizeRef(method, returnParam),
        );
      } else if (returnType is EtebaseOutListTypeRef) {
        transformedResult = _transformEtebaseOutList(
          returnParamRef,
          refer(returnParam.lengthName(validateHasLength: false)),
          returnType,
        );
      } else {
        throw UnsupportedError(
          'Cannot build out return ref for type $returnType',
        );
      }
    } else {
      final returnType = method.returnType;
      if (returnType is VoidTypeRef) {
        transformedResult = literalNull;
      } else if (returnType is BoolTypeRef) {
        if (returnType.fromInt) {
          yield checkIntSuccess(resultRef);
          transformedResult = _transformIntBool(resultRef, returnType);
        } else {
          transformedResult = resultRef;
        }
      } else if (returnType is IntTypeRef) {
        yield checkIntSuccess(resultRef);
        transformedResult = returnType.asReturn ? literalNull : resultRef;
      } else if (returnType is StringTypeRef) {
        if (!returnType.nullable) {
          yield _checkPointerSuccess(resultRef);
        }
        transformedResult = _transformString(resultRef, returnType);
      } else if (returnType is UriTypeRef) {
        yield _checkPointerSuccess(resultRef);
        transformedResult = _transformUrl(resultRef, returnType);
      } else if (returnType is DateTimeTypeRef) {
        transformedResult = _transformDateTime(resultRef, returnType);
      } else if (returnType is ByteArrayTypeRef) {
        yield _checkPointerSuccess(resultRef);
        transformedResult = _transformByteArray(method, resultRef, returnType);
      } else if (returnType is EnumTypeRef) {
        yield checkIntSuccess(resultRef);
        transformedResult = _transformEnum(resultRef, returnType);
      } else if (returnType is EtebaseClassTypeRef) {
        yield _checkPointerSuccess(resultRef);
        transformedResult = _transformEtebaseClass(resultRef, returnType);
      } else {
        throw UnsupportedError(
          'Cannot create return value for type $returnType',
        );
      }
    }

    yield _buildReturnStatement(
      transformedResult,
      method.outOrReturnType,
    ).statement;
  }

  Code buildReturnByteArray(MethodRef method, Expression listLength) =>
      _buildReturnStatement(
        _transformByteArray(
          method,
          refer(method.outParam.name),
          method.outOrReturnType as ByteArrayTypeRef,
          listLength: listLength,
        ),
        method.outOrReturnType,
      ).statement;

  IfThen checkIntSuccess(Expression result) =>
      if$(result.lessThan(literalNum(0)), [
        _buildErrorReturn().statement,
      ]);

  Code _checkPointerSuccess(Expression result) =>
      if$(result.equalTo(Types.nullptr$), [
        _buildErrorReturn().statement,
      ]);

  Expression _buildReturnStatement(Expression result, TypeRef type) =>
      Types.MethodResult$.newInstanceNamed(
        'successTyped',
        [IsolateBuilder.invocationRef.property('id'), result],
        const {},
        [type.transferType],
      ).returned;

  Expression _buildErrorReturn() =>
      Types.FfiHelpers$.property('errorResult').call([
        IsolateBuilder.libEtebaseRef,
        IsolateBuilder.invocationRef.property('id'),
      ]).returned;

  Expression _transformIntBool(Reference resultRef, BoolTypeRef type) =>
      resultRef.equalTo(literalNum(0));

  Expression _transformString(
    Expression result,
    StringTypeRef type, {
    Expression? length,
  }) {
    final castExpression = result
        .property('cast')
        .call(const [], const {}, [Types.Utf8$])
        .property('toDartString')
        .call(const [], {if (length != null) 'length': length});
    if (type.nullable) {
      return result.equalTo(Types.nullptr$).conditional(
            literalNull,
            castExpression,
          );
    } else {
      return castExpression;
    }
  }

  Expression _transformUrl(Expression result, UriTypeRef type) =>
      Types.Uri$.newInstanceNamed(
        'parse',
        [_transformString(result, StringTypeRef())],
      );

  Expression _transformDateTime(Expression result, DateTimeTypeRef type) =>
      result.equalTo(Types.nullptr$).conditional(
            literalNull,
            Types.DateTime$.newInstanceNamed('fromMillisecondsSinceEpoch', [
              result.property('value'),
            ]),
          );

  Expression _transformByteArray(
    MethodRef method,
    Expression result,
    ByteArrayTypeRef type, {
    Expression? listLength,
  }) {
    final Expression length;
    if (method.hasRetSize) {
      length = refer('retSize').property('value');
    } else if (method.lengthGetter.hasLengthGetter) {
      length = IsolateBuilder.libEtebaseRef
          .property(method.ffiLengthGetterName)
          .call([IsolateOutParamBuilder.thisRef]);
    } else if (listLength != null) {
      length = listLength;
    } else {
      throw UnsupportedError(
        'Cannot create byte array without retSize or length getter',
      );
    }

    return Types.TransferableTypedData$.newInstanceNamed('fromList', [
      literalList([
        result
            .property('cast')
            .call(const [], const {}, [Types.Uint8$])
            .property('asTypedList')
            .call([length])
      ]),
    ]);
  }

  Expression _transformEnum(Expression result, EnumTypeRef type) =>
      type.transferType.property('values').index(result);

  Expression _transformEtebaseClass(
    Expression result,
    EtebaseClassTypeRef type,
  ) =>
      result.property('address');

  Expression _transformEtebaseOutList(
    Expression result,
    Expression resultLength,
    EtebaseOutListTypeRef type,
  ) =>
      Types.FfiHelpers$.property('extractPointerList').call([
        result,
        resultLength,
        Method(
          (b) => b
            ..requiredParameters.add(Parameter((b) => b..name = 'p'))
            ..body = refer('p').property('address').code,
        ).closure,
      ]);
}
