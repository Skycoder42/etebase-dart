import 'etebase_response.dart';

abstract interface class EtebaseIterableResponse<T>
    implements EtebaseResponse<T> {
  String get iterator;
}
