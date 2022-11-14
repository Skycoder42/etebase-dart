import 'package:analyzer/dart/element/element.dart';
import 'package:source_helper/source_helper.dart';

import '../util/string_extensions.dart';

class EtebaseContext {
  final ClassElement libEtebaseFfi;
  final List<ClassElement> classes;
  final List<TypeAliasElement> typeDefs;
  final List<MethodElement> unprocessedMethods;

  EtebaseContext({
    required this.libEtebaseFfi,
    required this.classes,
    required this.typeDefs,
  }) : unprocessedMethods = libEtebaseFfi.methods {
    classes.sort((a, b) => b.name.compareTo(a.name));
  }

  TypeDefiningElement resolveAlias(ClassElement clazz) {
    for (final typedef in typeDefs) {
      if (typedef.aliasedType.element?.name == clazz.name) {
        return typedef;
      }
    }
    return clazz;
  }

  List<MethodElement> membersOf(
    TypeDefiningElement element, {
    bool markProcessed = true,
  }) {
    final methods = unprocessedMethods
        .where(
          (method) => method.name.startsWith(element.name!.snake),
        )
        .toList();
    if (markProcessed) {
      methods.forEach(unprocessedMethods.remove);
    }
    return methods;
  }

  String memberNameFor(TypeDefiningElement element, MethodElement method) {
    final prefix = element.name!.snake;
    return method.name.substring(prefix.length + 1).snakeToDart();
  }
}
