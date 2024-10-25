abstract interface class EtebaseResponse<T> {
  List<T> get data;

  bool get isDone;
}
