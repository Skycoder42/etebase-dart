import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../api/exceptions/api_missuse.dart';
import '../../api/exceptions/connection_problem.dart';
import '../../api/exceptions/websocket_closed.dart';
import '../../api/models/fetch_options.dart';
import '../../api/models/list_response.dart';
import '../encrypted_models/chunk.dart';
import '../encrypted_models/encrypted_collection_item.dart';
import '../encrypted_models/encrypted_revision.dart';
import '../models/collection_item_fetch_info.dart';
import '../models/item_batch_request.dart';
import '../models/web_socket_ticket_response.dart';
import 'base_manager.dart';
import 'base_network.dart';

@internal
class CollectionItemManagerOnline extends BaseManager {
  CollectionItemManagerOnline({
    required super.client,
    required super.authTokenSource,
    required String colUid,
  }) : super(path: ['collection', colUid, 'item']);

  @visibleForTesting
  CollectionItemManagerOnline.fromNetwork(
    super._network,
    super.authTokenSource,
    // ignore: invalid_use_of_visible_for_testing_member for tests
  ) : super.fromNetwork();

  Future<EncryptedCollectionItem> fetch(
    String itemUid,
    ItemFetchOptions? options,
  ) => invoke<EncryptedCollectionItem>(path: [itemUid], options: options);

  Future<ItemListResponse<EncryptedCollectionItem>> list(
    ItemFetchOptions? options,
  ) => invoke<ItemListResponse<EncryptedCollectionItem>>(options: options);

  Future<IteratorListResponse<EncryptedCollectionItem>> itemRevisions(
    EncryptedCollectionItem item,
    RevisionFetchOptions? options,
  ) async {
    final response = await invoke<IteratorListResponse<EncryptedRevision>>(
      path: [item.uid, 'revision'],
      options: options,
    );
    return response.map((rev) => item.cloneWithRevision(rev));
  }

  Future<void> create(EncryptedCollectionItem item) =>
      invoke<void>(method: HttpMethod.post, body: item);

  Future<ItemListResponse<EncryptedCollectionItem>> fetchUpdates(
    List<EncryptedCollectionItem> items,
    ItemFetchOptions? options,
  ) => invoke<ItemListResponse<EncryptedCollectionItem>>(
    method: HttpMethod.post,
    path: const ['fetch_updates'],
    body: items.toFetchInfo(wantEtag: options?.stoken == null),
    options: options,
  );

  Future<ItemListResponse<EncryptedCollectionItem>> fetchMulti(
    List<String> items,
    ItemFetchOptions? options,
  ) => invoke<ItemListResponse<EncryptedCollectionItem>>(
    method: HttpMethod.post,
    path: const ['fetch_updates'],
    body: items.map(CollectionItemFetchInfo.new).toList(),
    options: options,
  );

  Future<void> batch(
    List<EncryptedCollectionItem> items,
    List<EncryptedCollectionItem>? deps,
    ItemFetchOptions? options,
  ) => invoke<void>(
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
    ItemFetchOptions? options,
  ) => invoke<void>(
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
    ItemFetchOptions? options,
  ) {
    final Chunk(:uid, :data) = chunk;
    if (data == null) {
      throw ApiMissuse('Tried uploading a missing chunk');
    }
    return invoke<void>(
      method: HttpMethod.put,
      path: [item.uid, 'chunk', uid],
      body: data,
      options: options,
    );
  }

  Future<Uint8List> chunkDownload(
    EncryptedCollectionItem item,
    String chunkUid,
    ItemFetchOptions? options,
  ) => invoke<Uint8List>(
    path: [item.uid, 'chunk', chunkUid, 'download'],
    options: options,
  );

  Stream<ItemListResponse<EncryptedCollectionItem>> subscribeChanges(
    ItemFetchOptions? options,
  ) async* {
    final ticket = await invoke<WebSocketTicketResponse>(
      method: HttpMethod.post,
      path: ['subscription-ticket'],
    );
    final ws = client.connectWebSocket(
      client.baseUrl.replace(
        scheme: client.baseUrl.isScheme('http') ? 'ws' : 'wss',
        pathSegments: client.baseUrl.pathSegments
            .followedBy(BaseManager.apiBasePath)
            .followedBy(['ws', ticket.ticket, '']),
        queryParameters: {
          ...client.baseUrl.queryParameters,
          ...queryFromOptions(options),
        },
      ),
    );

    try {
      await ws.ready;

      yield* ws.stream.cast<Uint8List>().map(client.converter.decode);

      final code = ws.closeCode;
      if (code != null && code != 1000) {
        throw WebsocketClosed(code, ws.closeReason);
      }
    } on WebsocketClosed {
      rethrow;
    } on Exception catch (e, s) {
      Error.throwWithStackTrace(ConnectionProblem(e), s);
    } finally {
      await ws.sink.close(status.normalClosure);
    }
  }
}
