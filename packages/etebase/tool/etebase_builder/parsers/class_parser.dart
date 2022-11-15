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

class ClassContext {
  final ClassElement clazz;
  final List<MethodElement> libEtebaseFfiMethods;

  final TypedefRef typeDefs;

  const ClassContext(
    this.clazz,
    this.libEtebaseFfiMethods,
    this.typeDefs,
  );
}

class ClassParser {
  static const _memberPrefixMap = {
    'EtebaseFileSystemCache': 'etebase_fs_cache',
    'EtebaseCollectionInvitationManager': 'etebase_invitation_manager',
  };

  final MethodParser _methodParser;

  const ClassParser([this._methodParser = const MethodParser()]);

  ClassRef parse(ClassContext context) {
    final typeAlias = context.typeDefs.typedefFor(context.clazz);
    final resolvedType = (typeAlias ?? context.clazz) as TypeDefiningElement;
    final methodPrefix = _prefixFor(resolvedType);

    return ClassRef(
      element: context.clazz,
      typeAlias: typeAlias,
      name: resolvedType.name!,
      methods: _findMembers(context, resolvedType, methodPrefix)
          .map(
            (method) => _methodParser.parseMember(
              MemberMethodContext(
                method: method,
                clazz: resolvedType,
                typeDefs: context.typeDefs,
                methodPrefix: methodPrefix,
              ),
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
    ClassContext context,
    TypeDefiningElement resolvedType,
    String methodPrefix, {
    bool markProcessed = true,
  }) {
    final methods = context.libEtebaseFfiMethods
        .where((method) => method.name.startsWith(methodPrefix))
        .toList();
    if (markProcessed) {
      methods.forEach(context.libEtebaseFfiMethods.remove);
    }
    return methods;
  }
}
