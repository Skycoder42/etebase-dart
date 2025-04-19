import 'package:meta/meta.dart';

import '../../api/models/etebase_collection_access_level.dart';
import '../../api/models/etebase_collection_member.dart';
import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_list_response.dart';
import '../models/modify_access_level_request.dart';
import 'base_manager.dart';
import 'base_network.dart';

@internal
class CollectionMemberManagerOnline extends BaseManager {
  CollectionMemberManagerOnline({
    required super.client,
    required super.authTokenSource,
    required String colUid,
  }) : super(path: ['collection', colUid, 'member']);

  @visibleForTesting
  CollectionMemberManagerOnline.fromNetwork(
    super._network,
    super.authTokenSource,
    // ignore: invalid_use_of_visible_for_testing_member for tests
  ) : super.fromNetwork();

  Future<EtebaseIteratorListResponse<EtebaseCollectionMember>> list(
    EtebaseIteratorFetchOptions? options,
  ) => invoke<EtebaseIteratorListResponse<EtebaseCollectionMember>>(
    options: options,
  );

  Future<void> remove(String username) =>
      invoke<void>(method: HttpMethod.delete, path: [username]);

  Future<void> leave() =>
      invoke<void>(method: HttpMethod.post, path: ['leave']);

  Future<void> modifyAccessLevel(
    String username,
    EtebaseCollectionAccessLevel level,
  ) => invoke<void>(
    method: HttpMethod.patch,
    path: [username],
    body: ModifyAccessLevelRequest(level),
  );
}
