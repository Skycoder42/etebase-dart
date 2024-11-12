import 'etebase_list_response.dart';

abstract interface class EtebaseIteratorListResponse<T>
    implements EtebaseListResponse<T> {
  String get iterator;
}
