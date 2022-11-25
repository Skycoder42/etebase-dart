import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/if_then.dart';
import '../../util/types.dart';

class IsolateReturnBuilder {
  static const _arena = Reference('arena');

  const IsolateReturnBuilder();

  Iterable<Code> buildReturn(MethodRef method) sync* {
    final returnType = method.returnType;

    final resultRef = refer('result');
    final Expression transformedResult;
    if (returnType is VoidTypeRef) {
      transformedResult = literalNull;
    } else if (returnType is IntTypeRef) {
      yield* _checkSuccess(resultRef);
      // TODO handle ourParams
      transformedResult = returnType.asReturn ? literalNull : resultRef;
    } else {
      transformedResult = resultRef;
    }

    yield _buildReturnStatement(transformedResult).statement;
  }

  Iterable<Code> _checkSuccess(Expression result) sync* {
    yield IfThen.if$(result.equalTo(literalNum(-1)), _buildErrorReturn());
  }

  Expression _buildReturnStatement(Expression result) =>
      Types.MethodResult$.newInstanceNamed(
        'success',
        [refer('invocation').property('id'), result],
      ).returned;

  Iterable<Code> _buildErrorReturn() sync* {
    yield declareFinal('errorCode')
        .assign(
          refer('libEtebase').property('etebase_error_get_code').call(const []),
        )
        .statement;

    yield declareFinal('errorMessage')
        .assign(
          _arena.property('attach').call([
            refer('libEtebase')
                .property('etebase_error_get_message')
                .call(const []),
          ]),
        )
        .statement;

    yield Types.MethodResult$.newInstanceNamed('failure', [
      refer('invocation').property('id'),
      Types.EtebaseErrorCode$.property('values').index(refer('errorCode')),
      refer('errorMessage')
          .property('cast')
          .call(const [], const {}, [Types.Utf8$])
          .property('toDartString')
          .call(const []),
    ]).returned.statement;
  }
}
