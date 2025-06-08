import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/models/fetch_options.dart';
import '../../api/models/list_response.dart';
import '../encrypted_models/encrypted_collection.dart';
import '../models/collection_list_request.dart';
import 'base_manager.dart';
import 'base_network.dart';
import 'collection_item_manager_online.dart';

@internal
class CollectionManagerOnline extends BaseManager {
  CollectionManagerOnline({
    required super.client,
    required super.authTokenSource,
  }) : super(path: const ['collection']);

  @visibleForTesting
  CollectionManagerOnline.fromNetwork(
    super._network,
    super.authTokenSource,
    // ignore: invalid_use_of_visible_for_testing_member for tests
  ) : super.fromNetwork();

  CollectionItemManagerOnline itemManager(String colUid) =>
      CollectionItemManagerOnline(
        client: client,
        authTokenSource: authTokenSource,
        colUid: colUid,
      );

  Future<EncryptedCollection> fetch(String colUid, FetchOptions? options) =>
      invoke<EncryptedCollection>(path: [colUid], options: options);

  Future<CollectionListResponse<EncryptedCollection>> list(
    List<Uint8List> collectionTypes,
    FetchOptions? options,
  ) => invoke<CollectionListResponse<EncryptedCollection>>(
    method: HttpMethod.post,
    path: const ['list_multi'],
    body: CollectionListRequest(collectionTypes),
    options: options,
  );

  Future<void> create(EncryptedCollection collection, FetchOptions? options) =>
      invoke<void>(method: HttpMethod.post, body: collection, options: options);
}
