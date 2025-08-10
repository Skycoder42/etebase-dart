import 'dart:async';

import 'package:meta/meta.dart';

@internal
abstract interface class ScopeDisposable {
  Future<void>? dispose();
}

@internal
mixin DisposeScope {
  final _items = <WeakReference<ScopeDisposable>>[];

  void attach(ScopeDisposable item) => _items.add(WeakReference(item));

  void detach(ScopeDisposable item) =>
      _items.removeWhere((r) => r.target == null || r.target == item);

  @mustCallSuper
  @protected
  Future<void> dispose() async {
    // copy list first so that calls of detach() as part of item.dispose() do
    // not break the iteration
    final items = _items.map((r) => r.target).nonNulls.toList();
    _items.clear();
    final pendingDisposes = [for (final item in items) ?item.dispose()];
    if (pendingDisposes.isNotEmpty) {
      await Future.wait(pendingDisposes);
    }
  }

  @protected
  Iterable<T> findDisposables<T>([bool Function(T)? filter]) {
    final matchingByType = _items.map((r) => r.target).whereType<T>();
    return filter != null ? matchingByType.where(filter) : matchingByType;
  }
}
