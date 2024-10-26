import 'base/etebase_iterable_response.dart';
import 'etebase_item.dart';

/// The dart binding of the EtebaseItemRevisionsListResponse rust class
abstract class EtebaseItemRevisionsListResponse
    implements EtebaseIterableResponse<EtebaseItem> {
  /// Iterator for the list response
  ///
  /// @param this_ the object handle
  @override
  String get iterator;

  /// List of item revisions included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  @override
  List<EtebaseItem> get data;

  /// Indicates whether there is no more data to fetch
  ///
  /// @param this_ the object handle
  @override
  bool get isDone;
}
