import 'package:freezed_annotation/freezed_annotation.dart';

import '../encrypted_models/encrypted_collection_item.dart';
import 'collection_item_fetch_info.dart';

part 'item_batch_request.freezed.dart';
part 'item_batch_request.g.dart';

@freezed
@internal
sealed class ItemBatchRequest with _$ItemBatchRequest {
  const factory ItemBatchRequest({
    required List<EncryptedCollectionItem> items,
    List<CollectionItemFetchInfo>? deps,
  }) = _ItemBatchRequest;

  factory ItemBatchRequest.fromJson(Map<String, dynamic> json) =>
      _$ItemBatchRequestFromJson(json);
}
