import 'package:meta/meta.dart';

import '../../api/models/etebase_collection_access_level.dart';
import '../../api/models/etebase_collection_member.dart';
import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_list_response.dart';
import '../models/modify_access_level_request.dart';
import 'base_manager.dart';
import 'base_network.dart';

@internal
final class CollectionMemberManagerOnline extends BaseManager {
  CollectionMemberManagerOnline({
    required super.client,
    required super.authTokenSource,
    required String colUid,
  }) : super(path: ['collection', colUid, 'member']);

  Future<EtebaseIteratorListResponse<EtebaseCollectionMember>> list(
    EtebaseIteratorFetchOptions? options,
  ) => invokeApi<EtebaseIteratorListResponse<EtebaseCollectionMember>>(
    options: options,
  );

  Future<void> remove(String username) =>
      invokeApi<void>(method: HttpMethod.delete, path: [username]);

  Future<void> leave() =>
      invokeApi<void>(method: HttpMethod.post, path: ['leave']);

  Future<void> modifyAccessLevel(
    String username,
    EtebaseCollectionAccessLevel level,
  ) => invokeApi<void>(
    method: HttpMethod.patch,
    path: [username],
    body: ModifyAccessLevelRequest(level),
  );
}
