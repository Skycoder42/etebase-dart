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
  static const _configName = 'config';
  static const configRef = Reference(_configName);
  static const _arenaName = 'arena';
  static const arenaRef = Reference(_arenaName);
  static const _reinvokedWithSizeName = 'reinvokedWithSize';
  static const reinvokedWithSizeRef = Reference(_reinvokedWithSizeName);
  static const handlerParams = [
    libEtebaseRef,
    configRef,
    invocationRef,
    arenaRef
  ];

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
      .toList();

  Method _buildHandler(List<MethodRef> methods) {
    final caseBuilder = switch$(invocationRef.property('method'));

    for (final method in methods) {
      caseBuilder.case$(refer('#${method.ffiName}'), [
        refer('_${method.ffiName}').call(handlerParams).returned.statement,
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
          refer('log', 'dart:developer').call(
            [literalString('Starting invocation of \$$_invocationName')],
            {
              'name': literalString('EtebaseIsolate'),
              'level': literalNum(500),
            },
          ).statement,
          declareFinal(_arenaName)
              .assign(Types.EtebaseArena$.newInstance(const []))
              .statement,
          try$([
            caseBuilder,
          ]).catch$(
            error: refer('e'),
            stackTrace: refer('s'),
            body: [
              refer('log', 'dart:developer').call(
                [literalString('Invocation failed with error:')],
                {
                  'name': literalString('EtebaseIsolate'),
                  'level': literalNum(1000),
                  'error': refer('e'),
                  'stackTrace': refer('s'),
                },
              ).statement,
              refer('rethrow').statement,
            ],
          ).finally$([
            arenaRef.property('releaseAll').call(const []).statement,
            refer('log', 'dart:developer').call(
              [literalString('Finished invocation')],
              {
                'name': literalString('EtebaseIsolate'),
                'level': literalNum(500)
              },
            ).statement,
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
                ..name = _configName
                ..type = Types.EtebaseConfig$,
            ),
            Parameter(
              (b) => b
                ..name = _invocationName
                ..type = Types.MethodInvocation$,
            ),
          ]),
      );
}
