import 'package:code_builder/code_builder.dart';

class _CatchInfo {
  final TypeReference? on;
  final Reference? error;
  final Reference? stackTrace;
  final Iterable<Code> body;

  _CatchInfo(this.on, this.error, this.stackTrace, this.body);
}

class TryCatch {
  final DartEmitter _emitter;

  final Iterable<Code> _try;
  final List<_CatchInfo> _catch;
  final Iterable<Code>? _finally;

  TryCatch._(this._try, this._catch, this._finally, this._emitter);

  factory TryCatch.try$(Iterable<Code> body, [DartEmitter? emitter]) =>
      TryCatch._(
        body,
        const [],
        null,
        emitter ?? DartEmitter(useNullSafetySyntax: true),
      );

  TryCatch catch$({
    TypeReference? on,
    Reference? error,
    Reference? stackTrace,
    required Iterable<Code> body,
  }) =>
      TryCatch._(
        _try,
        [..._catch, _CatchInfo(on, error, stackTrace, body)],
        _finally,
        _emitter,
      );

  TryCatch finally$(Iterable<Code> body) {
    if (_finally != null) {
      throw StateError('Can only define finally once');
    }
    return TryCatch._(_try, _catch, body, _emitter);
  }

  Code get code {
    if (_catch.isEmpty && _finally == null) {
      throw StateError('Must define at least one catch or finally');
    }

    final codeBuffer = StringBuffer('try {');
    _try.acceptAll(_emitter, codeBuffer);
    codeBuffer.write('}');

    for (final catchInfo in _catch) {
      if (catchInfo.on != null) {
        codeBuffer.write(' on ');
        catchInfo.on!.accept(_emitter, codeBuffer);
      }

      if (catchInfo.error != null) {
        codeBuffer.write(' catch(');
        catchInfo.error!.accept(_emitter, codeBuffer);

        if (catchInfo.stackTrace != null) {
          codeBuffer.write(', ');
          catchInfo.stackTrace!.accept(_emitter, codeBuffer);
        }

        codeBuffer.write(') ');
      }

      codeBuffer.write('{');
      catchInfo.body.acceptAll(_emitter, codeBuffer);
      codeBuffer.write('}');
    }

    if (_finally != null) {
      codeBuffer.write(' finally {');
      _finally!.acceptAll(_emitter, codeBuffer);
      codeBuffer.write('}');
    }

    return Code(codeBuffer.toString());
  }
}

extension _CodeListX on Iterable<Code> {
  void acceptAll(DartEmitter visitor, StringBuffer context) =>
      forEach((element) {
        element.accept(visitor, context);
      });
}
