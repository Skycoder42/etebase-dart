import 'package:code_builder/code_builder.dart';

extension ExpressionX on Expression {
  static final DartEmitter _emitter = DartEmitter(useNullSafetySyntax: true);

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
}
