import 'package:analyzer/dart/element/element.dart';

import '../util/string_extensions.dart';
import 'etebase_parser.dart';
import 'param_parser.dart';
import 'type_parse.dart';
import 'type_ref.dart';

class MethodRef {
  final String name;
  final String ffiName;

  final bool isNew;
  final bool isDestroy;
  // TODO simply skip getLength methods and replace with "hasLengthGetter"
  final bool isGetLength;
  final bool isStatic;
  final bool isGetter;

  final List<ParameterRef> parameters;
  final TypeRef returnType;

  final String? documentation;

  const MethodRef({
    required this.name,
    required this.ffiName,
    required this.isNew,
    required this.isDestroy,
    required this.isGetLength,
    required this.isStatic,
    required this.isGetter,
    required this.parameters,
    required this.returnType,
    required this.documentation,
  });

  bool get hasOutParam => parameters.any((p) => p.isOutParam);

  bool get hasRetSize => parameters.any((p) => p.isRetSize);

  bool get needsSizeHint => parameters.any((p) => p.needsSizeHint);

  Iterable<ParameterRef> exportedParams({required bool withThis}) => parameters
      .where((param) => withThis || isDestroy || !param.isThisParam)
      .where((param) => !param.isRetSize)
      .where((param) => !param.isOutParam);

  TypeRef get outOrReturnType => parameters
      .where((p) => p.isOutParam)
      .map((p) => p.type)
      .singleWhere((_) => true, orElse: () => returnType);
}

class MethodParser {
  static final _isGetLengthRegExp = RegExp('_get_.*_(length|size)');

  static final _returnTypeMapping = {
    RegExp(r'.*_pubkey$'): TypeRef.byteArray(),
    RegExp(r'.*_get_access_level$'): TypeRef.etebaseCollectionAccessLevel(),
    'etebase_signed_invitation_get_from_username': TypeRef.string(),
    'etebase_client_check_etebase_server': TypeRef.bool(fromInt: true),
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
      name: methodName.substring(methodPrefix.length + 1).snakeToDart(),
      ffiName: methodName,
      isNew: methodName.endsWith('_new'),
      isDestroy: methodName.endsWith('_destroy'),
      isGetLength: _isGetLengthRegExp.hasMatch(methodName),
      isStatic: !mappedParams.any((p) => p.isThisParam),
      isGetter: false,
      parameters: mappedParams,
      returnType: _mapReturnType(
        method,
        mappedParams.any((p) => p.isRetSize),
        typeDefs,
      ),
      documentation: method.documentationComment,
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
      name: method.name.substring(prefixLength + 1).snakeToDart(),
      ffiName: method.name,
      isNew: false,
      isDestroy: false,
      isGetLength: _isGetLengthRegExp.hasMatch(method.name),
      isStatic: forceStatic,
      isGetter: false,
      parameters: mappedParams,
      returnType: _mapReturnType(
        method,
        mappedParams.any((p) => p.isRetSize),
        typeDefs,
      ),
      documentation: method.documentationComment,
    );
  }

  TypeRef _mapReturnType(
    MethodElement method,
    bool hasRetSize,
    TypedefRef typeDefs,
  ) =>
      _returnTypeMapping.entries
          .where((entry) => entry.key.matchAsPrefix(method.name) != null)
          .map((entry) => entry.value)
          .singleWhere(
            (_) => true,
            orElse: () => _typeParser.parseType(
              type: method.returnType,
              isArray: hasRetSize,
              typeDefs: typeDefs,
              asReturn: true,
            ),
          );
}
