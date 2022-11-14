import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import '../parsers/etebase_context.dart';
import '../parsers/etebase_type_parse.dart';
import '../util/ref.dart';
import '../util/string_extensions.dart';

class EteClassBuilder {
  static const thisParamName = 'this_';

  static final _returnTypeMapping = {
    'etebase_user_profile_get_pubkey': TypeReference(
      (b) => b..symbol = 'Uint8List',
    ),
    'etebase_invitation_manager_get_pubkey': TypeReference(
      (b) => b..symbol = 'Uint8List',
    ),
    'etebase_signed_invitation_get_from_pubkey': TypeReference(
      (b) => b..symbol = 'Uint8List',
    ),
    'etebase_signed_invitation_get_from_username': TypeReference(
      (b) => b..symbol = 'String',
    ),
  };

  final EtebaseContext context;

  EteClassBuilder(this.context);

  Class build(ClassElement clazz) {
    final resolvedClass = context.resolveAlias(clazz);
    return Class(
      (b) => b
        ..name = resolvedClass.name
        ..methods.addAll(
          context
              .membersOf(resolvedClass)
              .where((method) => !method.name.endsWith('_new'))
              .where((method) => !method.name.endsWith('_destroy'))
              .where((method) => !method.name.endsWith('_pubkey_size'))
              .map((method) => _buildMethod(resolvedClass, method)),
        ),
    );
  }

  Method _buildMethod(TypeDefiningElement clazz, MethodElement method) {
    final hasRetSizeRef = Ref<bool>.value(false);
    final mappedParameters = _mapParameters(method, hasRetSizeRef);
    return Method(
      (b) => b
        ..name = context.memberNameFor(clazz, method)
        ..static = _isStatic(method)
        ..modifier = MethodModifier.async
        ..returns = _mapReturnType(method, hasRetSizeRef)
        ..requiredParameters.addAll(mappedParameters)
        ..body = Block(),
    );
  }

  bool _isStatic(MethodElement method) {
    if (method.parameters.isEmpty) {
      return true;
    }

    return method.parameters.first.name != thisParamName;
  }

  Iterable<Parameter> _mapParameters(
    MethodElement method,
    Ref<bool> hasRetSize,
  ) sync* {
    hasRetSize.value = false;
    final params = method.parameters;
    for (var i = 0; i < params.length; ++i) {
      final param = params[i];
      final nextParam = i < params.length - 1 ? params[i + 1] : null;

      if (param.name == thisParamName) {
        continue;
      }

      if (param.name == 'ret_size') {
        hasRetSize.value = true;
        continue;
      }

      final Reference type;
      if (nextParam != null && nextParam.name == '${param.name}_size') {
        ++i; // skip the _size param
        type = const EtebaseTypeParser().parseType(param.type, isArray: true);
      } else {
        type = const EtebaseTypeParser().parseType(param.type);
      }

      yield Parameter(
        (b) => b
          ..name = param.name.snakeToDart()
          ..type = type,
      );
    }
  }

  Reference _mapReturnType(MethodElement method, Ref<bool> hasRetSizeRef) =>
      _returnTypeMapping[method.name] ??
      const EtebaseTypeParser().parseType(
        method.returnType,
        isArray: hasRetSizeRef.value,
      );
}
