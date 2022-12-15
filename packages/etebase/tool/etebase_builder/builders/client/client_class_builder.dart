import 'package:code_builder/code_builder.dart';

import '../../parsers/class_parser.dart';
import '../../parsers/method_parser.dart';
import '../../util/expression_extensions.dart';
import '../../util/if_then.dart';
import '../../util/types.dart';
import 'client_method_builder.dart';

class ClientClassBuilder {
  static const _finalizerName = '_finalizer';
  static const _finalizerRef = Reference(_finalizerName);
  static const pointerName = '_pointer';
  static const pointerRef = Reference(pointerName);
  static const _ownerName = '_owner';
  static const _ownedRef = Reference(_ownerName);
  static const _destroyMethodRef = Reference('_destroy');

  final ClientMethodBuilder _clientMethodBuilder;

  const ClientClassBuilder([
    this._clientMethodBuilder = const ClientMethodBuilder(),
  ]);

  Class buildClass(ClassRef clazz) {
    if (!clazz.hasDestroy) {
      throw UnsupportedError('Can only build destroyable classes');
    }

    return Class(
      (b) => b
        ..name = clazz.name
        ..fields.addAll([
          Field(
            (b) => b
              ..name = _finalizerName
              ..static = true
              ..modifier = FieldModifier.final$
              ..assignment = TypeReference((b) => b..symbol = 'Finalizer')
                  .newInstance([_destroyMethodRef]).code,
          ),
          Field(
            (b) => b
              ..name = pointerName
              ..type = Types.pointer(
                Types.ffi(refer(clazz.name)),
              )
              ..modifier = FieldModifier.final$,
          ),
          Field(
            (b) => b
              ..name = _ownerName
              ..type = Types.Object$.asNullable
              ..modifier = FieldModifier.final$,
          )
        ])
        ..constructors.add(_buildConstructor())
        ..methods.addAll([
          ...clazz.methods.map(_clientMethodBuilder.buildMethod),
          _buildDispose(clazz.methods),
        ])
        ..docs.add('/// The dart binding of the ${clazz.name} rust class\n'),
    );
  }

  Constructor _buildConstructor() => Constructor(
        (b) => b
          ..name = '_'
          ..requiredParameters.add(
            Parameter(
              (b) => b
                ..name = pointerName
                ..toThis = true,
            ),
          )
          ..optionalParameters.add(
            Parameter(
              (b) => b
                ..name = _ownerName
                ..toThis = true,
            ),
          )
          ..body = if$(_ownedRef.equalTo(literalNull), [
            _finalizerRef.property('attach').call(
              [literalThis, pointerRef],
              {'detach': literalThis},
            ).statement,
          ]),
      );

  Method _buildDispose(List<MethodRef> methods) => Method(
        (b) {
          b
            ..name = 'dispose'
            ..returns = Types.future(Types.void$)
            ..modifier = MethodModifier.async
            ..body = if$(_ownedRef.equalTo(literalNull), [
              _finalizerRef.property('detach').call([literalThis]).statement,
              _destroyMethodRef.call([pointerRef]).awaited.statement,
            ]);

          final docs = methods
              .where((m) => m.isDestroy)
              .map((m) => m.documentation)
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
