import 'package:code_builder/code_builder.dart';

class CaseBuilder {
  final DartEmitter _emitter;

  final Expression switchExpression;
  final _caseExpression = <Expression, Iterable<Code>>{};
  Iterable<Code>? _defaultCase;

  CaseBuilder(this.switchExpression, [DartEmitter? emitter])
      : _emitter = emitter ?? DartEmitter(useNullSafetySyntax: true);

  void addCase(Expression caseExpression, Iterable<Code> statements) =>
      _caseExpression[caseExpression] = statements;

  // ignore: use_setters_to_change_properties
  void addDefaultCase(Iterable<Code> statements) => _defaultCase = statements;

  Code build() {
    final codeBuffer = StringBuffer('switch(');
    switchExpression.accept(_emitter, codeBuffer);
    codeBuffer.writeln(') {');

    for (final caseEntry in _caseExpression.entries) {
      codeBuffer.write('case ');
      caseEntry.key.accept(_emitter, codeBuffer);
      codeBuffer.writeln(':');
      for (final statement in caseEntry.value) {
        statement.accept(_emitter, codeBuffer);
      }
    }

    if (_defaultCase != null) {
      codeBuffer.writeln('default:');
      for (final statement in _defaultCase!) {
        statement.accept(_emitter, codeBuffer);
      }
    }

    codeBuffer.writeln('}');

    return Code(codeBuffer.toString());
  }
}

extension ExpressionX on Expression {
  CaseBuilder get switchCase => CaseBuilder(this);
}
