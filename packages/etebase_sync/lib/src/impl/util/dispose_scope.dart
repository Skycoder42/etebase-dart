import 'dart:async';

class DisposeScope {
  final _disposables = <WeakReference<dynamic>>[];
  final _detachLater = <WeakReference<dynamic>>[];

  DisposeScope._();

  static DisposeScope get _current => Zone.current[#scope] as DisposeScope;

  static Future<T> scoped<T>(FutureOr<T> Function() callback) {
    final scope = DisposeScope._();
    final completer = Completer<T>();
    unawaited(
      runZonedGuarded(zoneValues: {#scope: scope}, () async {
        try {
          final result = await callback();
          await scope._dispose(success: true);
          completer.complete(result);

          // ignore: avoid_catches_without_on_clauses
        } catch (e, s) {
          await scope._dispose(success: false);
          completer.completeError(e, s);
        }
      }, Zone.current.handleUncaughtError),
    );
    return completer.future;
  }

  static Stream<T> scopedStream<T>(Stream<T> Function() callback) {
    // ignore: close_sinks because it is closed by pipe
    final sc = StreamController<T>();
    unawaited(scoped(() async => await callback().pipe(sc.sink)));
    return sc.stream;
  }

  static T attach<T>(T object) {
    _current._attach(object);
    return object;
  }

  static T detach<T>(T object) {
    _current._detach(object);
    return object;
  }

  static T detachLater<T>(T object) {
    if (object == null) {
      return object;
    }
    _current._detachLater.add(WeakReference(object));
    return object;
  }

  void _attach(Object? object) {
    if (object == null) {
      return;
    }

    assert(
      // ignore: avoid_dynamic_calls
      (object as dynamic).dispose is Function,
      'Object of type ${object.runtimeType} has no dispose method',
    );
    _current._disposables.add(WeakReference(object));
  }

  void _detach(Object? object) {
    if (object == null) {
      return;
    }

    final index = _current._disposables.indexWhere(
      (ref) => identical(ref.target, object),
    );
    if (index != -1) {
      _current._disposables.removeAt(index);
    }
  }

  Future<void> _dispose({required bool success}) async {
    try {
      for (final ref in _disposables) {
        final object = ref.target;
        if (object == null) {
          continue;
        }

        if (success &&
            _detachLater.any((ref) => identical(ref.target, object))) {
          continue;
        }

        // ignore: avoid_dynamic_calls
        await (object as dynamic)?.dispose();
      }

      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      Zone.current.handleUncaughtError(e, s);
    } finally {
      _disposables.clear();
      _detachLater.clear();
    }
  }
}
