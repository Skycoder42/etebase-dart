import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

import '../../../api/models/etebase_fetch_options.dart';
import '../../encrypted_models/encrypted_collection_item.dart';
import '../../models/collection_item_list_response.dart';

part 'collection_item_service.chopper.dart';

@ChopperApi(baseUrl: '/api/v1/collection/')
abstract class _CollectionItemService extends ChopperService {
  static const _pathPrefix = '{colUid}/item';

  _CollectionItemService();

  factory _CollectionItemService.create([ChopperClient? client]) =
      _$_CollectionItemService;

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
}

@internal
class BoundCollectionItemService {
  final _CollectionItemService _collectionItemService;
  final String _colUid;

  BoundCollectionItemService(this._collectionItemService, this._colUid);

  Future<EncryptedCollectionItem> fetch(
    String itemUid,
    EtebaseFetchOptions? options,
  ) =>
      _collectionItemService.fetch(
        _colUid,
        itemUid,
        options?.toJson() ?? const {},
      );

  Future<CollectionItemListResponse<EncryptedCollectionItem>> list(
    EtebaseFetchOptions? options,
  ) =>
      _collectionItemService.list(
        _colUid,
        options?.toJson() ?? const {},
      );
}
