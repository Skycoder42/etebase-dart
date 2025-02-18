// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../encrypted_models/encrypted_collection_item.dart';

part 'collection_item_fetch_info.freezed.dart';
part 'collection_item_fetch_info.g.dart';

@freezed
@internal
sealed class CollectionItemFetchInfo with _$CollectionItemFetchInfo {
  const factory CollectionItemFetchInfo(
    String uid, {
    @JsonKey(includeIfNull: false) String? etag,
  }) = _CollectionItemFetchInfo;

  factory CollectionItemFetchInfo.fromJson(Map<String, dynamic> json) =>
      _$CollectionItemFetchInfoFromJson(json);
}

@internal
extension CollectionItemFetchInfoFromListX
    on Iterable<EncryptedCollectionItem> {
  List<CollectionItemFetchInfo> toFetchInfo({required bool wantEtag}) =>
      map(
        (i) =>
            CollectionItemFetchInfo(i.uid, etag: wantEtag ? i.lastEtag : null),
      ).toList();
}
