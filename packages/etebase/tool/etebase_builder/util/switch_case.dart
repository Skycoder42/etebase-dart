import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/visitors.dart';

class SwitchCase implements Code, Spec {
  final Spec switchExpression;
  final _caseExpression = <Spec, Iterable<Spec>>{};
  Iterable<Spec>? _defaultCase;

  SwitchCase._(this.switchExpression);

  void case$(Expression caseExpression, Iterable<Code> statements) =>
      _caseExpression[caseExpression] = statements;

  // ignore: use_setters_to_change_properties
  void default$(Iterable<Code> statements) => _defaultCase = statements;

  @override
  R accept<R>(SpecVisitor<R> visitor, [R? context]) {
    if (context is! StringSink) {
      throw UnsupportedError('Cannot use try-catch without a sink');
    }

    context.write('switch(');
    switchExpression.accept(visitor, context);
    context.writeln(') {');

    for (final caseEntry in _caseExpression.entries) {
      context.write('case ');
      caseEntry.key.accept(visitor, context);
      context.writeln(':');
      for (final statement in caseEntry.value) {
        statement.accept(visitor, context);
      }
    }

    if (_defaultCase != null) {
      context.writeln('default:');
      for (final statement in _defaultCase!) {
        statement.accept(visitor, context);
      }
    }

    context.writeln('}');
    return context;
  }
}

SwitchCase switch$(Expression switchExpression) =>
    SwitchCase._(switchExpression);
