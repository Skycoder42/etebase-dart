// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'base/etebase_collection_item_list_response.dart';
import 'etebase_removed_collection.dart';

part 'etebase_collection_list_response.freezed.dart';
part 'etebase_collection_list_response.g.dart';

/// The dart binding of the EtebaseCollectionListResponse rust class
@Freezed(fromJson: false, toJson: false)
sealed class EtebaseCollectionListResponse<T>
    with _$EtebaseCollectionListResponse<T>
    implements EtebaseCollectionItemListResponse<T> {
  @JsonSerializable(genericArgumentFactories: true)
  const factory EtebaseCollectionListResponse({
    required List<T> data,
    @JsonKey(name: 'done') required bool isDone,
    required String? stoken,
    @JsonKey(includeIfNull: false)
    required List<EtebaseRemovedCollection>? removedMemberships,
  }) = _EtebaseCollectionListResponse<T>;

  factory EtebaseCollectionListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$$EtebaseCollectionListResponseImplFromJson<T>(json, fromJsonT);

  const EtebaseCollectionListResponse._();

  /// @nodoc
  @internal
  Map<String, dynamic> toJson() => _$$EtebaseCollectionListResponseImplToJson(
        this as _$EtebaseCollectionListResponseImpl<T>,
        (dynamic i) => i.toJson(),
      );

  /// @nodoc
  @internal
  Future<EtebaseCollectionListResponse<TOther>> mapAsync<TOther>(
    Future<TOther> Function(T) map,
  ) async =>
      EtebaseCollectionListResponse(
        data: [
          for (final item in data) await map(item),
        ],
        isDone: isDone,
        stoken: stoken,
        removedMemberships: removedMemberships,
      );
}
