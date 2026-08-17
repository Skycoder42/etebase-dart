// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'fetch_options.dart';
import 'removed_collection.dart';

part 'list_response.freezed.dart';
part 'list_response.g.dart';

const _doneKey = JsonKey(name: 'done');

/// The response of fetching a list.
///
/// The [data] field will contain the elements returned by this response. If
/// [isDone] is true, no more elements are available on the server. Otherwise
/// you have to continuously fetch more elements until you are done.
///
/// Depending on the subtype of the response you have to either use the stoken
/// or the iterator.
/// - For [ItemListResponse]s and [CollectionListResponse]s, you
/// must use the stoken and pass it via a [FetchOptions.stoken].
/// - For [IteratorListResponse]s, you should instead use the
/// [IteratorFetchOptions.iterator].
@Freezed(fromJson: false, toJson: false)
sealed class ListResponse<T extends Object> with _$ListResponse<T> {
  /// The response of fetching an item list.
  @JsonSerializable(genericArgumentFactories: true)
  @With.fromString('_ItemMixin<T>')
  const factory item({
    /// List of collections included in the response.
    required List<T> data,

    /// Indicates whether there are no more collections to fetch.
    @_doneKey required bool isDone,

    /// Sync token for the list response.
    String? stoken,
  }) = ItemListResponse<T>;

  /// The response of fetching a collection list.
  @JsonSerializable(genericArgumentFactories: true)
  @With.fromString('_CollectionMixin<T>')
  const factory collection({
    /// List of collections included in the response.
    required List<T> data,

    /// Indicates whether there are no more collections to fetch.
    @_doneKey required bool isDone,

    /// Sync token for the list response.
    String? stoken,

    /// The list of collections to which the user lost access.
    List<RemovedCollection>? removedMemberships,
  }) = CollectionListResponse<T>;

  /// The response of fetching a generic iterable data list.
  @JsonSerializable(genericArgumentFactories: true)
  @With.fromString('_IteratorMixin<T>')
  const factory iterator({
    /// List of collections included in the response.
    required List<T> data,

    /// Indicates whether there are no more collections to fetch.
    @_doneKey required bool isDone,

    /// Iterator for the list response.
    required String? iterator,
  }) = IteratorListResponse<T>;

  const new _();

  // coverage:ignore-start
  /// Creates a new response by mapping the [data].
  ///
  /// The [map] callback is used to transform each value in [data]. All other
  /// properties are copied over to the new response.
  ListResponse<TOther> map<TOther extends Object>(TOther Function(T) map) =>
      throw UnimplementedError();

  /// @nodoc
  @internal
  Map<String, dynamic> toJson() => throw UnimplementedError();

  /// @nodoc
  @internal
  static ItemListResponse<T> itemFromJson<T extends Object>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ItemListResponseFromJson(json, fromJsonT);

  /// @nodoc
  @internal
  static CollectionListResponse<T> collectionFromJson<T extends Object>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$CollectionListResponseFromJson(json, fromJsonT);

  /// @nodoc
  @internal
  static IteratorListResponse<T> iteratorFromJson<T extends Object>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$IteratorListResponseFromJson(json, fromJsonT);
  // coverage:ignore-end
}

mixin _ItemMixin<T extends Object> on ListResponse<T> {
  @override
  ItemListResponse<TOther> map<TOther extends Object>(TOther Function(T) map) =>
      ItemListResponse(
        data: [for (final item in data) map(item)],
        isDone: isDone,
        stoken: (this as ItemListResponse).stoken,
      );

  // coverage:ignore-start
  @override
  Map<String, dynamic> toJson() => _$ItemListResponseToJson<T>(
    this as ItemListResponse<T>,
    // ignore: avoid_dynamic_calls
    (dynamic value) => value.toJson(),
  );
  // coverage:ignore-end
}

mixin _CollectionMixin<T extends Object> on ListResponse<T> {
  @override
  CollectionListResponse<TOther> map<TOther extends Object>(
    TOther Function(T) map,
  ) => CollectionListResponse(
    data: [for (final item in data) map(item)],
    isDone: isDone,
    stoken: (this as CollectionListResponse).stoken,
    removedMemberships: (this as CollectionListResponse).removedMemberships,
  );

  // coverage:ignore-start
  @override
  Map<String, dynamic> toJson() => _$CollectionListResponseToJson<T>(
    this as CollectionListResponse<T>,
    // ignore: avoid_dynamic_calls
    (dynamic value) => value.toJson(),
  );
  // coverage:ignore-end
}

mixin _IteratorMixin<T extends Object> on ListResponse<T> {
  @override
  IteratorListResponse<TOther> map<TOther extends Object>(
    TOther Function(T) map,
  ) => IteratorListResponse(
    data: [for (final item in data) map(item)],
    isDone: isDone,
    iterator: (this as IteratorListResponse).iterator,
  );

  // coverage:ignore-start
  @override
  Map<String, dynamic> toJson() => _$IteratorListResponseToJson<T>(
    this as IteratorListResponse<T>,
    // ignore: avoid_dynamic_calls
    (dynamic value) => value.toJson(),
  );
  // coverage:ignore-end
}
