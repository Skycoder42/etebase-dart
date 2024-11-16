import '../models/base/etebase_iterator_list_response.dart';
import '../models/etebase_collection.dart';
import '../models/etebase_collection_access_level.dart';
import '../models/etebase_collection_member.dart';
import '../models/etebase_fetch_options.dart';

/// A manager for managing the members of a [EtebaseCollection].
abstract class EtebaseCollectionMemberManager {
  /// List the members of a [EtebaseCollection].
  ///
  /// {@macro fetch_options}
  Future<EtebaseIteratorListResponse<EtebaseCollectionMember>> list([
    EtebaseIteratorFetchOptions? fetchOptions,
  ]);

  /// Remove a member identified by [username] from the [EtebaseCollection].
  Future<void> remove(String username);

  /// Leave a [EtebaseCollection] the current user is a member of.
  Future<void> leave();

  /// Modify the [accessLevel] of a member identified by [username].
  Future<void> modifyAccessLevel(
    String username,
    EtebaseCollectionAccessLevel accessLevel,
  );
}
