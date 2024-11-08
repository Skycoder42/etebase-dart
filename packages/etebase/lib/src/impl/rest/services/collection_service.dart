import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

import '../../../api/models/etebase_fetch_options.dart';
import '../../encrypted_models/encrypted_collection.dart';
import '../../models/collection_list_request.dart';
import '../../models/collection_list_response.dart';

part 'collection_service.chopper.dart';

@internal
@ChopperApi(baseUrl: '/api/v1/collection/')
abstract class CollectionService extends ChopperService {
  CollectionService();

  factory CollectionService.create([ChopperClient? client]) =
      _$CollectionService;

  @Get(path: '{colUid}/')
  Future<EncryptedCollection> _fetch(
    @Path() String colUid,
    @QueryMap() Map<String, dynamic> options,
  );

  Future<EncryptedCollection> fetch(
    String colUid,
    EtebaseFetchOptions? options,
  ) =>
      _fetch(colUid, options?.toJson() ?? const {});

  @Post(path: 'list_multi/')
  Future<CollectionListResponse> _list(
    @Body() CollectionListRequest collectionTypes,
    @QueryMap() Map<String, dynamic> options,
  );

  Future<CollectionListResponse> list(
    List<Uint8List> collectionTypes,
    EtebaseFetchOptions? options,
  ) =>
      _list(
        CollectionListRequest(collectionTypes),
        options?.toJson() ?? const {},
      );

  @Post()
  Future<void> _create(
    @Body() EncryptedCollection collection,
    @QueryMap() Map<String, dynamic> options,
  );

  Future<void> create(
    EncryptedCollection collection,
    EtebaseFetchOptions? options,
  ) =>
      _create(collection, options?.toJson() ?? const {});
}
