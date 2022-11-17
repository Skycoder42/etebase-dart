import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'class_parser.dart';
import 'method_parser.dart';

class TypedefRef {
  final List<TypeAliasElement> _typeAliases;

  const TypedefRef(this._typeAliases);

  TypeAliasElement? typedefFor(ClassElement clazz) {
    for (final typeAlias in _typeAliases) {
      if (typeAlias.aliasedType.element?.name == clazz.name) {
        return typeAlias;
      }
    }
    return null;
  }

  TypeDefiningElement elementFor(ClassElement clazz) {
    final typeAlias = typedefFor(clazz);
    return (typeAlias ?? clazz) as TypeDefiningElement;
  }
}

class EtebaseRef {
  final ClassElement libEtebaseFfi;

  final List<ClassRef> classes;
  final List<MethodRef> utilsFunctions;
  final List<MethodRef> functions;

  final TypedefRef typeDefs;

  const EtebaseRef({
    required this.libEtebaseFfi,
    required this.classes,
    required this.utilsFunctions,
    required this.functions,
    required this.typeDefs,
  });
}

class EtebaseParser {
  static const _etebaseUtilsPrefix = 'etebase_utils';

  final ClassParser _classParser;
  final MethodParser _methodParser;

  const EtebaseParser([
    this._classParser = const ClassParser(),
    this._methodParser = const MethodParser(),
  ]);

  EtebaseRef parse(LibraryReader library) {
    final libEtebaseFfi = ArgumentError.checkNotNull(
      library.findType('LibEtebaseFFI'),
    );
    final libEtebaseFfiMethods = libEtebaseFfi.methods
        .where((method) => !method.name.startsWith('etebase_error_'))
        .toList();

    final typeDefs = TypedefRef(
      library.allElements.whereType<TypeAliasElement>().toList(),
    );

    final classElements = library.classes
        .where((element) => element != libEtebaseFfi)
        .toList()
      ..sort((a, b) => b.name.compareTo(a.name));

    return EtebaseRef(
      libEtebaseFfi: libEtebaseFfi,
      classes: classElements
          .map(
            (clazz) => _classParser.parse(
              clazz: clazz,
              libEtebaseFfiMethods: libEtebaseFfiMethods,
              typeDefs: typeDefs,
            ),
          )
          .toList(),
      utilsFunctions: _parseUtilsMethods(libEtebaseFfiMethods, typeDefs),
      functions: libEtebaseFfiMethods
          .map(
            (method) => _methodParser.parseGlobal(
              method: method,
              typeDefs: typeDefs,
            ),
          )
          .toList(),
      typeDefs: typeDefs,
    );
  }

  List<MethodRef> _parseUtilsMethods(
    List<MethodElement> libEtebaseFfiMethods,
    TypedefRef typeDefs,
  ) {
    final utilsMethods = libEtebaseFfiMethods
        .where((method) => method.name.startsWith(_etebaseUtilsPrefix))
        .toList()
      ..forEach(libEtebaseFfiMethods.remove);

    return utilsMethods
        .where((method) => !method.name.contains('base64'))
        .map(
          (method) => _methodParser.parseGlobal(
            method: method,
            typeDefs: typeDefs,
            methodPrefix: _etebaseUtilsPrefix,
          ),
        )
        .toList();
  }
}
