import 'package:code_builder/code_builder.dart';

import '../../parsers/etebase_parser.dart';
import '../../parsers/method_parser.dart';
import '../../util/switch_case.dart';
import '../../util/try_catch.dart';
import '../../util/types.dart';
import 'isolate_implementation_builder.dart';

class IsolateBuilder {
  static const _invocationName = 'invocation';
  static const invocationRef = Reference(_invocationName);
  static const _libEtebaseName = 'libEtebase';
  static const libEtebaseRef = Reference(_libEtebaseName);
  static const _arenaName = 'arena';
  static const arenaRef = Reference(_arenaName);
  static const _reinvokedWithSizeName = 'reinvokedWithSize';
  static const reinvokedWithSizeRef = Reference(_reinvokedWithSizeName);

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
    final caseBuilder = switch$(invocationRef.property('method'));

    for (final method in methods) {
      caseBuilder.case$(refer('#${method.ffiName}'), [
        refer('_${method.ffiName}')
            .call([libEtebaseRef, invocationRef, arenaRef])
            .returned
            .statement,
      ]);
    }

    caseBuilder.default$([
      TypeReference((b) => b..symbol = 'ArgumentError')
          .newInstanceNamed('value', [
            invocationRef.property('method'),
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
          declareFinal(_arenaName)
              .assign(Types.EtebaseArena$.newInstance(const []))
              .statement,
          try$([
            caseBuilder,
          ]).finally$([
            arenaRef.property('releaseAll').call(const []).statement,
          ]),
        ]),
    );
  }

  Method _buildImplementation(MethodRef method) => Method(
        (b) {
          b
            ..replace(_buildHandlerSignature())
            ..requiredParameters.add(
              Parameter(
                (b) => b
                  ..name = _arenaName
                  ..type = Types.EtebaseArena$,
              ),
            )
            ..name = '_${method.ffiName}'
            ..body = _isolateImplementationBuilder.build(method);

          if (method.needsSizeHint) {
            b.optionalParameters.add(
              Parameter(
                (b) => b
                  ..named = true
                  ..name = _reinvokedWithSizeName
                  ..type = Types.int$.asNullable,
              ),
            );
          }
        },
      );

  Method _buildHandlerSignature() => Method(
        (b) => b
          ..returns = Types.MethodResult$
          ..requiredParameters.addAll([
            Parameter(
              (b) => b
                ..name = _libEtebaseName
                ..type = Types.ffi(refer('LibEtebaseFFI')),
            ),
            Parameter(
              (b) => b
                ..name = _invocationName
                ..type = Types.MethodInvocation$,
            ),
          ]),
      );
}
