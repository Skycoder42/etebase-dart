import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/visitors.dart';

import 'expression_extensions.dart';

final Expression emptyExpression = refer('');

class ForRange implements Code, Spec {
  final Spec _initializer;
  final Spec _condition;
  final Spec _increment;
  final Iterable<Spec> _body;

  ForRange._(
    this._initializer,
    this._condition,
    this._increment,
    this._body,
  );

  @override
  R accept<R>(SpecVisitor<R> visitor, [R? context]) {
    if (context is! StringSink) {
      throw UnsupportedError('Cannot use try-catch without a sink');
    }

    context.write('for(');
    _initializer.accept(visitor, context);
    context.write('; ');
    _condition.accept(visitor, context);
    context.write('; ');
    _increment.accept(visitor, context);
    context.write(') {');
    _body.acceptAll(visitor, context);
    context.write('}');

    return context;
  }
}

ForRange forRange$(
  Expression initializer,
  Expression condition,
  Expression increment,
  Iterable<Code> body,
) =>
    ForRange._(initializer, condition, increment, body);

class ForIn implements Code, Spec {
  final Spec _variable;
  final Spec _iterable;
  final Iterable<Spec> _body;

  ForIn._(this._variable, this._iterable, this._body);

  @override
  R accept<R>(SpecVisitor<R> visitor, [R? context]) {
    if (context is! StringSink) {
      throw UnsupportedError('Cannot use try-catch without a sink');
    }

    context.write('for(');
    _variable.accept(visitor, context);
    context.write(' in ');
    _iterable.accept(visitor, context);
    context.write(') {');
    _body.acceptAll(visitor, context);
    context.write('}');

    return context;
  }
}

ForIn forIn$(Expression variable, Expression iterable, Iterable<Code> body) =>
    ForIn._(variable, iterable, body);
