import 'etebase_collection_access_level.dart';

/// The dart binding of the EtebaseCollectionMember rust class
abstract class EtebaseCollectionMember {
  /// Clone the object
  ///
  /// @param this_ the object handle
  EtebaseCollectionMember clone();

  /// The username of a member
  ///
  /// @param this_ the object handle
  String get username;

  /// The access_level of the member
  ///
  /// @param this_ the object handle
  EtebaseCollectionAccessLevel get accessLevel;
}
