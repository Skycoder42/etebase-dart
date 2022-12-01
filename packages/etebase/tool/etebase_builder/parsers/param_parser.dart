import 'package:analyzer/dart/element/element.dart';

import '../util/dart_type_extensions.dart';
import '../util/string_extensions.dart';
import 'etebase_parser.dart';
import 'type_parse.dart';
import 'type_ref.dart';

class ParameterRef {
  final String name;

  final bool isThisParam;
  final bool hasLength;
  final bool isRetSize;
  final bool isOutBuf;
  final bool isOptional;

  final TypeRef type;

  const ParameterRef({
    required this.name,
    required this.isThisParam,
    required this.hasLength,
    required this.isRetSize,
    required this.isOutBuf,
    required this.isOptional,
    required this.type,
  });

  bool get isOutParam => isOutBuf || type is EtebaseOutListTypeRef;

  bool get needsSizeHint => isOutBuf && hasLength;

  String lengthName({bool validateHasLength = true}) {
    if (validateHasLength && !hasLength) {
      throw UnsupportedError(
        'Cannot get lengthName of param $name without hasLength',
      );
    }

    return '${name}Size';
  }
}

class ParamParser {
  static const _thisParamName = 'this_';
  static const _thisParamOverrides = {
    'etebase_client_check_etebase_server': {'client': true},
  };
  static final _paramTypeMap = {
    'access_level': TypeRef.etebaseCollectionAccessLevel(),
    'prefetch': TypeRef.etebasePrefetchOption(),
    'server_url': TypeRef.uri(),
  };
  static final _optionalParams = {
    RegExp('.*'): ['fetch_options'],
    RegExp('etebase_(fs_cache_.*)?account.*'): ['encryption_key'],
  };
  static final _nullableParams = {
    ..._optionalParams,
    RegExp('etebase_item_metadata_.*'): [
      'item_type',
      'name',
      'mtime',
      'description',
      'color',
    ],
  };

  final TypeParser _typeParser;

  const ParamParser([this._typeParser = const TypeParser()]);

  List<ParameterRef> parse({
    required String methodName,
    required List<ParameterElement> parameters,
    required TypedefRef typeDefs,
  }) =>
      _parseParams(
        methodName: methodName,
        parameters: parameters,
        typeDefs: typeDefs,
      ).toList();

  Iterable<ParameterRef> _parseParams({
    required String methodName,
    required List<ParameterElement> parameters,
    required TypedefRef typeDefs,
  }) sync* {
    for (var i = 0; i < parameters.length; ++i) {
      final param = parameters[i];
      final nextParam = i < parameters.length - 1 ? parameters[i + 1] : null;
      final isBufParam = param.name == 'buf';
      final isOptional = _hasRule(_optionalParams, methodName, param);
      final isNullable = _hasRule(_nullableParams, methodName, param);

      if (nextParam != null && nextParam.name == '${param.name}_size') {
        ++i; // skip the _size param

        yield ParameterRef(
          name: param.name.snakeToDart(),
          isThisParam: false,
          hasLength: true,
          isRetSize: false,
          isOutBuf: isBufParam,
          isOptional: isOptional,
          type: _typeParser.parseType(
            type: param.type,
            isArray: true,
            isNullable: isNullable,
            typeDefs: typeDefs,
          ),
        );
      } else {
        yield ParameterRef(
          name: param.name.snakeToDart(),
          isThisParam: _thisParamOverrides[methodName]?[param.name] ??
              param.name == _thisParamName,
          hasLength: false,
          isRetSize: param.name == 'ret_size',
          isOutBuf: isBufParam,
          isOptional: isOptional,
          type: _parseTypeOrEnum(
            param,
            typeDefs,
            isArray: isBufParam && _isBufList(param),
            isNullable: isNullable,
          ),
        );
      }
    }
  }

  bool _isBufList(ParameterElement param) {
    if (param.type.isPointer) {
      final pointerType = param.type.asPointer;
      if (pointerType.element?.name == 'Void') {
        return true;
      }
    }

    return false;
  }

  TypeRef _parseTypeOrEnum(
    ParameterElement param,
    TypedefRef typeDefs, {
    required bool isArray,
    required bool isNullable,
  }) =>
      _paramTypeMap.entries
          .where((e) => e.key == param.name)
          .map((e) => e.value)
          .singleWhere(
            (_) => true,
            orElse: () => _typeParser.parseType(
              type: param.type,
              typeDefs: typeDefs,
              isArray: isArray,
              isNullable: isNullable,
            ),
          );

  bool _hasRule(
    Map<RegExp, List<String>> map,
    String methodName,
    ParameterElement param,
  ) {
    for (final entry in map.entries) {
      if (entry.key.hasMatch(methodName)) {
        if (entry.value.contains(param.name)) {
          return true;
        }
      }
    }

    return false;
  }
}
