class Disposable {
  final Future<void> Function() _onDispose;
  var _attachedCtr = 1;

  Disposable(this._onDispose);

  DisposeRef attach() {
    ++_attachedCtr;
    return DisposeRef._(this);
  }

  Future<void> unlockDispose() async {
    if (--_attachedCtr == 0) {
      await _onDispose();
    }
  }
}

class DisposeRef {
  Disposable? _disposable;

  DisposeRef._(this._disposable);

  Future<void> dispose() async {
    if (--_disposable?._attachedCtr == 0) {
      await _disposable?._onDispose();
    }
    _disposable = null;
  }
}
