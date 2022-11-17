import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import '../util/string_extensions.dart';
import 'etebase_parser.dart';
import 'param_parser.dart';
import 'type_parse.dart';

class MethodRef {
  final MethodElement element;

  final String name;

  final bool isNew;
  final bool isDestroy;
  final bool isPubkeySize;
  final bool isGetLength;
  final bool isStatic;

  final List<ParameterRef> parameters;
  final TypeRef returnType;

  const MethodRef({
    required this.element,
    required this.name,
    required this.isNew,
    required this.isDestroy,
    required this.isPubkeySize,
    required this.isGetLength,
    required this.isStatic,
    required this.parameters,
    required this.returnType,
  });

  bool get hasRetSize => parameters.any((p) => p.isRetSize);

  bool get hasOutParam => parameters.any((p) => p.isOutParam);

  TypeRef get outOrReturnType => parameters
      .where((p) => p.isOutParam && !p.noReturn)
      .map((p) => p.type)
      .singleWhere((_) => true, orElse: () => returnType);
}

class MethodParser {
  static final _isGetLengthRegExp = RegExp('_get_.*_length');

  static final _returnTypeMapping = {
    RegExp(r'.*_pubkey$'): TypeReference(
      (b) => b
        ..symbol = 'Uint8List'
        ..url = 'dart:typed_data',
    ),
    RegExp(r'.*_get_access_level$'): TypeReference(
      (b) => b
        ..symbol = 'EtebaseCollectionAccessLevel'
        ..url = '../../src/model/etebase_collection_access_level.dart',
    ),
    'etebase_signed_invitation_get_from_username': TypeReference(
      (b) => b..symbol = 'String',
    ),
    'etebase_client_check_etebase_server': TypeReference(
      (b) => b..symbol = 'bool',
    ),
    'etebase_utils_pretty_fingerprint': TypeReference(
      (b) => b..symbol = 'String',
    ),
  };

  final ParamParser _paramParser;
  final TypeParser _typeParser;

  const MethodParser([
    this._paramParser = const ParamParser(),
    this._typeParser = const TypeParser(),
  ]);

  MethodRef parseMember({
    required MethodElement method,
    required TypeDefiningElement clazz,
    required String methodPrefix,
    required TypedefRef typeDefs,
  }) {
    final methodName = method.name;

    final mappedParams = _paramParser.parse(
      methodName: method.name,
      parameters: method.parameters,
      typeDefs: typeDefs,
    );

    return MethodRef(
      element: method,
      name: methodName.substring(methodPrefix.length + 1).snakeToDart(),
      isNew: methodName.endsWith('_new'),
      isDestroy: methodName.endsWith('_destroy'),
      isPubkeySize: methodName.endsWith('_pubkey_size'),
      isGetLength: _isGetLengthRegExp.hasMatch(methodName),
      isStatic: !mappedParams.any((p) => p.isThisParam),
      parameters: mappedParams,
      returnType: _mapReturnType(
        method,
        mappedParams.any((p) => p.isRetSize),
        typeDefs,
      ),
    );
  }

  MethodRef parseGlobal({
    required MethodElement method,
    String? methodPrefix,
    required TypedefRef typeDefs,
    bool forceStatic = false,
  }) {
    final prefixLength = methodPrefix?.length ?? -1;

    final mappedParams = _paramParser.parse(
      methodName: method.name,
      parameters: method.parameters,
      typeDefs: typeDefs,
    );

    return MethodRef(
      element: method,
      name: method.name.substring(prefixLength + 1).snakeToDart(),
      isNew: false,
      isDestroy: false,
      isPubkeySize: false,
      isGetLength: _isGetLengthRegExp.hasMatch(method.name),
      isStatic: forceStatic,
      parameters: mappedParams,
      returnType: _mapReturnType(
        method,
        mappedParams.any((p) => p.isRetSize),
        typeDefs,
      ),
    );
  }

  TypeRef _mapReturnType(
    MethodElement method,
    bool hasRetSize,
    TypedefRef typeDefs,
  ) {
    final mappedType = _returnTypeMapping.entries
        .where((entry) => entry.key.matchAsPrefix(method.name) != null)
        .map((entry) => entry.value)
        .cast<TypeReference?>()
        .firstWhere((_) => true, orElse: () => null);

    if (mappedType != null) {
      return TypeRef(
        ffiType: method.returnType,
        dartType: mappedType,
      );
    } else {
      return _typeParser.parseType(
        type: method.returnType,
        isArray: hasRetSize,
        typeDefs: typeDefs,
      );
    }
  }
}
