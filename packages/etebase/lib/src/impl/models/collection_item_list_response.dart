// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/base/etebase_collection_item_list_response.dart';

part 'collection_item_list_response.freezed.dart';
part 'collection_item_list_response.g.dart';

@internal
@Freezed(fromJson: false, toJson: false, copyWith: true)
sealed class CollectionItemListResponse<T>
    with _$CollectionItemListResponse<T>
    implements EtebaseCollectionItemListResponse<T> {
  @JsonSerializable(genericArgumentFactories: true)
  const factory CollectionItemListResponse({
    required List<T> data,
    @JsonKey(name: 'done') required bool isDone,
    required String? stoken,
  }) = _CollectionItemListResponse<T>;

  factory CollectionItemListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$$CollectionItemListResponseImplFromJson<T>(json, fromJsonT);

  const CollectionItemListResponse._();

  /// @nodoc
  @internal
  Map<String, dynamic> toJson() => _$$CollectionItemListResponseImplToJson(
        this as _$CollectionItemListResponseImpl<T>,
        (dynamic i) => i.toJson(),
      );

  /// @nodoc
  @internal
  Future<CollectionItemListResponse<TOther>> mapAsync<TOther>(
    Future<TOther> Function(T) map,
  ) async =>
      CollectionItemListResponse(
        data: [
          for (final item in data) await map(item),
        ],
        isDone: isDone,
        stoken: stoken,
      );
}
