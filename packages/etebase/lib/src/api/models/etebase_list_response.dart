// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'etebase_removed_collection.dart';

part 'etebase_list_response.freezed.dart';
part 'etebase_list_response.g.dart';

const _doneKey = JsonKey(name: 'done');

/// The response of fetching a list
@Freezed(fromJson: false, toJson: false)
sealed class EtebaseListResponse<T extends Object>
    with _$EtebaseListResponse<T> {
  /// The response of fetching an item list
  @JsonSerializable(genericArgumentFactories: true)
  @With<_ItemMixin<T>>()
  const factory EtebaseListResponse.item({
    /// List of collections included in the response
    required List<T> data,

    /// Indicates whether there are no more collections to fetch
    @_doneKey required bool isDone,

    /// Sync token for the list response
    String? stoken,
  }) = EtebaseItemListResponse<T>;

  /// The response of fetching a collection list
  @JsonSerializable(genericArgumentFactories: true)
  @With<_CollectionMixin<T>>()
  const factory EtebaseListResponse.collection({
    /// List of collections included in the response
    required List<T> data,

    /// Indicates whether there are no more collections to fetch
    @_doneKey required bool isDone,

    /// Sync token for the list response
    String? stoken,

    /// The list of collections to which the user lost access
    List<EtebaseRemovedCollection>? removedMemberships,
  }) = EtebaseCollectionListResponse<T>;

  /// The response of fetching a generic iterable data list
  @JsonSerializable(genericArgumentFactories: true)
  @With<_IteratorMixin<T>>()
  const factory EtebaseListResponse.iterator({
    /// List of collections included in the response
    required List<T> data,

    /// Indicates whether there are no more collections to fetch
    @_doneKey required bool isDone,

    /// Iterator for the list response
    required String iterator,
  }) = EtebaseIteratorListResponse<T>;

  const EtebaseListResponse._();

  /// Creates a new response by mapping the [data].
  ///
  /// The [map] callback is used to transform each value in [data]. All other
  /// properties are copied over to the new response.
  EtebaseListResponse<TOther> map<TOther extends Object>(
    TOther Function(T) map,
  ) =>
      throw UnimplementedError();

  /// @nodoc
  @internal
  Map<String, dynamic> toJson() => throw UnimplementedError();

  /// @nodoc
  @internal
  static EtebaseItemListResponse<T> itemFromJson<T extends Object>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$$EtebaseItemListResponseImplFromJson(json, fromJsonT);

  /// @nodoc
  @internal
  static EtebaseCollectionListResponse<T> collectionFromJson<T extends Object>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$$EtebaseCollectionListResponseImplFromJson(json, fromJsonT);

  /// @nodoc
  @internal
  static EtebaseIteratorListResponse<T> iteratorFromJson<T extends Object>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$$EtebaseIteratorListResponseImplFromJson(json, fromJsonT);
}

mixin _ItemMixin<T extends Object> on EtebaseListResponse<T> {
  @override
  EtebaseItemListResponse<TOther> map<TOther extends Object>(
    TOther Function(T) map,
  ) =>
      EtebaseItemListResponse(
        data: [
          for (final item in data) map(item),
        ],
        isDone: isDone,
        stoken: (this as EtebaseItemListResponse).stoken,
      );

  @override
  Map<String, dynamic> toJson() => _$$EtebaseItemListResponseImplToJson<T>(
        this as _$EtebaseItemListResponseImpl<T>,
        // ignore: avoid_dynamic_calls
        (dynamic value) => value.toJson(),
      );
}

mixin _CollectionMixin<T extends Object> on EtebaseListResponse<T> {
  @override
  EtebaseCollectionListResponse<TOther> map<TOther extends Object>(
    TOther Function(T) map,
  ) =>
      EtebaseCollectionListResponse(
        data: [
          for (final item in data) map(item),
        ],
        isDone: isDone,
        stoken: (this as EtebaseCollectionListResponse).stoken,
        removedMemberships:
            (this as EtebaseCollectionListResponse).removedMemberships,
      );

  @override
  Map<String, dynamic> toJson() =>
      _$$EtebaseCollectionListResponseImplToJson<T>(
        this as _$EtebaseCollectionListResponseImpl<T>,
        // ignore: avoid_dynamic_calls
        (dynamic value) => value.toJson(),
      );
}

mixin _IteratorMixin<T extends Object> on EtebaseListResponse<T> {
  @override
  EtebaseIteratorListResponse<TOther> map<TOther extends Object>(
    TOther Function(T) map,
  ) =>
      EtebaseIteratorListResponse(
        data: [
          for (final item in data) map(item),
        ],
        isDone: isDone,
        iterator: (this as EtebaseIteratorListResponse).iterator,
      );

  @override
  Map<String, dynamic> toJson() => _$$EtebaseIteratorListResponseImplToJson<T>(
        this as _$EtebaseIteratorListResponseImpl<T>,
        // ignore: avoid_dynamic_calls
        (dynamic value) => value.toJson(),
      );
}
