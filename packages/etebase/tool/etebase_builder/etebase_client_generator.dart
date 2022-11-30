import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'builders/client/client_builder.dart';
import 'parsers/etebase_parser.dart';
import 'restorable_generator.dart';

class EtebaseClientGenerator extends RestorableGenerator {
  EtebaseClientGenerator({required super.restoreMode});

  @override
  String generateImpl(LibraryReader library, BuildStep buildStep) {
    final etebaseRef = const EtebaseParser().parse(library);

    final buffer = StringBuffer();
    _writeIgnoreComment(buffer);

    final emitter = DartEmitter.scoped(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    const ClientBuilder().build(etebaseRef).accept(emitter, buffer);

    return buffer.toString();
  }
}

void _writeIgnoreComment(StringBuffer buffer) => buffer
  ..write('// ignore_for_file: ')
  ..writeln(
    const [
      'require_trailing_commas',
      'avoid_positional_boolean_parameters',
      'lines_longer_than_80_chars',
      'comment_references',
      'prefer_relative_imports',
      'prefer_if_elements_to_conditional_expressions',
    ].join(', '),
  );
