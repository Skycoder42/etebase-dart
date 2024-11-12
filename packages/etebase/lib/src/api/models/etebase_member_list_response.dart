import 'base/etebase_iterator_list_response.dart';
import 'etebase_collection_member.dart';

/// The dart binding of the EtebaseMemberListResponse rust class
abstract class EtebaseMemberListResponse
    implements EtebaseIteratorListResponse<EtebaseCollectionMember> {
  /// Iterator for the list response
  ///
  /// @param this_ the object handle
  @override
  String get iterator;

  /// List of collection members included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the collection members in
  @override
  List<EtebaseCollectionMember> get data;

  /// Indicates whether there is no more data to fetch
  ///
  /// @param this_ the object handle
  @override
  bool get isDone;
}
