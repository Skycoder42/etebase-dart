import 'package:code_builder/code_builder.dart';

import '../parsers/etebase_parser.dart';
import '../parsers/method_parser.dart';
import '../util/case_builder.dart';

class IsolateBuilder {
  const IsolateBuilder();

  Library build(EtebaseRef etebase) {
    final methods = _allMethods(etebase);
    return Library(
      (b) => b
        ..body.add(_buildHandler(methods))
        ..body.addAll(methods.map(_buildImplementation)),
    );
  }

  List<MethodRef> _allMethods(EtebaseRef etebase) => etebase.classes
      .expand((clazz) => clazz.methods)
      .followedBy(etebase.utilsFunctions)
      .followedBy(etebase.functions)
      .toList();

  Method _buildHandler(List<MethodRef> methods) {
    final caseBuilder = refer('invocation').property('method').switchCase;

    for (final method in methods) {
      caseBuilder.addCase(refer('#${method.element.name}'), [
        refer('_${method.element.name}')
            .call([refer('invocation')])
            .returned
            .statement,
      ]);
    }

    caseBuilder.addDefaultCase([
      TypeReference((b) => b..symbol = 'ArgumentError')
          .newInstanceNamed('value', [
            refer('invocation').property('method'),
            literalString('invocation.method'),
            literalString('Method does not exist'),
          ])
          .thrown
          .statement
    ]);

    return Method(
      (b) => b
        ..name = 'etebaseIsolateMessageHandler'
        ..returns = TypeReference(
          (b) => b
            ..symbol = 'MethodResult'
            ..url = '../../src/isolate/method_result.dart',
        )
        ..requiredParameters.add(
          Parameter(
            (b) => b
              ..name = 'invocation'
              ..type = TypeReference(
                (b) => b
                  ..symbol = 'MethodInvocation'
                  ..url = '../../src/isolate/method_invocation.dart',
              ),
          ),
        )
        ..body = Block.of([caseBuilder.build()]),
    );
  }

  Method _buildImplementation(MethodRef method) => Method(
        (b) => b
          ..name = '_${method.element.name}'
          ..returns = TypeReference(
            (b) => b
              ..symbol = 'MethodResult'
              ..url = '../../src/isolate/method_result.dart',
          )
          ..requiredParameters.add(
            Parameter(
              (b) => b
                ..name = 'invocation'
                ..type = TypeReference(
                  (b) => b
                    ..symbol = 'MethodInvocation'
                    ..url = '../../src/isolate/method_invocation.dart',
                ),
            ),
          )
          ..body = TypeReference((b) => b..symbol = 'UnimplementedError')
              .newInstance([])
              .thrown
              .code,
      );
}
