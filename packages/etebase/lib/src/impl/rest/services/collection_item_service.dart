import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../api/exceptions/api_missue.dart';
import '../../../api/models/etebase_fetch_options.dart';
import '../../encrypted_models/chunk.dart';
import '../../encrypted_models/encrypted_collection_item.dart';
import '../../models/collection_item_fetch_info.dart';
import '../../models/collection_item_list_response.dart';
import '../../models/fetch_options.dart';
import '../../models/item_batch_request.dart';
import '../../models/iterator_list_response.dart';
import '../../models/web_socket_ticket_response.dart';
import '../interceptors/msg_pack_converter.dart';

part 'collection_item_service.chopper.dart';

@internal
@ChopperApi(baseUrl: '/api/v1/collection/')
abstract class RawCollectionItemService extends ChopperService {
  static const _pathPrefix = '{colUid}/item';

  RawCollectionItemService();

  factory RawCollectionItemService.create([ChopperClient? client]) =
      _$RawCollectionItemService;

  @Get(path: '$_pathPrefix/{itemUid}/')
  Future<EncryptedCollectionItem> fetch(
    @Path() String colUid,
    @Path() String itemUid,
    @QueryMap() Map<String, dynamic> options,
  );

  @Get(path: '$_pathPrefix/')
  Future<CollectionItemListResponse<EncryptedCollectionItem>> list(
    @Path() String colUid,
    @QueryMap() Map<String, dynamic> options,
  );

  @Get(path: '$_pathPrefix/{itemUid}/revision/')
  Future<IteratorListResponse<EncryptedCollectionItem>> itemRevisions(
    @Path() String colUid,
    @Path() String itemUid,
    @QueryMap() Map<String, dynamic> options,
  );

  @Post(path: '$_pathPrefix/')
  Future<void> create(
    @Path() String colUid,
    @Body() EncryptedCollectionItem item,
  );

  @Post(path: '$_pathPrefix/fetch_updates/')
  Future<CollectionItemListResponse<EncryptedCollectionItem>> fetchUpdates(
    @Path() String colUid,
    @Body() List<CollectionItemFetchInfo> items,
    @QueryMap() Map<String, dynamic> options,
  );

  @Post(path: '$_pathPrefix/batch/')
  Future<void> batch(
    @Path() String colUid,
    @Body() ItemBatchRequest batch,
    @QueryMap() Map<String, dynamic> options,
  );

  @Post(path: '$_pathPrefix/transaction/')
  Future<void> transaction(
    @Path() String colUid,
    @Body() ItemBatchRequest batch,
    @QueryMap() Map<String, dynamic> options,
  );

  @Put(path: '$_pathPrefix/{itemUid}/chunk/{chunkUid}/')
  Future<void> chunkUpload(
    @Path() String colUid,
    @Path() String itemUid,
    @Path() String chunkUid,
    @Body() Uint8List chunk,
    @QueryMap() Map<String, dynamic> options,
  );

  @Get(path: '$_pathPrefix/{itemUid}/chunk/{chunkUid}/download/')
  Future<Uint8List> chunkDownload(
    @Path() String colUid,
    @Path() String itemUid,
    @Path() String chunkUid,
    @QueryMap() Map<String, dynamic> options,
  );

  @Post(path: '$_pathPrefix/subscription-ticket/', optionalBody: true)
  Future<WebSocketTicketResponse> subscribeChanges(@Path() String colUid);
}

@internal
class CollectionItemService {
  final RawCollectionItemService _inner;
  final String _colUid;

  CollectionItemService(this._inner, this._colUid);

  Future<EncryptedCollectionItem> fetch(
    String itemUid,
    EtebaseItemFetchOptions? options,
  ) =>
      _inner.fetch(_colUid, itemUid, options.toQuery());

  Future<CollectionItemListResponse<EncryptedCollectionItem>> list(
    EtebaseItemFetchOptions? options,
  ) =>
      _inner.list(_colUid, options.toQuery());

  Future<IteratorListResponse<EncryptedCollectionItem>> itemRevisions(
    EncryptedCollectionItem item,
    EtebaseRevisionFetchOptions? options,
  ) async {
    final response = await _inner.itemRevisions(
      _colUid,
      item.uid,
      options.toQuery(),
    );
    return response.copyWith(
      data: response.data
          .map((rev) => item.cloneWithRevision(rev.content))
          .toList(),
    );
  }

  Future<void> create(EncryptedCollectionItem item) =>
      _inner.create(_colUid, item);

  Future<CollectionItemListResponse<EncryptedCollectionItem>> fetchUpdates(
    String colUid,
    List<EncryptedCollectionItem> items,
    EtebaseItemFetchOptions? options,
  ) =>
      _inner.fetchUpdates(
        colUid,
        items.toFetchInfo(wantEtag: options?.stoken == null),
        options.toQuery(),
      );

  Future<CollectionItemListResponse<EncryptedCollectionItem>> fetchMulti(
    String colUid,
    List<String> items,
    EtebaseItemFetchOptions? options,
  ) =>
      _inner.fetchUpdates(
        colUid,
        items.map(CollectionItemFetchInfo.new).toList(),
        options.toQuery(),
      );

  Future<void> batch(
    List<EncryptedCollectionItem> items,
    List<EncryptedCollectionItem>? deps,
    EtebaseItemFetchOptions? options,
  ) =>
      _inner.batch(
        _colUid,
        ItemBatchRequest(
          items: items,
          deps: deps?.toFetchInfo(wantEtag: true),
        ),
        options.toQuery(),
      );

  Future<void> transaction(
    List<EncryptedCollectionItem> items,
    List<EncryptedCollectionItem>? deps,
    EtebaseItemFetchOptions? options,
  ) =>
      _inner.transaction(
        _colUid,
        ItemBatchRequest(
          items: items,
          deps: deps?.toFetchInfo(wantEtag: true),
        ),
        options.toQuery(),
      );

  Future<void> chunkUpload(
    EncryptedCollectionItem item,
    Chunk chunk,
    EtebaseItemFetchOptions? options,
  ) {
    final Chunk(:uid, :data) = chunk;
    if (data == null) {
      throw ApiMissuse('Tried uploading a missing chunk.');
    }
    return _inner.chunkUpload(
      _colUid,
      item.uid,
      uid,
      data,
      options.toQuery(),
    );
  }

  Future<Uint8List> chunkDownload(
    EncryptedCollectionItem item,
    String chunkUid,
    EtebaseItemFetchOptions? options,
  ) =>
      _inner.chunkDownload(_colUid, item.uid, chunkUid, options.toQuery());

  Stream<CollectionItemListResponse<EncryptedCollectionItem>> subscribeChanges(
    EtebaseItemFetchOptions? options,
  ) async* {
    final ticket = await _inner.subscribeChanges(_colUid);
    final baseUrl = _inner.client.baseUrl;
    final converter = _inner.client.converter! as MsgPackConverter;
    final ws = WebSocketChannel.connect(
      baseUrl.replace(
        scheme: baseUrl.isScheme('http') ? 'ws' : 'wss',
        queryParameters: {
          ...baseUrl.queryParameters,
          ...options.toQuery(),
        },
      ).resolve('api/v1/ws/${ticket.ticket}'),
    );

    try {
      await ws.ready;
      yield* ws.stream.cast<Uint8List>().map(converter.convertKnownType);
    } finally {
      await ws.sink.close(status.normalClosure);
    }
  }
}
