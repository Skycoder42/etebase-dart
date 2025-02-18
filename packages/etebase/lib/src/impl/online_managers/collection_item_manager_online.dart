import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../api/exceptions/api_missuse.dart';
import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_list_response.dart';
import '../encrypted_models/chunk.dart';
import '../encrypted_models/encrypted_collection_item.dart';
import '../encrypted_models/encrypted_revision.dart';
import '../models/collection_item_fetch_info.dart';
import '../models/item_batch_request.dart';
import '../models/web_socket_ticket_response.dart';
import 'base_manager.dart';
import 'base_network.dart';

@internal
final class CollectionItemManagerOnline extends BaseManager {
  CollectionItemManagerOnline({
    required super.client,
    required super.authTokenSource,
    required String colUid,
  }) : super(path: ['collection', colUid, 'item']);

  Future<EncryptedCollectionItem> fetch(
    String itemUid,
    EtebaseItemFetchOptions? options,
  ) => invokeApi<EncryptedCollectionItem>(path: [itemUid], options: options);

  Future<EtebaseItemListResponse<EncryptedCollectionItem>> list(
    EtebaseItemFetchOptions? options,
  ) => invokeApi<EtebaseItemListResponse<EncryptedCollectionItem>>(
    options: options,
  );

  Future<EtebaseIteratorListResponse<EncryptedCollectionItem>> itemRevisions(
    EncryptedCollectionItem item,
    EtebaseRevisionFetchOptions? options,
  ) async {
    final response =
        await invokeApi<EtebaseIteratorListResponse<EncryptedRevision>>(
          path: [item.uid, 'revision'],
          options: options,
        );
    return response.map((rev) => item.cloneWithRevision(rev));
  }

  Future<void> create(EncryptedCollectionItem item) =>
      invokeApi<void>(method: HttpMethod.post, body: item);

  Future<EtebaseItemListResponse<EncryptedCollectionItem>> fetchUpdates(
    List<EncryptedCollectionItem> items,
    EtebaseItemFetchOptions? options,
  ) => invokeApi<EtebaseItemListResponse<EncryptedCollectionItem>>(
    method: HttpMethod.post,
    path: const ['fetch_updates'],
    body: items.toFetchInfo(wantEtag: options?.stoken == null),
    options: options,
  );

  Future<EtebaseItemListResponse<EncryptedCollectionItem>> fetchMulti(
    List<String> items,
    EtebaseItemFetchOptions? options,
  ) => invokeApi<EtebaseItemListResponse<EncryptedCollectionItem>>(
    method: HttpMethod.post,
    path: const ['fetch_updates'],
    body: items.map(CollectionItemFetchInfo.new).toList(),
    options: options,
  );

  Future<void> batch(
    List<EncryptedCollectionItem> items,
    List<EncryptedCollectionItem>? deps,
    /*EtebaseItemFetchOptions*/ EtebaseFetchOptionsBase? options,
  ) => invokeApi<void>(
    method: HttpMethod.post,
    path: const ['batch'],
    body: ItemBatchRequest(
      items: items,
      deps: deps?.toFetchInfo(wantEtag: true),
    ),
    options: options,
  );

  Future<void> transaction(
    List<EncryptedCollectionItem> items,
    List<EncryptedCollectionItem>? deps,
    /*EtebaseItemFetchOptions*/ EtebaseFetchOptionsBase? options,
  ) => invokeApi<void>(
    method: HttpMethod.post,
    path: const ['transaction'],
    body: ItemBatchRequest(
      items: items,
      deps: deps?.toFetchInfo(wantEtag: true),
    ),
    options: options,
  );

  Future<void> chunkUpload(
    EncryptedCollectionItem item,
    Chunk chunk,
    EtebaseItemFetchOptions? options,
  ) {
    final Chunk(:uid, :data) = chunk;
    if (data == null) {
      throw ApiMissuse('Tried uploading a missing chunk');
    }
    return invokeApi<void>(
      method: HttpMethod.put,
      path: [item.uid, 'chunk', uid],
      body: data,
      options: options,
    );
  }

  Future<Uint8List> chunkDownload(
    EncryptedCollectionItem item,
    String chunkUid,
    EtebaseItemFetchOptions? options,
  ) => invokeApi<Uint8List>(
    path: [item.uid, 'chunk', chunkUid, 'download'],
    options: options,
  );

  Stream<EtebaseItemListResponse<EncryptedCollectionItem>> subscribeChanges(
    EtebaseItemFetchOptions? options,
  ) async* {
    final ticket = await invokeApi<WebSocketTicketResponse>(
      method: HttpMethod.post,
      path: ['subscription-ticket'],
    );
    final ws = WebSocketChannel.connect(
      baseUri.replace(
        scheme: baseUri.isScheme('http') ? 'ws' : 'wss',
        pathSegments: baseUri.pathSegments
            .followedBy(BaseManager.apiBasePath)
            .followedBy(['ws', ticket.ticket]),
        queryParameters: {
          ...baseUri.queryParameters,
          ...queryFromOptions(options),
        },
      ),
    );

    try {
      await ws.ready;
      yield* ws.stream.cast<Uint8List>().map(converter.decode);
    } finally {
      await ws.sink.close(status.normalClosure);
    }
  }
}
