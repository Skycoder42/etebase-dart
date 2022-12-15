import 'package:code_builder/code_builder.dart';

import '../../parsers/class_parser.dart';
import '../../parsers/method_parser.dart';
import '../../util/if_then.dart';
import '../../util/string_extensions.dart';
import '../../util/types.dart';
import 'isolate_builder.dart';
import 'isolate_in_param_builder.dart';
import 'isolate_return_builder.dart';

class IsolateConverterBuilder {
  static const _dataName = 'data';
  static const _dataRef = Reference(_dataName);
  static const _instanceName = 'instance';
  static const _instanceRef = Reference(_instanceName);

  final IsolateInParamBuilder _isolateInParamBuilder;
  final IsolateReturnBuilder _isolateReturnBuilder;

  const IsolateConverterBuilder([
    this._isolateInParamBuilder = const IsolateInParamBuilder(),
    this._isolateReturnBuilder = const IsolateReturnBuilder(),
  ]);

  Iterable<Method> buildConverterMethods(ClassRef clazz) sync* {
    yield _buildToNative(clazz);
    yield _buildFromNative(clazz);
  }

  Method _buildToNative(ClassRef clazz) => Method(
        (b) => b
          ..name = '_${clazz.name.lowerFirstChar()}ToNative'
          ..returns = Types.pointer(Types.ffi(refer(clazz.name)))
          ..requiredParameters.addAll([
            Parameter(
              (b) => b
                ..name = IsolateBuilder.libEtebaseRef.symbol!
                ..type = Types.ffi(refer('LibEtebaseFFI')),
            ),
            Parameter(
              (b) => b
                ..name = IsolateBuilder.poolRef.symbol!
                ..type = Types.EtebasePool$,
            ),
            Parameter(
              (b) => b
                ..name = _dataName
                ..type = Types.client(refer(clazz.name)).asNullable,
            ),
          ])
          ..body = Block.of(_buildToNativeBody(clazz)),
      );

  Iterable<Code> _buildToNativeBody(ClassRef clazz) sync* {
    yield if$(_dataRef.equalTo(literalNull), [
      Types.nullptr$.returned.statement,
    ]);

    final createMethod = clazz.methods.singleWhere((m) => m.isNew);
    final createMethodParamNames =
        createMethod.parameters.map((p) => p.name).toList();
    final destroyMethod = clazz.methods.singleWhere((m) => m.isDestroy);

    yield* _buildConstructorParams(clazz, createMethod);
    yield declareFinal(_instanceName)
        .assign(
          IsolateBuilder.poolRef.property('attachScoped').call([
            IsolateBuilder.libEtebaseRef
                .property(createMethod.ffiName)
                .call(createMethodParamNames.map(refer)),
            IsolateBuilder.libEtebaseRef.property(destroyMethod.ffiName),
          ]),
        )
        .statement;

    final setters = clazz.methods.where(
      (method) =>
          method.methodKind == MethodKind.setter &&
          !createMethodParamNames.contains(method.accessorName),
    );
    for (final setter in setters) {
      final member = _dataRef.property(setter.accessorName);
      yield if$(member.notEqualTo(literalNull), [
        ..._isolateInParamBuilder.buildInParameter(
          setter.parameters.singleWhere((param) => !param.isThisParam),
          member.nullChecked,
        ),
        IsolateBuilder.libEtebaseRef
            .property(setter.ffiName)
            .call([_instanceRef, refer(setter.accessorName)]).statement,
      ]);
    }

    yield _instanceRef.returned.statement;
  }

  Iterable<Code> _buildConstructorParams(
    ClassRef clazz,
    MethodRef constructor,
  ) sync* {
    for (final param in constructor.parameters) {
      yield* _isolateInParamBuilder.buildInParameter(
        param,
        _dataRef.property(param.name),
      );
    }
  }

  Method _buildFromNative(ClassRef clazz) => Method(
        (b) => b
          ..name = '_${clazz.name.lowerFirstChar()}FromNative'
          ..returns = Types.client(refer(clazz.name))
          ..requiredParameters.addAll([
            Parameter(
              (b) => b
                ..name = IsolateBuilder.libEtebaseRef.symbol!
                ..type = Types.ffi(refer('LibEtebaseFFI')),
            ),
            Parameter(
              (b) => b
                ..name = IsolateBuilder.poolRef.symbol!
                ..type = Types.EtebasePool$,
            ),
            Parameter(
              (b) => b
                ..name = _dataName
                ..type = Types.pointer(Types.ffi(refer(clazz.name))),
            ),
          ])
          ..body = Block.of(_buildFromNativeBody(clazz)),
      );

  Iterable<Code> _buildFromNativeBody(ClassRef clazz) sync* {
    final destroyMethod = clazz.methods.singleWhere((m) => m.isDestroy);
    yield declareFinal(_instanceName)
        .assign(
          IsolateBuilder.poolRef.property('attachScoped').call([
            _dataRef,
            IsolateBuilder.libEtebaseRef.property(destroyMethod.ffiName),
          ]),
        )
        .statement;

    final getters = clazz.methods.where(
      (method) => method.methodKind == MethodKind.getter,
    );
    for (final getter in getters) {
      final rawValueName = '${getter.accessorName}Raw';
      yield declareFinal(rawValueName)
          .assign(
            IsolateBuilder.libEtebaseRef
                .property(getter.ffiName)
                .call([_instanceRef]),
          )
          .statement;
      yield* _isolateReturnBuilder.buildReturnConversion(
        getter,
        refer(rawValueName),
        (returnValue) =>
            declareFinal(getter.accessorName).assign(returnValue).statement,
        thrown: true,
      );
    }

    yield Types.client(refer(clazz.name))
        .newInstance([], {
          for (final getter in getters)
            getter.accessorName: refer(getter.accessorName),
        })
        .returned
        .statement;
  }
}
