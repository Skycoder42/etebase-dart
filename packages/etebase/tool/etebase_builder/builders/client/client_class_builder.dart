import 'package:code_builder/code_builder.dart';

import '../../parsers/class_parser.dart';
import '../../parsers/method_parser.dart';
import '../../util/types.dart';
import 'client_method_builder.dart';

class ClientClassBuilder {
  final ClientMethodBuilder _clientMethodBuilder;

  const ClientClassBuilder([
    this._clientMethodBuilder = const ClientMethodBuilder(),
  ]);

  Class buildClass(ClassRef clazz) => Class(
        (b) => b
          ..name = clazz.name
          ..fields.addAll([
            Field(
              (b) => b
                ..name = '_finalizer'
                ..static = true
                ..modifier = FieldModifier.final$
                ..assignment =
                    refer('Finalizer').newInstance([refer('_destroy')]).code,
            ),
            Field(
              (b) => b
                ..name = '_pointer'
                ..type = Types.pointer(
                  Types.ffi(refer(clazz.name)),
                )
                ..modifier = FieldModifier.final$,
            ),
          ])
          ..constructors.add(_buildConstructor())
          ..methods.addAll([
            ...clazz.methods
                .where((method) => !method.isGetLength)
                .map(_clientMethodBuilder.buildMethod),
            _buildDispose(clazz.methods),
          ]),
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
            ..returns = Types.future(Types.void$)
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
}
