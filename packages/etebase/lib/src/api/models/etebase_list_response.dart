// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'etebase_fetch_options.dart';
import 'etebase_removed_collection.dart';

part 'etebase_list_response.freezed.dart';
part 'etebase_list_response.g.dart';

const _doneKey = JsonKey(name: 'done');

/// The response of fetching a list.
///
/// The [data] field will contain the elements returned by this response. If
/// [isDone] is true, no more elements are available on the server. Otherwise
/// you have to continuously fetch more elements until you are done.
///
/// Depending on the subtype of the response you have to either use the stoken
/// or the iterator.
/// - For [EtebaseItemListResponse]s and [EtebaseCollectionListResponse]s, you
/// must use the stoken and pass it via a [EtebaseFetchOptions.stoken].
/// - For [EtebaseIteratorListResponse]s, you should instead use the
/// [EtebaseIteratorFetchOptions.iterator].
@Freezed(fromJson: false, toJson: false)
sealed class EtebaseListResponse<T extends Object>
    with _$EtebaseListResponse<T> {
  /// The response of fetching an item list.
  @JsonSerializable(genericArgumentFactories: true)
  @With.fromString('_ItemMixin<T>')
  const factory EtebaseListResponse.item({
    /// List of collections included in the response.
    required List<T> data,

    /// Indicates whether there are no more collections to fetch.
    @_doneKey required bool isDone,

    /// Sync token for the list response.
    String? stoken,
  }) = EtebaseItemListResponse<T>;

  /// The response of fetching a collection list.
  @JsonSerializable(genericArgumentFactories: true)
  @With.fromString('_CollectionMixin<T>')
  const factory EtebaseListResponse.collection({
    /// List of collections included in the response.
    required List<T> data,

    /// Indicates whether there are no more collections to fetch.
    @_doneKey required bool isDone,

    /// Sync token for the list response.
    String? stoken,

    /// The list of collections to which the user lost access.
    List<EtebaseRemovedCollection>? removedMemberships,
  }) = EtebaseCollectionListResponse<T>;

  /// The response of fetching a generic iterable data list.
  @JsonSerializable(genericArgumentFactories: true)
  @With.fromString('_IteratorMixin<T>')
  const factory EtebaseListResponse.iterator({
    /// List of collections included in the response.
    required List<T> data,

    /// Indicates whether there are no more collections to fetch.
    @_doneKey required bool isDone,

    /// Iterator for the list response.
    required String? iterator,
  }) = EtebaseIteratorListResponse<T>;

  const EtebaseListResponse._();

  // coverage:ignore-start
  /// Creates a new response by mapping the [data].
  ///
  /// The [map] callback is used to transform each value in [data]. All other
  /// properties are copied over to the new response.
  EtebaseListResponse<TOther> map<TOther extends Object>(
    TOther Function(T) map,
  ) => throw UnimplementedError();

  /// @nodoc
  @internal
  Map<String, dynamic> toJson() => throw UnimplementedError();

  /// @nodoc
  @internal
  static EtebaseItemListResponse<T> itemFromJson<T extends Object>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$EtebaseItemListResponseFromJson(json, fromJsonT);

  /// @nodoc
  @internal
  static EtebaseCollectionListResponse<T> collectionFromJson<T extends Object>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$EtebaseCollectionListResponseFromJson(json, fromJsonT);

  /// @nodoc
  @internal
  static EtebaseIteratorListResponse<T> iteratorFromJson<T extends Object>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$EtebaseIteratorListResponseFromJson(json, fromJsonT);
  // coverage:ignore-end
}

mixin _ItemMixin<T extends Object> on EtebaseListResponse<T> {
  @override
  EtebaseItemListResponse<TOther> map<TOther extends Object>(
    TOther Function(T) map,
  ) => EtebaseItemListResponse(
    data: [for (final item in data) map(item)],
    isDone: isDone,
    stoken: (this as EtebaseItemListResponse).stoken,
  );

  // coverage:ignore-start
  @override
  Map<String, dynamic> toJson() => _$EtebaseItemListResponseToJson<T>(
    this as EtebaseItemListResponse<T>,
    // ignore: avoid_dynamic_calls
    (dynamic value) => value.toJson(),
  );
  // coverage:ignore-end
}

mixin _CollectionMixin<T extends Object> on EtebaseListResponse<T> {
  @override
  EtebaseCollectionListResponse<TOther> map<TOther extends Object>(
    TOther Function(T) map,
  ) => EtebaseCollectionListResponse(
    data: [for (final item in data) map(item)],
    isDone: isDone,
    stoken: (this as EtebaseCollectionListResponse).stoken,
    removedMemberships:
        (this as EtebaseCollectionListResponse).removedMemberships,
  );

  // coverage:ignore-start
  @override
  Map<String, dynamic> toJson() => _$EtebaseCollectionListResponseToJson<T>(
    this as EtebaseCollectionListResponse<T>,
    // ignore: avoid_dynamic_calls
    (dynamic value) => value.toJson(),
  );
  // coverage:ignore-end
}

mixin _IteratorMixin<T extends Object> on EtebaseListResponse<T> {
  @override
  EtebaseIteratorListResponse<TOther> map<TOther extends Object>(
    TOther Function(T) map,
  ) => EtebaseIteratorListResponse(
    data: [for (final item in data) map(item)],
    isDone: isDone,
    iterator: (this as EtebaseIteratorListResponse).iterator,
  );

  // coverage:ignore-start
  @override
  Map<String, dynamic> toJson() => _$EtebaseIteratorListResponseToJson<T>(
    this as EtebaseIteratorListResponse<T>,
    // ignore: avoid_dynamic_calls
    (dynamic value) => value.toJson(),
  );
  // coverage:ignore-end
}
