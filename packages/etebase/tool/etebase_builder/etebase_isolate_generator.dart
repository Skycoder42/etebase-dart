import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'builders/isolate/isolate_builder.dart';
import 'parsers/etebase_parser.dart';

class EtebaseIsolateGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
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
      'cast_nullable_to_non_nullable',
      'unnecessary_parenthesis',
      'prefer_relative_imports',
    ].join(', '),
  );
