// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../encrypted_models/encrypted_collection.dart';
import 'removed_collection.dart';

part 'collection_list_response.freezed.dart';
part 'collection_list_response.g.dart';

@freezed
@internal
sealed class CollectionListResponse with _$CollectionListResponse {
  const factory CollectionListResponse({
    required List<EncryptedCollection> data,
    required bool done,
    required String stoken,
    @JsonKey(includeIfNull: false) List<RemovedCollection>? removedMemberships,
  }) = _CollectionListResponse;

  factory CollectionListResponse.fromJson(Map<String, dynamic> json) =>
      _$CollectionListResponseFromJson(json);
}
