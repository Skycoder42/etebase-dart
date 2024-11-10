import 'etebase_list_response.dart';

abstract interface class EtebaseIterableResponse<T>
    implements EtebaseListResponse<T> {
  String get iterator;
}
