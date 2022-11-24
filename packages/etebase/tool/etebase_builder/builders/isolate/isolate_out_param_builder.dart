import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/types.dart';

class IsolateOutParamBuilder {
  static const _alloc = Reference('alloc');

  const IsolateOutParamBuilder();

  Iterable<Code> buildOutParameters(MethodRef method) sync* {
    if (method.ffiName == 'etebase_utils_pretty_fingerprint') {
      yield _buildFingerprintBuf();
      return;
    }

    if (method.hasRetSize) {
      yield _buildRetSize(method);
    }

    if (method.hasOutParam) {
      final outParam = method.parameters.singleWhere((p) => p.isOutParam);
      final outParamType = outParam.type;

      if (outParam.isOutBuf) {
        if (outParamType is ByteArrayTypeRef) {
          yield* _buildOutByteArray(method, outParam, outParamType);
        } else {
          throw UnsupportedError(
            'An out buf parameter cannot be of type $outParamType',
          );
        }
      } else if (outParamType is EtebaseOutListTypeRef) {
        yield* _buildOutClassList(method, outParam, outParamType);
      } else {
        throw UnsupportedError(
          'An non-buf out parameter cannot be of type $outParamType',
        );
      }
    }
  }

  Code _buildFingerprintBuf() => declareFinal('buf')
      .assign(
        _alloc.call(
          [
            refer('libEtebase')
                .property('ETEBASE_UTILS_PRETTY_FINGERPRINT_SIZE')
          ],
          const {},
          [Types.Char$],
        ),
      )
      .statement;

  Code _buildRetSize(MethodRef method) {
    final retSizeParam = method.parameters.singleWhere((p) => p.isRetSize);
    return declareFinal(retSizeParam.name)
        .assign(_alloc.call(const [], const {}, [Types.UnsignedLong$]))
        .cascade('value')
        .assign(literalNum(0))
        .statement;
  }

  Iterable<Code> _buildOutByteArray(
    MethodRef method,
    ParameterRef parameter,
    ByteArrayTypeRef type,
  ) sync* {
    yield declareFinal(parameter.name)
        .assign(
          _alloc.call(
            [refer(method.needsSizeHint ? '${parameter.name}_size' : 'size')],
            const {},
            [Types.Uint8$],
          ),
        )
        .statement;

    // TODO see https://docs.etebase.com/guides/using_items#binary-content
  }

  Iterable<Code> _buildOutClassList(
    MethodRef methodRef,
    ParameterRef parameter,
    EtebaseOutListTypeRef type,
  ) sync* {
    // TODO validate method has get_length variant

    final sizeVarName = '${parameter.name}_size';
    yield declareFinal(sizeVarName)
        .assign(
          refer('libEtebase')
              .property('${methodRef.ffiName}_length')
              .call([refer('this_')]),
        )
        .statement;

    yield declareFinal(parameter.name)
        .assign(
          _alloc.call([refer(sizeVarName)], const {}, [type.ffiInnerType]),
        )
        .statement;
  }
}
