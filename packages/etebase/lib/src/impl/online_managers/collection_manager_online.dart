import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_list_response.dart';
import '../encrypted_models/encrypted_collection.dart';
import '../models/collection_list_request.dart';
import 'base_manager.dart';
import 'base_network.dart';
import 'collection_item_manager_online.dart';

@internal
final class CollectionManagerOnline extends BaseManager {
  CollectionManagerOnline({
    required super.client,
    required super.authTokenSource,
  }) : super(path: const ['collection']);

  CollectionItemManagerOnline itemManager(String colUid) =>
      CollectionItemManagerOnline(
        client: client,
        authTokenSource: authTokenSource,
        colUid: colUid,
      );

  Future<EncryptedCollection> fetch(
    String colUid,
    EtebaseFetchOptions? options,
  ) => invoke<EncryptedCollection>(path: [colUid], options: options);

  Future<EtebaseCollectionListResponse<EncryptedCollection>> list(
    List<Uint8List> collectionTypes,
    EtebaseFetchOptions? options,
  ) => invoke<EtebaseCollectionListResponse<EncryptedCollection>>(
    method: HttpMethod.post,
    path: const ['list_multi'],
    body: CollectionListRequest(collectionTypes),
    options: options,
  );

  Future<void> create(
    EncryptedCollection collection,
    EtebaseFetchOptions? options,
  ) =>
      invoke<void>(method: HttpMethod.post, body: collection, options: options);
}
