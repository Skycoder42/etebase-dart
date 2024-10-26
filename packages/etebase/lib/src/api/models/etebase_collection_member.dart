import 'base/etebase_cloneable.dart';
import 'etebase_collection_access_level.dart';

/// The dart binding of the EtebaseCollectionMember rust class
abstract class EtebaseCollectionMember
    implements EtebaseCloneable<EtebaseCollectionMember> {
  /// Clone the object
  ///
  /// @param this_ the object handle
  @override
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
