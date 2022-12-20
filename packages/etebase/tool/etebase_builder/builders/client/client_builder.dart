import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';

import '../../parsers/etebase_parser.dart';
import 'client_class_builder.dart';
import 'client_data_class_builder.dart';
import 'client_method_builder.dart';

class ClientBuilder {
  final ClientDataClassBuilder _clientDataClassBuilder;
  final ClientClassBuilder _clientClassBuilder;
  final ClientMethodBuilder _clientMethodBuilder;

  const ClientBuilder([
    this._clientDataClassBuilder = const ClientDataClassBuilder(),
    this._clientClassBuilder = const ClientClassBuilder(),
    this._clientMethodBuilder = const ClientMethodBuilder(),
  ]);

  Library build(EtebaseRef etebase, AssetId assetId) => Library(
        (b) => b
          ..directives.add(
            Directive.import(
              'package:freezed_annotation/freezed_annotation.dart',
            ),
          )
          ..directives.add(
            Directive.part(
              assetId.changeExtension('.freezed.dart').pathSegments.last,
            ),
          )
          ..body.addAll(
            etebase.functions.map(
              (f) => _clientMethodBuilder.buildMethod(f, global: true),
            ),
          )
          ..body.addAll(
            etebase.classes
                .where((clazz) => clazz.isDataClass)
                .map(_clientDataClassBuilder.buildClass),
          )
          ..body.addAll(
            etebase.classes
                .where((clazz) => !clazz.isDataClass)
                .map(_clientClassBuilder.buildClass),
          )
          ..body.add(_buildUtilsClass(etebase)),
      );

  Class _buildUtilsClass(EtebaseRef etebase) => Class(
        (b) => b
          ..name = 'EtebaseUtils'
          ..abstract = true
          ..constructors.add(Constructor((b) => b..name = '_'))
          ..methods.addAll(
            etebase.utilsFunctions.map(
              (m) => _clientMethodBuilder.buildMethod(
                m,
                isUtil: true,
              ),
            ),
          )
          ..docs.add('/// The dart binding of the EtebaseUtils rust class'),
      );
}
