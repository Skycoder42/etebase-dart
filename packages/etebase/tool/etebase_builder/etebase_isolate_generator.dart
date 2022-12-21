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
    final emitter = DartEmitter.scoped(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    const IsolateBuilder().build(etebaseRef).accept(emitter, buffer);

    return buffer.toString();
  }
}
