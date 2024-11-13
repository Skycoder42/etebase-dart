// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/base/etebase_collection_list_response.dart';
import '../../api/models/etebase_removed_collection.dart';

part 'collection_list_response.freezed.dart';
part 'collection_list_response.g.dart';

@internal
@Freezed(fromJson: false, toJson: false, copyWith: true)
sealed class CollectionListResponse<T>
    with _$CollectionListResponse<T>
    implements EtebaseCollectionListResponse<T> {
  @JsonSerializable(genericArgumentFactories: true)
  const factory CollectionListResponse({
    required List<T> data,
    @JsonKey(name: 'done') required bool isDone,
    required String? stoken,
    @JsonKey(includeIfNull: false)
    required List<EtebaseRemovedCollection>? removedMemberships,
  }) = _CollectionListResponse<T>;

  factory CollectionListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$$CollectionListResponseImplFromJson<T>(json, fromJsonT);

  const CollectionListResponse._();

  /// @nodoc
  @internal
  Map<String, dynamic> toJson() => _$$CollectionListResponseImplToJson(
        this as _$CollectionListResponseImpl<T>,
        (dynamic i) => i.toJson(),
      );

  /// @nodoc
  @internal
  Future<CollectionListResponse<TOther>> mapAsync<TOther>(
    Future<TOther> Function(T) map,
  ) async =>
      CollectionListResponse(
        data: [
          for (final item in data) await map(item),
        ],
        isDone: isDone,
        stoken: stoken,
        removedMemberships: removedMemberships,
      );
}
