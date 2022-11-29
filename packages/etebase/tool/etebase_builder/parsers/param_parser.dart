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

  final TypeRef type;

  const ParameterRef({
    required this.name,
    required this.isThisParam,
    required this.hasLength,
    required this.isRetSize,
    required this.isOutBuf,
    required this.type,
  });

  bool get isOutParam => isOutBuf || type is EtebaseOutListTypeRef;

  bool get isOptional => type.publicType.isNullable ?? false;

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

      if (nextParam != null && nextParam.name == '${param.name}_size') {
        ++i; // skip the _size param

        yield ParameterRef(
          name: param.name.snakeToDart(),
          isThisParam: false,
          hasLength: true,
          isRetSize: false,
          isOutBuf: isBufParam,
          type: _typeParser.parseType(
            type: param.type,
            isArray: true,
            isOptional: _isOptional(methodName, param),
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
          type: _parseTypeOrEnum(
            param,
            typeDefs,
            isArray: isBufParam && _isBufList(param),
            isOptional: _isOptional(methodName, param),
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
    required bool isOptional,
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
              isOptional: isOptional,
            ),
          );

  bool _isOptional(String methodName, ParameterElement param) {
    if (param.name == 'fetch_options' || param.name == 'encryption_key') {
      return true;
    }

    return false;
  }
}
