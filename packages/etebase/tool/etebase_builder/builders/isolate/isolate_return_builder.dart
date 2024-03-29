import 'package:code_builder/code_builder.dart';
import 'package:source_helper/source_helper.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/if_then.dart';
import '../../util/string_extensions.dart';
import '../../util/types.dart';
import 'isolate_builder.dart';
import 'isolate_implementation_builder.dart';
import 'isolate_out_param_builder.dart';

class IsolateReturnBuilder {
  final IsolateOutParamBuilder _isolateOutParamBuilder;

  const IsolateReturnBuilder([
    this._isolateOutParamBuilder = const IsolateOutParamBuilder(),
  ]);

  Iterable<Code> buildReturn(MethodRef method) => buildReturnConversion(
        method,
        IsolateImplementationBuilder.resultRef,
        (returnValue) => _buildReturnStatement(
          returnValue,
          method.outOrReturnType,
        ),
      );

  Iterable<Code> buildReturnConversion(
    MethodRef method,
    Expression resultRef,
    Code Function(Expression returnValue) buildReturnStatement, {
    bool thrown = false,
  }) sync* {
    final Expression transformedResult;
    if (method.hasOutParam) {
      final returnParam = method.outParam;
      final returnParamRef = refer(returnParam.name);
      final returnType = returnParam.type;

      yield checkIntSuccess(resultRef, thrown: thrown);
      if (returnType is StringTypeRef) {
        transformedResult = _transformString(
          returnParamRef,
          returnType,
          // TODO workaround until https://github.com/etesync/libetebase/issues/7 is fixed
          length: literalNum(2 + (3 * 9) + (5 * 12)),
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
          yield checkIntSuccess(resultRef, thrown: thrown);
          transformedResult = _transformIntBool(resultRef, returnType);
        } else {
          transformedResult = resultRef;
        }
      } else if (returnType is IntTypeRef) {
        yield checkIntSuccess(resultRef, thrown: thrown);
        transformedResult = returnType.asReturn ? literalNull : resultRef;
      } else if (returnType is StringTypeRef) {
        if (!returnType.nullable) {
          yield _checkPointerSuccess(resultRef, thrown: thrown);
        }
        transformedResult = _transformString(resultRef, returnType);
      } else if (returnType is UriTypeRef) {
        yield _checkPointerSuccess(resultRef, thrown: thrown);
        transformedResult = _transformUrl(resultRef, returnType);
      } else if (returnType is DateTimeTypeRef) {
        transformedResult = _transformDateTime(resultRef, returnType);
      } else if (returnType is ByteArrayTypeRef) {
        yield _checkPointerSuccess(resultRef, thrown: thrown);
        transformedResult = _transformByteArray(method, resultRef, returnType);
      } else if (returnType is EnumTypeRef) {
        yield checkIntSuccess(resultRef, thrown: thrown);
        transformedResult = _transformEnum(resultRef, returnType);
      } else if (returnType is EtebaseClassTypeRef) {
        yield _checkPointerSuccess(resultRef, thrown: thrown);
        transformedResult = _transformEtebaseClass(resultRef, returnType);
      } else {
        throw UnsupportedError(
          'Cannot create return value for type $returnType',
        );
      }
    }

    yield buildReturnStatement(transformedResult);
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
      );

  IfThen checkIntSuccess(
    Expression result, {
    bool thrown = false,
  }) =>
      if$(result.lessThan(literalNum(0)), [
        if (thrown)
          _buildErrorThrow().statement
        else
          _buildErrorReturn().statement,
      ]);

  Code _checkPointerSuccess(
    Expression result, {
    bool thrown = false,
  }) =>
      if$(result.equalTo(Types.nullptr$), [
        if (thrown)
          _buildErrorThrow().statement
        else
          _buildErrorReturn().statement,
      ]);

  Code _buildReturnStatement(Expression result, TypeRef type) =>
      Types.MethodResult$.newInstanceNamed(
        'successTyped',
        [IsolateBuilder.invocationRef.property('id'), result],
        const {},
        [_castType(type)],
      ).returned.statement;

  Expression _buildErrorReturn() =>
      Types.FfiHelpers$.property('errorResult').call([
        IsolateBuilder.libEtebaseRef,
        IsolateBuilder.invocationRef.property('id'),
      ]).returned;

  Expression _buildErrorThrow() =>
      Types.FfiHelpers$.property('throwError').call([
        IsolateBuilder.libEtebaseRef,
      ]);

  TypeReference _castType(TypeRef typeRef) =>
      typeRef is EtebaseClassTypeRef && typeRef.dataClass
          ? Types.client(typeRef.transferType)
          : typeRef.transferType;

  Expression _transformIntBool(Expression resultRef, BoolTypeRef type) =>
      resultRef.equalTo(literalNum(0));

  Expression _transformString(
    Expression result,
    StringTypeRef type, {
    Expression? length,
  }) {
    final resultExpression = type.mutable
        ? IsolateBuilder.poolRef.property('attachScoped').call([result])
        : result;
    final castExpression = resultExpression
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

  Expression _transformUrl(Expression result, UriTypeRef type) {
    final resultExpression = type.mutable
        ? IsolateBuilder.poolRef.property('attachScoped').call([result])
        : result;
    return Types.Uri$.newInstanceNamed(
      'parse',
      [_transformString(resultExpression, StringTypeRef())],
    );
  }

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
    var resultExpression = result;
    if (method.hasRetSize) {
      length = refer('retSize').property('value');
      resultExpression =
          IsolateBuilder.poolRef.property('attachScoped').call([result]);
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
        resultExpression
            .property('cast')
            .call(const [], const {}, [Types.Uint8$])
            .property('asTypedList')
            .call([length]),
      ]),
    ]);
  }

  Expression _transformEnum(Expression result, EnumTypeRef type) =>
      type.transferType.property('values').index(result);

  Expression _transformEtebaseClass(
    Expression result,
    EtebaseClassTypeRef type,
  ) {
    if (type.dataClass) {
      return refer('_${type.name.lowerFirstChar()}FromNative').call([
        IsolateBuilder.libEtebaseRef,
        IsolateBuilder.poolRef,
        result,
      ]);
    } else {
      final memberPrefix = type.memberPrefix ?? type.name.snake;
      return IsolateBuilder.poolRef.property('attachGlobal').call([
        result,
        IsolateBuilder.libEtebaseRef.property('${memberPrefix}_destroy'),
      ]).property('address');
    }
  }

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
