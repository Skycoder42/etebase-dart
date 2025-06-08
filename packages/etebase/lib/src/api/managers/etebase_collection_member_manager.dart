import '../models/collection_access_level.dart';
import '../models/collection_member.dart';
import '../models/etebase_collection.dart';
import '../models/fetch_options.dart';
import '../models/list_response.dart';

/// A manager for managing the members of a [EtebaseCollection].
abstract class EtebaseCollectionMemberManager {
  /// List the members of a [EtebaseCollection].
  ///
  /// {@macro fetch_options}
  Future<IteratorListResponse<CollectionMember>> list([
    IteratorFetchOptions? fetchOptions,
  ]);

  /// Remove a member identified by [username] from the [EtebaseCollection].
  Future<void> remove(String username);

  /// Leave a [EtebaseCollection] the current user is a member of.
  Future<void> leave();

  /// Modify the [accessLevel] of a member identified by [username].
  Future<void> modifyAccessLevel(
    String username,
    CollectionAccessLevel accessLevel,
  );
}
