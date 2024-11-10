abstract interface class EtebaseListResponse<T> {
  /// List of collections included in the response
  List<T> get data;

  /// Indicates whether there are no more collections to fetch
  bool get isDone;
}
