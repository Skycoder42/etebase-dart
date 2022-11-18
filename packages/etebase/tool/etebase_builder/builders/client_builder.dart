import 'package:code_builder/code_builder.dart';

import '../parsers/class_parser.dart';
import '../parsers/etebase_parser.dart';
import '../parsers/method_parser.dart';
import '../parsers/param_parser.dart';

class ClientBuilder {
  const ClientBuilder();

  Library build(EtebaseRef etebase) => Library(
        (b) => b
          ..body.addAll(
            etebase.functions.map((f) => _buildMethod(f, global: true)),
          )
          ..body.addAll(etebase.classes.map(_buildClass))
          ..body.add(_buildUtilsClass(etebase)),
      );

  Class _buildClass(ClassRef clazz) => Class(
        (b) => b
          ..name = clazz.name
          ..fields.addAll([
            Field(
              (b) => b
                ..name = '_finalizer'
                ..static = true
                ..modifier = FieldModifier.final$
                ..assignment = TypeReference((b) => b..symbol = 'Finalizer')
                    .newInstance([refer('_destroy')]).code,
            ),
            Field(
              (b) => b
                ..name = '_pointer'
                ..type = _pointerType(clazz.name)
                ..modifier = FieldModifier.final$,
            ),
          ])
          ..constructors.add(_buildConstructor())
          ..methods.addAll([
            ...clazz.methods
                .where((method) => !method.isPubkeySize)
                .where((method) => !method.isGetLength)
                .map(_buildMethod),
            _buildDispose(clazz.methods),
          ]),
      );

  Class _buildUtilsClass(EtebaseRef etebase) => Class(
        (b) => b
          ..name = 'EtebaseUtils'
          ..abstract = true
          ..constructors.add(Constructor((b) => b..name = '_'))
          ..methods.addAll(etebase.utilsFunctions.map(_buildMethod)),
      );

  Constructor _buildConstructor() => Constructor(
        (b) => b
          ..name = '_'
          ..requiredParameters.add(
            Parameter(
              (b) => b
                ..name = '_pointer'
                ..toThis = true,
            ),
          )
          ..body = Block(
            (b) => b.addExpression(
              refer('_finalizer').property('attach').call(
                [refer('this'), refer('_pointer')],
                {'detach': refer('this')},
              ),
            ),
          ),
      );

  Method _buildDispose(List<MethodRef> methods) => Method(
        (b) {
          b
            ..name = 'dispose'
            ..returns = TypeReference(
              (b) => b
                ..symbol = 'Future'
                ..types.add(TypeReference((b) => b..symbol = 'void')),
            )
            ..modifier = MethodModifier.async
            ..body = Block(
              (b) => b
                ..addExpression(
                  refer('_finalizer').property('detach').call([refer('this')]),
                )
                ..addExpression(
                  refer('_destroy').call([refer('_pointer')]).awaited,
                ),
            );

          final docs = methods
              .where((m) => m.isDestroy)
              .map((m) => m.element.documentationComment)
              .singleWhere(
                (comment) => comment != null,
                orElse: () => null,
              );

          if (docs != null) {
            b.docs.add('\n$docs');
          }
        },
      );

  Method _buildMethod(MethodRef method, {bool global = false}) => Method(
        (b) {
          final parameters = method.parameters
              .where((param) => method.isDestroy || !param.isThisParam)
              .where((param) => !param.isListLength)
              .where((param) => !param.isRetSize)
              .where((param) => !param.isOutParam)
              .map(_buildParameter)
              .toList();

          final invokeParameters = [
            if (!global && !method.isStatic && !method.isDestroy)
              refer('_pointer').property('address'),
            ...parameters.map((p) {
              final paramType = p.type!.type as TypeReference;
              if (paramType.symbol == 'Pointer') {
                return refer(p.name).property('address');
              }
              return refer(p.name);
            }),
          ];

          b
            ..name = _findMethodName(method)
            ..static = method.isStatic || method.isDestroy
            ..modifier = MethodModifier.async
            ..returns = TypeReference(
              (b) => b
                ..symbol = 'Future'
                ..types.add(_buildReturnType(method)),
            )
            ..requiredParameters.addAll(parameters)
            ..body = _buildBody(method);

          final docComment = method.element.documentationComment;
          if (docComment != null) {
            b.docs.add('\n$docComment');
          }
        },
      );

  String _findMethodName(MethodRef method) {
    if (method.isNew) {
      return 'create';
    } else if (method.isDestroy) {
      return '_destroy';
    } else {
      return method.name;
    }
  }

  Parameter _buildParameter(
    ParameterRef param,
  ) =>
      Parameter(
        (b) => b
          ..name = param.name
          ..type = param.isThisParam
              ? _asPointer(
                  TypeReference(
                    (b) => b
                      ..replace(param.type.dartType)
                      ..url = 'libetebase.ffi.dart',
                  ),
                )
              : param.type.dartType,
      );

  TypeReference _buildReturnType(MethodRef method) {
    final returnType = method.outOrReturnType.dartType;
    if (!method.hasOutParam && returnType.symbol == 'int') {
      return TypeReference((b) => b..symbol = 'void');
    }

    return returnType;
  }

  Code _buildBody(MethodRef method) {
    var expression = TypeReference(
      (b) => b
        ..symbol = 'EtebaseIsolate'
        ..url = '../../src/isolate/etebase_isolate.dart',
    ).property('current').property('invoke');

    final inParams = method.parameters
        .where((param) => !param.isListLength)
        .where((param) => !param.isRetSize)
        .where((param) => !param.isOutParam)
        .map((param) => _mapCallParam(param, method))
        .toList();

    expression = expression.call([
      refer('#${method.element.name}'),
      if (inParams.isEmpty) literalConstList([]) else literalList(inParams),
    ]);

    return expression.code;
  }

  Expression _mapCallParam(ParameterRef param, MethodRef method) {
    if (param.isThisParam) {
      final ref = method.isDestroy ? refer(param.name) : refer('_pointer');
      return ref.property('address');
    }

    if (param.type.isOpaquePointer) {
      if (param.isList) {
        return refer(param.name)
            .property('map')
            .call([
              Method(
                (b) => b
                  ..requiredParameters.add(
                    Parameter((b) => b..name = 'element'),
                  )
                  ..body = refer('element')
                      .property('_pointer')
                      .property('address')
                      .code,
              ).closure,
            ])
            .property('toList')
            .call(const []);
      } else {
        return refer(param.name).property('_pointer').property('address');
      }
    }

    return refer(param.name);
  }

  TypeReference _asPointer(TypeReference type) => TypeReference(
        (b) => b
          ..symbol = 'Pointer'
          ..url = 'dart:ffi'
          ..types.add(type),
      );

  TypeReference _pointerType(String name) => _asPointer(
        TypeReference(
          (b) => b
            ..symbol = name
            ..url = 'libetebase.ffi.dart',
        ),
      );
}
