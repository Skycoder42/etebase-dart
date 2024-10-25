import 'etebase_item.dart';

/// The dart binding of the EtebaseItemListResponse rust class
abstract class EtebaseItemListResponse {
  /// Sync token for the list response
  ///
  /// @param this_ the object handle
  String get stoken;

  /// List of items included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  List<EtebaseItem> get data;

  /// Indicates whether there are no more items to fetch
  ///
  /// @param this_ the object handle
  bool get isDone;
}
