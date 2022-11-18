import 'package:analyzer/dart/element/element.dart';

import '../util/dart_type_extensions.dart';
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
  final bool isOutBuf;

  final TypeRef type;

  const ParameterRef({
    required this.element,
    required this.name,
    required this.isThisParam,
    required this.isList,
    required this.isListLength,
    required this.isRetSize,
    required this.isOutBuf,
    required this.type,
  });

  bool get isOutParam => type.isOutParam || isOutBuf;
}

class ParamParser {
  static const _thisParamName = 'this_';
  static const _thisParamOverrides = {
    'etebase_client_check_etebase_server': {'client': true},
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
          element: param,
          name: param.name.snakeToDart(),
          isThisParam: false,
          isList: true,
          isListLength: false,
          isRetSize: false,
          isOutBuf: isBufParam,
          type: _typeParser.parseType(
            type: param.type,
            isArray: true,
            typeDefs: typeDefs,
          ),
        );

        yield ParameterRef(
          element: nextParam,
          name: nextParam.name.snakeToDart(),
          isThisParam: false,
          isList: false,
          isListLength: true,
          isRetSize: false,
          isOutBuf: false,
          type: _typeParser.parseType(
            type: nextParam.type,
            typeDefs: typeDefs,
          ),
        );
      } else {
        yield ParameterRef(
          element: param,
          name: param.name.snakeToDart(),
          isThisParam: _thisParamOverrides[methodName]?[param.name] ??
              param.name == _thisParamName,
          isList: isBufParam && _isBufList(param),
          isListLength: false,
          isRetSize: param.name == 'ret_size',
          isOutBuf: isBufParam,
          type: _parseTypeOrEnum(
            param,
            typeDefs,
            isArray: isBufParam && _isBufList(param),
          ),
        );
      }
    }
  }

  bool _isBufList(ParameterElement param) {
    if (param.type.isPointer) {
      final pointerType = param.type.asPointer;
      if (pointerType.element?.name == 'Char') {
        return false;
      }
    }

    return true;
  }

  TypeRef _parseTypeOrEnum(
    ParameterElement param,
    TypedefRef typeDefs, {
    required bool isArray,
  }) {
    if (param.name == 'access_level') {
      return _typeParser.createAccessLevelFor(param.type);
    } else if (param.name == 'prefetch') {
      return _typeParser.createPrefetchOptionFor(param.type);
    } else {
      return _typeParser.parseType(
        type: param.type,
        typeDefs: typeDefs,
        isArray: isArray,
      );
    }
  }
}
