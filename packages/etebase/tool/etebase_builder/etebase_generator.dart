import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'builders/ete_class_builder.dart';
import 'parsers/etebase_parser.dart';

class EtebaseGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    try {
      final context = EtebaseParser().parse(library);

      final buffer = StringBuffer();
      final emitter = DartEmitter(
        orderDirectives: true,
        useNullSafetySyntax: true,
      );

      final classBuilder = EteClassBuilder(context);

      Library(
        (b) => b
          ..directives.add(Directive.import('dart:typed_data'))
          ..body.addAll(context.classes.map(classBuilder.build)),
      ).accept(emitter, buffer);

      if (context.unprocessedMethods.isNotEmpty) {
        print(
          'Unprocessed methods: ${context.unprocessedMethods.map((e) => e.name).toList()}',
        );
      }

      return buffer.toString();
    } catch (e, s) {
      print(e);
      print(s);
      rethrow;
    }
  }
}
