import 'etebase_list_response.dart';

abstract interface class EtebaseCollectionItemListResponse<T>
    implements EtebaseListResponse<T> {
  /// Sync token for the list response
  String? get stoken;
}
