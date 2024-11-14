import '../models/etebase_collection_access_level.dart';
import '../models/etebase_fetch_options.dart';
import '../models/etebase_member_list_response.dart';

/// The dart binding of the EtebaseCollectionMemberManager rust class
abstract class EtebaseCollectionMemberManager {
  /// Disposes of the instance and clear all cryptographic keys from memory.
  Future<void> dispose();

  /// List the members of a collection
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseMemberListResponse> list([EtebaseFetchOptions? fetchOptions]);

  /// Remove a member from the collection
  ///
  /// @param this_ the object handle
  /// @param username the member's username
  Future<void> remove(String username);

  /// Leave a collection the user is a member of
  ///
  /// @param this_ the object handle
  Future<void> leave();

  /// Modify the access level of a member
  ///
  /// @param this_ the object handle
  /// @param username the member's username
  /// @param access_level the new `EtebaseCollectionAccessLevel`
  Future<void> modifyAccessLevel(
    String username,
    EtebaseCollectionAccessLevel accessLevel,
  );
}
