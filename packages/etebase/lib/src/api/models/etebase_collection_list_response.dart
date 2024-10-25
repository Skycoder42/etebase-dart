import 'base/etebase_stoken_response.dart';
import 'etebase_collection.dart';
import 'etebase_removed_collection.dart';

/// The dart binding of the EtebaseCollectionListResponse rust class
abstract class EtebaseCollectionListResponse
    implements EtebaseStokenResponse<EtebaseCollection> {
  /// Sync token for the list response
  ///
  /// @param this_ the object handle
  @override
  String? get stoken;

  /// List of collections included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the collections in
  @override
  List<EtebaseCollection> get data;

  /// Indicates whether there are no more collections to fetch
  ///
  /// @param this_ the object handle
  @override
  bool get isDone;

  /// The list of collections to which the user lost access
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the collections in
  List<EtebaseRemovedCollection> get removedMemberships;
}
