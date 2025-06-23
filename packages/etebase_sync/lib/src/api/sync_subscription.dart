import 'dart:async';

class SyncSubscription {
  final StreamSubscription<void> _streamSubscription;

  SyncSubscription(this._streamSubscription);

  Future<void> cancel() async => await _streamSubscription.cancel();

  void onDone(void Function()? handleDone) =>
      _streamSubscription.onDone(handleDone);

  void onError(Function? handleError) =>
      _streamSubscription.onError(handleError);

  Future<E> asFuture<E>([E? futureValue]) =>
      _streamSubscription.asFuture<E>(futureValue);
}
