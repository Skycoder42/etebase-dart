import 'etebase_collection_access_level.dart';
import 'etebase_item.dart';

/// The dart binding of the EtebaseCollection rust class
abstract class EtebaseCollection implements EtebaseItem {
  /// The sync token for the collection
  ///
  /// The sync token reflects changes to the collection properties or its items on the server
  ///
  /// @param this_ the object handle
  String? get stoken;

  /// The type of the collection
  ///
  /// @param this_ the object handle
  Future<String> get collectionType; // TODO make sync

  /// Return the access level of the collection for the current user
  ///
  /// @param this_ the object handle
  EtebaseCollectionAccessLevel get accessLevel;
}
