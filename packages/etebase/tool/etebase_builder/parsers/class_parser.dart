import 'package:analyzer/dart/element/element.dart';
import 'package:source_helper/source_helper.dart';

import 'etebase_parser.dart';
import 'method_parser.dart';

class ClassRef {
  final ClassElement element;
  final TypeAliasElement? typeAlias;

  final String name;

  final List<MethodRef> methods;

  const ClassRef({
    required this.element,
    required this.typeAlias,
    required this.name,
    required this.methods,
  });
}

class ClassParser {
  static const _memberPrefixMap = {
    'EtebaseFileSystemCache': 'etebase_fs_cache',
    'EtebaseCollectionInvitationManager': 'etebase_invitation_manager',
  };

  final MethodParser _methodParser;

  const ClassParser([this._methodParser = const MethodParser()]);

  ClassRef parse({
    required ClassElement clazz,
    required List<MethodElement> libEtebaseFfiMethods,
    required TypedefRef typeDefs,
  }) {
    final typeAlias = typeDefs.typedefFor(clazz);
    final resolvedType = (typeAlias ?? clazz) as TypeDefiningElement;
    final methodPrefix = _prefixFor(resolvedType);

    return ClassRef(
      element: clazz,
      typeAlias: typeAlias,
      name: resolvedType.name!,
      methods: _findMembers(libEtebaseFfiMethods, resolvedType, methodPrefix)
          .map(
            (method) => _methodParser.parseMember(
              method: method,
              clazz: resolvedType,
              typeDefs: typeDefs,
              methodPrefix: methodPrefix,
            ),
          )
          .toList(),
    );
  }

  String _prefixFor(TypeDefiningElement clazz) {
    final className = clazz.name!;
    return _memberPrefixMap[className] ?? className.snake;
  }

  List<MethodElement> _findMembers(
    List<MethodElement> libEtebaseFfiMethods,
    TypeDefiningElement resolvedType,
    String methodPrefix, {
    bool markProcessed = true,
  }) {
    final methods = libEtebaseFfiMethods
        .where((method) => method.name.startsWith(methodPrefix))
        .toList();
    if (markProcessed) {
      methods.forEach(libEtebaseFfiMethods.remove);
    }
    return methods;
  }
}
