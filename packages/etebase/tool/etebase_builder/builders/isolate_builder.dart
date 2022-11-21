import 'package:code_builder/code_builder.dart';

import '../parsers/etebase_parser.dart';
import '../parsers/method_parser.dart';
import '../util/case_builder.dart';
import 'isolate_implementation_builder.dart';

class IsolateBuilder {
  final IsolateImplementationBuilder _isolateImplementationBuilder;

  const IsolateBuilder([
    this._isolateImplementationBuilder = const IsolateImplementationBuilder(),
  ]);

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
            .call([refer('libEtebase'), refer('invocation')])
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
        ..replace(_buildHandlerSignature())
        ..name = 'etebaseIsolateMessageHandler'
        ..body = Block.of([caseBuilder.build()]),
    );
  }

  Method _buildImplementation(MethodRef method) => Method(
        (b) => b
          ..replace(_buildHandlerSignature())
          ..name = '_${method.element.name}'
          ..body = _isolateImplementationBuilder.build(method),
      );

  Method _buildHandlerSignature() => Method(
        (b) => b
          ..returns = TypeReference(
            (b) => b
              ..symbol = 'MethodResult'
              ..url = '../../src/isolate/method_result.dart',
          )
          ..requiredParameters.addAll([
            Parameter(
              (b) => b
                ..name = 'libEtebase'
                ..type = TypeReference(
                  (b) => b
                    ..symbol = 'LibEtebaseFFI'
                    ..url = 'libetebase.ffi.dart',
                ),
            ),
            Parameter(
              (b) => b
                ..name = 'invocation'
                ..type = TypeReference(
                  (b) => b
                    ..symbol = 'MethodInvocation'
                    ..url = '../../src/isolate/method_invocation.dart',
                ),
            ),
          ]),
      );
}
