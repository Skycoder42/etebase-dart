import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

import '../../parsers/class_parser.dart';
import '../../parsers/method_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/types.dart';

@immutable
class _DataClassMember {
  final String name;
  final TypeRef type;
  final String? docs;

  const _DataClassMember(this.name, this.type, this.docs);

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is! _DataClassMember) {
      return false;
    } else {
      return name == other.name;
    }
  }
}

class ClientDataClassBuilder {
  const ClientDataClassBuilder();

  Class buildClass(ClassRef clazz) {
    final constructorDocs =
        clazz.methods.singleWhere((m) => m.isNew).documentation;

    return Class(
      (b) => b
        ..name = clazz.name
        ..annotations.add(Types.freezed$)
        ..mixins.add(refer('_\$${clazz.name}'))
        ..constructors.add(
          Constructor(
            (b) {
              b
                ..constant = true
                ..factory = true
                ..redirect = refer('_${clazz.name}')
                ..optionalParameters.addAll(mapMembers(clazz));
              if (constructorDocs != null) {
                b.docs.add(constructorDocs);
              }
            },
          ),
        )
        ..docs.add('/// The dart binding of the ${clazz.name} rust class\n'),
    );
  }

  Iterable<Parameter> mapMembers(ClassRef clazz) sync* {
    final members = clazz.methods.reversed // sort ascending again
        .where((m) => !m.isNew && !m.isDestroy)
        .map(_mapMember)
        .toSet();

    for (final member in members) {
      yield Parameter(
        (b) {
          b
            ..name = member.name
            ..type = member.type.publicType.asNullable
            ..named = true;
          if (member.docs != null) {
            b.docs.add(member.docs!);
          }
        },
      );
    }
  }

  _DataClassMember _mapMember(MethodRef method) {
    switch (method.methodKind) {
      case MethodKind.getter:
        return _DataClassMember(
          method.accessorName,
          _mapGetterType(method),
          method.documentation,
        );
      case MethodKind.setter:
        return _DataClassMember(
          method.accessorName,
          _mapSetterType(method),
          method.documentation,
        );
      case MethodKind.method:
        throw StateError('Unreachable code reached');
    }
  }

  TypeRef _mapGetterType(MethodRef method) {
    if (method.parameters.where((p) => !p.isThisParam).isNotEmpty) {
      throw StateError('Data class getter ${method.name} has extra arguments');
    }

    return method.returnType;
  }

  TypeRef _mapSetterType(MethodRef method) {
    final param = method.parameters.singleWhere((p) => !p.isThisParam);
    return param.type;
  }
}
