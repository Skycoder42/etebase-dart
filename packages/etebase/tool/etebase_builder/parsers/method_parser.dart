import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import '../util/string_extensions.dart';
import 'etebase_parser.dart';
import 'type_parse.dart';

class ParameterRef {
  final ParameterElement element;

  final String name;

  final bool isThisParam;
  final bool isList;
  final bool isListLength;
  final bool isRetSize;

  final TypeRef type;

  const ParameterRef({
    required this.element,
    required this.name,
    required this.isThisParam,
    required this.isList,
    required this.isListLength,
    required this.isRetSize,
    required this.type,
  });
}

class MethodRef {
  final MethodElement element;

  final String name;

  final bool isNew;
  final bool isDestroy;
  final bool isPubkeySize;
  final bool isStatic;

  final List<ParameterRef> parameters;
  final TypeRef returnType;

  const MethodRef({
    required this.element,
    required this.name,
    required this.isNew,
    required this.isDestroy,
    required this.isPubkeySize,
    required this.isStatic,
    required this.parameters,
    required this.returnType,
  });

  bool get hasRetSize => parameters.any((p) => p.isRetSize);
}

class MethodContext {
  final MethodElement method;
  final TypedefRef typeDefs;

  const MethodContext({
    required this.method,
    required this.typeDefs,
  });
}

class MemberMethodContext extends MethodContext {
  final TypeDefiningElement clazz;
  final String methodPrefix;

  MemberMethodContext({
    required super.method,
    required super.typeDefs,
    required this.clazz,
    required this.methodPrefix,
  });
}

class GlobalMethodContext extends MethodContext {
  final String? methodPrefix;

  GlobalMethodContext({
    required super.method,
    required super.typeDefs,
    required this.methodPrefix,
  });
}

class MethodParser {
  static const _thisParamName = 'this_';

  static final _returnTypeMapping = {
    'etebase_user_profile_get_pubkey': TypeReference(
      (b) => b
        ..symbol = 'Uint8List'
        ..url = 'dart:typed_data',
    ),
    'etebase_invitation_manager_get_pubkey': TypeReference(
      (b) => b
        ..symbol = 'Uint8List'
        ..url = 'dart:typed_data',
    ),
    'etebase_signed_invitation_get_from_pubkey': TypeReference(
      (b) => b
        ..symbol = 'Uint8List'
        ..url = 'dart:typed_data',
    ),
    'etebase_signed_invitation_get_from_username': TypeReference(
      (b) => b..symbol = 'String',
    ),
  };

  final TypeParser _typeParser;

  const MethodParser([this._typeParser = const TypeParser()]);

  MethodRef parseMember(MemberMethodContext context) {
    final methodName = context.method.name;

    final mappedParams = _mapParameters(
      context.method,
      context.typeDefs,
    ).toList();

    return MethodRef(
      element: context.method,
      name: methodName.substring(context.methodPrefix.length + 1).snakeToDart(),
      isNew: methodName.endsWith('_new'),
      isDestroy: methodName.endsWith('_destroy'),
      isPubkeySize: methodName.endsWith('_pubkey_size'),
      isStatic: _isStatic(context.method),
      parameters: mappedParams,
      returnType: _mapReturnType(
        context.method,
        mappedParams.any((p) => p.isRetSize),
        context.typeDefs,
      ),
    );
  }

  MethodRef parseGlobal(GlobalMethodContext context) {
    final prefixLength = context.methodPrefix?.length ?? -1;

    final mappedParams = _mapParameters(
      context.method,
      context.typeDefs,
    ).toList();

    return MethodRef(
      element: context.method,
      name: context.method.name.substring(prefixLength + 1).snakeToDart(),
      isNew: false,
      isDestroy: false,
      isPubkeySize: false,
      isStatic: true,
      parameters: mappedParams,
      returnType: _mapReturnType(
        context.method,
        mappedParams.any((p) => p.isRetSize),
        context.typeDefs,
      ),
    );
  }

  bool _isStatic(MethodElement method) {
    if (method.parameters.isEmpty) {
      return true;
    }

    return method.parameters.first.name != _thisParamName;
  }

  Iterable<ParameterRef> _mapParameters(
    MethodElement method,
    TypedefRef typeDefs,
  ) sync* {
    final params = method.parameters;
    for (var i = 0; i < params.length; ++i) {
      final param = params[i];
      final nextParam = i < params.length - 1 ? params[i + 1] : null;

      if (nextParam != null && nextParam.name == '${param.name}_size') {
        ++i; // skip the _size param

        yield ParameterRef(
          element: param,
          name: param.name.snakeToDart(),
          isThisParam: false,
          isList: true,
          isListLength: false,
          isRetSize: false,
          type: _typeParser.parseType(
            TypeContext(
              type: param.type,
              isArray: true,
              typeDefs: typeDefs,
            ),
          ),
        );

        yield ParameterRef(
          element: nextParam,
          name: nextParam.name.snakeToDart(),
          isThisParam: false,
          isList: false,
          isListLength: true,
          isRetSize: false,
          type: _typeParser.parseType(
            TypeContext(
              type: param.type,
              isArray: false,
              typeDefs: typeDefs,
            ),
          ),
        );
      } else {
        yield ParameterRef(
          element: param,
          name: param.name.snakeToDart(),
          isThisParam: param.name == _thisParamName,
          isList: false,
          isListLength: false,
          isRetSize: param.name == 'ret_size',
          type: _typeParser.parseType(
            TypeContext(
              type: param.type,
              isArray: false,
              typeDefs: typeDefs,
            ),
          ),
        );
      }
    }
  }

  TypeRef _mapReturnType(
    MethodElement method,
    bool hasRetSize,
    TypedefRef typeDefs,
  ) {
    final mappedType = _returnTypeMapping[method.name];
    if (mappedType != null) {
      return TypeRef(method.returnType, mappedType);
    } else {
      return _typeParser.parseType(
        TypeContext(
          type: method.returnType,
          isArray: hasRetSize,
          typeDefs: typeDefs,
        ),
      );
    }
  }
}
