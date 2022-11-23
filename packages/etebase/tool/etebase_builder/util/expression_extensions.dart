import 'package:code_builder/code_builder.dart';

extension ExpressionX on Expression {
  static final DartEmitter _emitter = DartEmitter(useNullSafetySyntax: true);

  Expression get incremented {
    final codeBuffer = StringBuffer('++');
    accept(_emitter, codeBuffer);
    return CodeExpression(Code(codeBuffer.toString()));
  }

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

  Expression asserted([String? message]) {
    final codeBuffer = StringBuffer('assert(');
    accept(_emitter, codeBuffer);
    if (message != null) {
      codeBuffer.write(', ');
      literalString(message).accept(_emitter, codeBuffer);
    }
    codeBuffer.write(')');

    return CodeExpression(Code(codeBuffer.toString()));
  }

  Code ifThen(Block then) {
    final codeBuffer = StringBuffer('if (');
    accept(_emitter, codeBuffer);
    codeBuffer.write(') {');
    then.accept(_emitter, codeBuffer);
    codeBuffer.write('}');
    return Code(codeBuffer.toString());
  }
}
