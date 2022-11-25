import 'package:code_builder/code_builder.dart';
import 'package:code_builder/src/visitors.dart';

class _AssertStatement implements Code, Spec {
  final Spec _expression;
  final String? _message;

  const _AssertStatement(Expression expression, [this._message])
      : _expression = expression;

  @override
  R accept<R>(SpecVisitor<R> visitor, [R? context]) {
    if (context is! StringSink) {
      throw UnsupportedError('Cannot use try-catch without a sink');
    }

    context.write('assert(');
    _expression.accept(visitor, context);
    if (_message != null) {
      context.write(', ');
      // ignore: unnecessary_cast
      (literalString(_message!) as Spec).accept(visitor, context);
    }
    context.write(');');

    return context;
  }
}

extension ExpressionX on Expression {
  Expression nullableProperty(
    String name, {
    required bool isNullable,
    Expression? withDefault,
  }) {
    if (isNullable) {
      if (withDefault != null) {
        return nullSafeProperty(name).ifNullThen(withDefault);
      } else {
        return nullSafeProperty(name);
      }
    } else {
      return property(name);
    }
  }

  Code asserted([String? message]) => _AssertStatement(this, message);
}
