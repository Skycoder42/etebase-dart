import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'builders/client_builder.dart';
import 'parsers/etebase_parser.dart';

class EtebaseGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    try {
      const parser = EtebaseParser();
      const clientBuilder = ClientBuilder();

      final buffer = StringBuffer()
        ..writeln(
          '// ignore_for_file: require_trailing_commas, avoid_positional_boolean_parameters, lines_longer_than_80_chars',
        );
      final emitter = DartEmitter.scoped(
        orderDirectives: true,
        useNullSafetySyntax: true,
      );

      final etebaseRef = parser.parse(library);
      clientBuilder.build(etebaseRef).accept(emitter, buffer);

      return buffer.toString();
    } catch (e, s) {
      print(e);
      print(s);
      rethrow;
    }
  }
}
