import 'package:code_builder/code_builder.dart';

import '../../parsers/etebase_parser.dart';
import 'client_class_builder.dart';
import 'client_method_builder.dart';

class ClientBuilder {
  final ClientClassBuilder _clientClassBuilder;
  final ClientMethodBuilder _clientMethodBuilder;

  const ClientBuilder([
    this._clientClassBuilder = const ClientClassBuilder(),
    this._clientMethodBuilder = const ClientMethodBuilder(),
  ]);

  Library build(EtebaseRef etebase) => Library(
        (b) => b
          ..body.addAll(
            etebase.functions.map(
              (f) => _clientMethodBuilder.buildMethod(f, global: true),
            ),
          )
          ..body.addAll(etebase.classes.map(_clientClassBuilder.buildClass))
          ..body.add(_buildUtilsClass(etebase)),
      );

  Class _buildUtilsClass(EtebaseRef etebase) => Class(
        (b) => b
          ..name = 'EtebaseUtils'
          ..abstract = true
          ..constructors.add(Constructor((b) => b..name = '_'))
          ..methods.addAll(
            etebase.utilsFunctions.map(_clientMethodBuilder.buildMethod),
          ),
      );
}
