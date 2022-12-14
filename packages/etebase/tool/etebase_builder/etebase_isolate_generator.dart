import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'builders/isolate/isolate_builder.dart';
import 'parsers/etebase_parser.dart';
import 'restorable_generator.dart';

class EtebaseIsolateGenerator extends RestorableGenerator {
  EtebaseIsolateGenerator({required super.restoreMode});

  @override
  String generateImpl(LibraryReader library, BuildStep buildStep) {
    final etebaseRef = const EtebaseParser().parse(library);

    final buffer = StringBuffer();
    _writeIgnoreComment(buffer);

    final emitter = DartEmitter.scoped(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    const IsolateBuilder().build(etebaseRef).accept(emitter, buffer);

    return buffer.toString();
  }
}

void _writeIgnoreComment(StringBuffer buffer) => buffer
  ..write('// ignore_for_file: ')
  ..writeln(
    const [
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
    ].join(', '),
  );
