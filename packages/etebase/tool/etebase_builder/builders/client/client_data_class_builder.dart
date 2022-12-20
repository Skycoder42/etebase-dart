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
  final bool required;
  final String? docs;

  const _DataClassMember({
    required this.name,
    required this.type,
    required this.required,
    required this.docs,
  });

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
                ..optionalParameters.addAll(_mapMembers(clazz));
              if (constructorDocs != null) {
                b.docs.add(constructorDocs);
              }
            },
          ),
        )
        ..docs.add('/// The dart binding of the ${clazz.name} rust class'),
    );
  }

  Iterable<Parameter> _mapMembers(ClassRef clazz) sync* {
    final constructorParams = clazz.methods
        .singleWhere((m) => m.isNew)
        .parameters
        .where((p) => !p.isThisParam)
        .map(
          (p) => _DataClassMember(
            name: p.name,
            type: p.type,
            required: true,
            docs: null,
          ),
        );
    final methods = clazz.methods.reversed // sort ascending again
        .where((m) => !m.isNew && !m.isDestroy)
        .map(_mapMember);

    final members = _mergeMembers(methods.followedBy(constructorParams));

    for (final member in members) {
      yield Parameter(
        (b) {
          b
            ..name = member.name
            ..type = member.required
                ? member.type.publicType
                : member.type.publicType.asNullable
            ..named = true
            ..required = member.required;
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
          name: method.accessorName,
          type: _mapGetterType(method),
          required: false,
          docs: method.documentation,
        );
      case MethodKind.setter:
        return _DataClassMember(
          name: method.accessorName,
          type: _mapSetterType(method),
          required: false,
          docs: method.documentation,
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

  Set<_DataClassMember> _mergeMembers(Iterable<_DataClassMember> members) {
    final mergedMembers = <_DataClassMember>{};
    for (final member in members) {
      final added = mergedMembers.add(member);
      if (!added) {
        final existingMember = mergedMembers.singleWhere((m) => m == member);
        final mergedMember = _DataClassMember(
          name: existingMember.name,
          type: existingMember.type,
          required: existingMember.required || member.required,
          docs: existingMember.docs ?? member.docs,
        );
        mergedMembers
          ..remove(existingMember)
          ..add(mergedMember);
      }
    }
    return mergedMembers;
  }
}
