import 'package:analyzer/dart/element/element.dart';

import '../util/string_extensions.dart';
import 'etebase_parser.dart';
import 'param_parser.dart';
import 'type_parse.dart';
import 'type_ref.dart';

enum LengthGetterType {
  none(false),
  length(true),
  size(true),
  constant(true);

  final bool hasLengthGetter;

  // ignore: avoid_positional_boolean_parameters
  const LengthGetterType(this.hasLengthGetter);
}

enum MethodKind {
  method(null),
  getter('get'),
  setter('set');

  final String? _infix;

  const MethodKind(this._infix);

  RegExp? get matcher => _infix == null ? null : RegExp('^.+_${_infix}_(.+)\$');
}

class MethodRef {
  final String name;
  final String ffiName;

  final bool isNew;
  final bool isDestroy;
  final bool isStatic;
  final LengthGetterType lengthGetter;
  final MethodKind methodKind;

  final List<ParameterRef> parameters;
  final TypeRef returnType;

  final String? documentation;

  const MethodRef({
    required this.name,
    required this.ffiName,
    required this.isNew,
    required this.isDestroy,
    required this.isStatic,
    required this.lengthGetter,
    required this.methodKind,
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

  ParameterRef get outParam => parameters.singleWhere((p) => p.isOutParam);

  TypeRef get outOrReturnType => parameters
      .where((p) => p.isOutParam)
      .map((p) => p.type)
      .singleWhere((_) => true, orElse: () => returnType);

  String get ffiLengthGetterName {
    switch (lengthGetter) {
      case LengthGetterType.none:
        throw UnsupportedError(
          'Cannot get length-getter of method $ffiName without lengthGetter',
        );
      case LengthGetterType.length:
        return '${ffiName}_length';
      case LengthGetterType.size:
        return '${ffiName}_size';
      case LengthGetterType.constant:
        return '${ffiName}_size'.toUpperCase();
    }
  }

  String get accessorName {
    final matcher = methodKind.matcher;
    if (matcher == null) {
      throw StateError('Normal methods are not accessors');
    }

    return matcher.firstMatch(ffiName)![1]!.snakeToDart();
  }

  bool get isClientNew => ffiName == 'etebase_client_new';

  bool get isClientDestroy => ffiName == 'etebase_client_destroy';
}

class MethodParser {
  static final _isGetLengthRegExp = RegExp('_get_.*_(length|size)');

  static final _returnTypeMapping = {
    RegExp(r'.*_get_.*_url$'): TypeRef.uri(),
    RegExp(r'.*_pubkey$'): TypeRef.byteArray(),
    RegExp(r'.*_get_access_level$'): TypeRef.etebaseCollectionAccessLevel(),
    'etebase_signed_invitation_get_from_username': TypeRef.string(),
    'etebase_client_check_etebase_server': TypeRef.bool(fromInt: true),
    'etebase_account_fetch_dashboard_url': TypeRef.uri(mutable: true),
  };

  static final _nullableReturns = <Pattern>[
    RegExp(r'^etebase_item_metadata_get_(item_type|name|description|color)$'),
    'etebase_collection_list_response_get_stoken',
    'etebase_collection_get_stoken',
    'etebase_fs_cache_load_stoken',
    'etebase_fs_cache_collection_load_stoken',
  ];

  static final _mutableReturns = <Pattern>[
    'etebase_fs_cache_load_stoken',
    'etebase_fs_cache_collection_load_stoken',
    'etebase_collection_get_collection_type',
    // 'etebase_account_fetch_dashboard_url', // see _returnTypeMapping
    'etebase_account_save',
  ];

  static final _methodsWithLengthConstants = [
    'etebase_utils_pretty_fingerprint',
  ];

  final ParamParser _paramParser;
  final TypeParser _typeParser;

  const MethodParser([
    this._paramParser = const ParamParser(),
    this._typeParser = const TypeParser(),
  ]);

  Iterable<MethodRef> parseMembers({
    required TypeDefiningElement clazz,
    required List<MethodElement> methods,
    required String methodPrefix,
    required TypedefRef typeDefs,
  }) sync* {
    for (var i = 0; i < methods.length; ++i) {
      final method = methods[i];
      final nextMethod = i < methods.length - 1 ? methods[i + 1] : null;

      var lengthGetterType = LengthGetterType.none;
      if (nextMethod != null) {
        final lengthGetterMatch = _isGetLengthRegExp.firstMatch(
          nextMethod.name,
        );
        if (lengthGetterMatch != null) {
          ++i;
          final suffix = lengthGetterMatch[1]!;
          lengthGetterType = LengthGetterType.values.byName(suffix);
        }
      }

      yield _parseMember(
        method: method,
        clazz: clazz,
        methodPrefix: methodPrefix,
        typeDefs: typeDefs,
        lengthGetterType: lengthGetterType,
      );
    }
  }

  MethodRef _parseMember({
    required MethodElement method,
    required TypeDefiningElement clazz,
    required String methodPrefix,
    required TypedefRef typeDefs,
    required LengthGetterType lengthGetterType,
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
      isStatic: !mappedParams.any((p) => p.isThisParam),
      lengthGetter: lengthGetterType,
      methodKind: _findMethodKind(method, methodPrefix),
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

    final mappedParams = [
      ..._paramParser.parse(
        methodName: method.name,
        parameters: method.parameters,
        typeDefs: typeDefs,
      ),
    ];

    return MethodRef(
      name: method.name.substring(prefixLength + 1).snakeToDart(),
      ffiName: method.name,
      isNew: false,
      isDestroy: false,
      isStatic: forceStatic,
      lengthGetter: _methodsWithLengthConstants.contains(method.name)
          ? LengthGetterType.constant
          : LengthGetterType.none,
      methodKind: MethodKind.method,
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
              isNullable: _nullableReturns.any(
                (p) => p.matchAsPrefix(method.name) != null,
              ),
              isMutable: _mutableReturns.any(
                (p) => p.matchAsPrefix(method.name) != null,
              ),
            ),
          );

  MethodKind _findMethodKind(MethodElement method, String methodPrefix) {
    final getterSetterRegExp = RegExp('^${methodPrefix}_(get|set)_.+?\$');
    final match = getterSetterRegExp.firstMatch(method.name);
    if (match == null) {
      return MethodKind.method;
    }

    switch (match[1]!) {
      case 'get':
        return MethodKind.getter;
      case 'set':
        return MethodKind.setter;
      default:
        throw StateError('Unreachable code reached');
    }
  }
}
