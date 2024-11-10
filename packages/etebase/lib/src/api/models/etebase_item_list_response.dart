import 'base/etebase_collection_item_list_response.dart';
import 'etebase_item.dart';

/// The dart binding of the EtebaseItemListResponse rust class
abstract class EtebaseItemListResponse
    implements EtebaseCollectionItemListResponse<EtebaseItem> {
  /// Sync token for the list response
  ///
  /// @param this_ the object handle
  @override
  String get stoken;

  /// List of items included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  @override
  List<EtebaseItem> get data;

  /// Indicates whether there are no more items to fetch
  ///
  /// @param this_ the object handle
  @override
  bool get isDone;
}
