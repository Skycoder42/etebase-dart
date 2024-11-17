import 'package:meta/meta.dart';

import '../../api/managers/etebase_collection_member_manager.dart';
import '../../api/models/etebase_collection_access_level.dart';
import '../../api/models/etebase_collection_member.dart';
import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_list_response.dart';
import '../online_managers/collection_member_manager_online.dart';

@internal
class CollectionMemberManager implements EtebaseCollectionMemberManager {
  final CollectionMemberManagerOnline _online;

  CollectionMemberManager(this._online);

  @override
  Future<EtebaseIteratorListResponse<EtebaseCollectionMember>> list([
    EtebaseIteratorFetchOptions? fetchOptions,
  ]) =>
      _online.list(fetchOptions);

  @override
  Future<void> remove(String username) => _online.remove(username);

  @override
  Future<void> leave() => _online.leave();

  @override
  Future<void> modifyAccessLevel(
    String username,
    EtebaseCollectionAccessLevel accessLevel,
  ) =>
      _online.modifyAccessLevel(username, accessLevel);
}
