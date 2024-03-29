import 'package:code_builder/code_builder.dart';

import '../../parsers/etebase_parser.dart';
import '../../parsers/method_parser.dart';
import '../../util/switch_case.dart';
import '../../util/try_catch.dart';
import '../../util/types.dart';
import 'isolate_converter_builder.dart';
import 'isolate_implementation_builder.dart';

class IsolateBuilder {
  static const _invocationName = 'invocation';
  static const invocationRef = Reference(_invocationName);
  static const _libEtebaseName = 'libEtebase';
  static const libEtebaseRef = Reference(_libEtebaseName);
  static const _configName = 'config';
  static const configRef = Reference(_configName);
  static const _poolName = 'pool';
  static const poolRef = Reference(_poolName);
  static const _reinvokedWithSizeName = 'reinvokedWithSize';
  static const reinvokedWithSizeRef = Reference(_reinvokedWithSizeName);
  static const handlerParams = [
    libEtebaseRef,
    poolRef,
    configRef,
    invocationRef,
  ];

  final IsolateConverterBuilder _isolateConverterBuilder;
  final IsolateImplementationBuilder _isolateImplementationBuilder;

  const IsolateBuilder([
    this._isolateConverterBuilder = const IsolateConverterBuilder(),
    this._isolateImplementationBuilder = const IsolateImplementationBuilder(),
  ]);

  Library build(EtebaseRef etebase) {
    final methods = _allMethods(etebase);
    return Library(
      (b) => b
        ..ignoreForFile.addAll(const [
          'non_constant_identifier_names',
          'require_trailing_commas',
          'unnecessary_parenthesis',
          'prefer_relative_imports',
          'lines_longer_than_80_chars',
          'prefer_is_empty',
          'constant_identifier_names',
          'avoid_bool_literals_in_conditional_expressions',
          'prefer_const_constructors',
          'unused_element',
          'unused_local_variable',
          'public_member_api_docs',
        ])
        ..directives.add(Directive.import('package:ffi/ffi.dart'))
        ..body.add(_buildHandler(methods))
        ..body.addAll(
          etebase.classes
              .where((clazz) => clazz.isDataClass)
              .expand(_isolateConverterBuilder.buildConverterMethods),
        )
        ..body.addAll(methods.map(_buildImplementation)),
    );
  }

  List<MethodRef> _allMethods(EtebaseRef etebase) => etebase.classes
      .where((clazz) => !clazz.isDataClass)
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
          .statement,
    ]);

    return Method(
      (b) => b
        ..replace(_buildHandlerSignature())
        ..name = 'etebaseIsolateMessageHandler'
        ..annotations.add(Types.internal$)
        ..body = try$([
          caseBuilder,
        ]).finally$([
          poolRef.property('releaseScope').call(const []).statement,
        ]),
    );
  }

  Method _buildImplementation(MethodRef method) => Method(
        (b) {
          b
            ..replace(_buildHandlerSignature())
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
                ..name = _poolName
                ..type = Types.EtebasePool$,
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
