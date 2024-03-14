import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/visitors.dart';

import 'expression_extensions.dart';

class _IfThenInfo {
  final Spec _if;
  final Iterable<Code> _then;

  const _IfThenInfo(this._if, this._then);
}

class IfThen implements Code, Spec {
  final List<_IfThenInfo> _ifThenStatements;
  final Iterable<Code>? _else;

  IfThen._(this._ifThenStatements, this._else);

  IfThen elseIf$(Expression condition, Iterable<Code> body) {
    if (_else != null) {
      throw StateError('Cannot define else if after else');
    }
    return IfThen._([..._ifThenStatements, _IfThenInfo(condition, body)], null);
  }

  IfThen else$(Iterable<Code> body) {
    if (_else != null) {
      throw StateError('Can only define else once');
    }
    return IfThen._(_ifThenStatements, body);
  }

  @override
  R accept<R>(SpecVisitor<R> visitor, [R? context]) {
    if (_ifThenStatements.isEmpty) {
      throw StateError('Cannot build an IfThen without any if statements');
    }

    if (context is! StringSink) {
      throw UnsupportedError('Cannot use try-catch without a sink');
    }

    var isFirst = true;
    for (final statement in _ifThenStatements) {
      if (isFirst) {
        isFirst = false;
      } else {
        context.write(' else ');
      }
      context.write('if(');
      statement._if.accept(visitor, context);
      context.write(') {');
      statement._then.acceptAll(visitor, context);
      context.write('}');
    }

    if (_else != null) {
      context.write(' else {');
      _else.acceptAll(visitor, context);
      context.write('}');
    }

    return context;
  }
}

IfThen if$(Expression condition, Iterable<Code> body) =>
    IfThen._([_IfThenInfo(condition, body)], null);
