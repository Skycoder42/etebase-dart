import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'etebase_context.dart';

class EtebaseParser {
  EtebaseContext parse(LibraryReader library) => EtebaseContext(
        libEtebaseFfi: ArgumentError.checkNotNull(
          library.findType('LibEtebaseFFI'),
        ),
        classes: library.classes
            .where((element) => element.name != 'LibEtebaseFFI')
            .toList(),
        typeDefs: library.allElements.whereType<TypeAliasElement>().toList(),
      );
}
