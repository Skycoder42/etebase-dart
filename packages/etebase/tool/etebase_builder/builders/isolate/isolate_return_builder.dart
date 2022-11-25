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
    yield if$(result.equalTo(literalNum(-1)), [
      _buildErrorReturn().statement,
    ]);
  }

  Expression _buildReturnStatement(Expression result) =>
      Types.MethodResult$.newInstanceNamed(
        'success',
        [refer('invocation').property('id'), result],
      ).returned;

  Expression _buildErrorReturn() =>
      Types.FfiHelpers$.property('errorResult').call([
        refer('libEtebase'),
        _arena,
        refer('invocation').property('id'),
      ]).returned;
}
