import '../models/collection.dart';
import '../models/collection_access_level.dart';
import '../models/collection_member.dart';
import '../models/fetch_options.dart';
import '../models/list_response.dart';

/// A manager for managing the members of a [Collection].
abstract class EtebaseCollectionMemberManager {
  /// List the members of a [Collection].
  ///
  /// {@macro fetch_options}
  Future<IteratorListResponse<CollectionMember>> list([
    IteratorFetchOptions? fetchOptions,
  ]);

  /// Remove a member identified by [username] from the [Collection].
  Future<void> remove(String username);

  /// Leave a [Collection] the current user is a member of.
  Future<void> leave();

  /// Modify the [accessLevel] of a member identified by [username].
  Future<void> modifyAccessLevel(
    String username,
    CollectionAccessLevel accessLevel,
  );
}
