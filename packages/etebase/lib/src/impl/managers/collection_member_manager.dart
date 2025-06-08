import 'package:meta/meta.dart';

import '../../api/managers/etebase_collection_member_manager.dart';
import '../../api/models/collection_access_level.dart';
import '../../api/models/collection_member.dart';
import '../../api/models/fetch_options.dart';
import '../../api/models/list_response.dart';
import '../online_managers/collection_member_manager_online.dart';

@internal
class CollectionMemberManager implements EtebaseCollectionMemberManager {
  @visibleForTesting
  final CollectionMemberManagerOnline online;

  CollectionMemberManager(this.online);

  @override
  Future<IteratorListResponse<CollectionMember>> list([
    IteratorFetchOptions? fetchOptions,
  ]) => online.list(fetchOptions);

  @override
  Future<void> remove(String username) => online.remove(username);

  @override
  Future<void> leave() => online.leave();

  @override
  Future<void> modifyAccessLevel(
    String username,
    CollectionAccessLevel accessLevel,
  ) => online.modifyAccessLevel(username, accessLevel);
}
