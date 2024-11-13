import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../codec/msg_pack_converters.dart';

part 'collection_list_request.freezed.dart';
part 'collection_list_request.g.dart';

@freezed
@internal
sealed class CollectionListRequest with _$CollectionListRequest {
  @msgPackBytes
  const factory CollectionListRequest(List<Uint8List> collectionTypes) =
      _CollectionListRequest;

  factory CollectionListRequest.fromJson(Map<String, dynamic> json) =>
      _$CollectionListRequestFromJson(json);
}
