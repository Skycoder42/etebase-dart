import 'package:code_builder/code_builder.dart';

import '../../parsers/etebase_parser.dart';
import '../../parsers/method_parser.dart';
import '../../util/switch_case.dart';
import '../../util/try_catch.dart';
import '../../util/types.dart';
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
        ..directives.add(Directive.import('package:ffi/ffi.dart'))
        ..body.add(_buildHandler(methods))
        ..body.addAll(methods.map(_buildImplementation)),
    );
  }

  List<MethodRef> _allMethods(EtebaseRef etebase) => etebase.classes
      .expand((clazz) => clazz.methods)
      .followedBy(etebase.utilsFunctions)
      .followedBy(etebase.functions)
      .where((method) => !method.isGetLength)
      .toList();

  Method _buildHandler(List<MethodRef> methods) {
    final caseBuilder = switch$(refer('invocation').property('method'));

    for (final method in methods) {
      caseBuilder.case$(refer('#${method.ffiName}'), [
        refer('_${method.ffiName}')
            .call([refer('libEtebase'), refer('invocation'), refer('arena')])
            .returned
            .statement,
      ]);
    }

    caseBuilder.default$([
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
        ..body = Block.of([
          declareFinal('arena')
              .assign(Types.EtebaseArena$.newInstance(const []))
              .statement,
          try$([
            caseBuilder,
          ]).finally$([
            refer('arena').property('releaseAll').call(const []).statement,
          ]),
        ]),
    );
  }

  Method _buildImplementation(MethodRef method) => Method(
        (b) => b
          ..replace(_buildHandlerSignature())
          ..requiredParameters.add(
            Parameter(
              (b) => b
                ..name = 'arena'
                ..type = Types.EtebaseArena$,
            ),
          )
          ..name = '_${method.ffiName}'
          ..body = _isolateImplementationBuilder.build(method),
      );

  Method _buildHandlerSignature() => Method(
        (b) => b
          ..returns = Types.MethodResult$
          ..requiredParameters.addAll([
            Parameter(
              (b) => b
                ..name = 'libEtebase'
                ..type = Types.ffi(refer('LibEtebaseFFI')),
            ),
            Parameter(
              (b) => b
                ..name = 'invocation'
                ..type = Types.MethodInvocation$,
            ),
          ]),
      );
}
