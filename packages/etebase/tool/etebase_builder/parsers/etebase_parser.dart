import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../util/string_extensions.dart';
import 'class_parser.dart';
import 'method_parser.dart';
import 'type_parse.dart';

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
  final TypeParser _typeParser;

  const EtebaseParser([
    this._classParser = const ClassParser(),
    this._methodParser = const MethodParser(),
    this._typeParser = const TypeParser(),
  ]);

  EtebaseRef parse(LibraryReader library) {
    final libEtebaseFfi = ArgumentError.checkNotNull(
      library.findType('LibEtebaseFFI'),
    );
    final libEtebaseFfiMethods = libEtebaseFfi.methods
        .where((method) => method.isPublic)
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
      utilsFunctions: _parseUtilsMethods(
        libEtebaseFfi,
        libEtebaseFfiMethods,
        typeDefs,
      ),
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
    ClassElement libEtebaseFfi,
    List<MethodElement> libEtebaseFfiMethods,
    TypedefRef typeDefs,
  ) {
    final getters = libEtebaseFfi.accessors
        .where((accessor) => accessor.isPublic && accessor.isGetter)
        .map((getter) => _parseGetter(getter, typeDefs));

    final utilsMethods = libEtebaseFfiMethods
        .where((method) => method.name.startsWith(_etebaseUtilsPrefix))
        .toList()
      ..forEach(libEtebaseFfiMethods.remove);

    final methods =
        utilsMethods.where((method) => !method.name.contains('base64')).map(
              (method) => _methodParser.parseGlobal(
                method: method,
                typeDefs: typeDefs,
                methodPrefix: _etebaseUtilsPrefix,
                forceStatic: true,
              ),
            );

    return getters.followedBy(methods).toList();
  }

  MethodRef _parseGetter(
    PropertyAccessorElement getter,
    TypedefRef typeDefs,
  ) {
    assert(
      getter.name.startsWith('ETEBASE_UTILS_'),
      'Can only parse utils getters',
    );

    return MethodRef(
      element: getter,
      name: getter.name.toLowerCase().substring(14).snakeToDart(),
      isNew: false,
      isDestroy: false,
      isGetLength: false,
      isStatic: false,
      isGetter: true,
      parameters: const [],
      returnType: _typeParser.parseType(
        type: getter.returnType,
        typeDefs: typeDefs,
      ),
    );
  }
}
