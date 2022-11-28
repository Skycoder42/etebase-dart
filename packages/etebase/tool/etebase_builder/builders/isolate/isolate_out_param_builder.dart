import 'package:code_builder/code_builder.dart';

import '../../parsers/method_parser.dart';
import '../../parsers/param_parser.dart';
import '../../parsers/type_ref.dart';
import '../../util/types.dart';
import 'isolate_builder.dart';

class IsolateOutParamBuilder {
  static const thisRef = Reference('this_');
  static const sizeRef = Reference('size');

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

  Code _buildFingerprintBuf() => declareFinal('buf') // TODO hardcoded...
      .assign(
        IsolateBuilder.arenaRef.call(
          [
            IsolateBuilder.libEtebaseRef
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
        .assign(
          IsolateBuilder.arenaRef.call(
            const [],
            const {},
            [Types.UnsignedLong$],
          ),
        )
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
          IsolateBuilder.arenaRef.call(
            [
              if (method.needsSizeHint)
                refer(parameter.lengthName())
              else
                sizeRef,
            ],
            const {},
            [Types.Uint8$],
          ),
        )
        .statement;
  }

  Iterable<Code> _buildOutClassList(
    MethodRef methodRef,
    ParameterRef parameter,
    EtebaseOutListTypeRef type,
  ) sync* {
    yield declareFinal(parameter.lengthName(validateHasLength: false))
        .assign(
          IsolateBuilder.libEtebaseRef
              .property(methodRef.ffiLengthGetterName)
              .call([thisRef]),
        )
        .statement;

    yield declareFinal(parameter.name)
        .assign(
          IsolateBuilder.arenaRef.call(
            [refer(parameter.lengthName(validateHasLength: false))],
            const {},
            [type.ffiInnerType],
          ),
        )
        .statement;
  }
}
