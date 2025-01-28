// coverage:ignore-file
// ignore_for_file: invalid_annotation_target, unused_element

import 'package:freezed_annotation/freezed_annotation.dart';

import 'etebase_prefetch_option.dart';

part 'etebase_fetch_options.freezed.dart';

/// Configuration options for data fetching.
@Freezed(copyWith: true)
sealed class EtebaseFetchOptionsBase with _$EtebaseFetchOptionsBase {
  const factory EtebaseFetchOptionsBase({
    /// Limit the amount of items returned.
    int? limit,

    /// The sync token to fetch with.
    String? stoken,

    /// How much data to prefetch.
    EtebasePrefetchOption? prefetch,
  }) = EtebaseFetchOptions;

  const factory EtebaseFetchOptionsBase.item({
    /// Limit the amount of items returned.
    int? limit,

    /// The sync token to fetch with.
    String? stoken,

    /// How much data to prefetch.
    EtebasePrefetchOption? prefetch,

    /// Toggle fetching the collection's items.
    bool? withCollection,
  }) = EtebaseItemFetchOptions;

  const factory EtebaseFetchOptionsBase.iterator({
    /// Limit the amount of items returned.
    int? limit,

    /// The current iterator to start from (when iterating lists).
    String? iterator,
  }) = EtebaseIteratorFetchOptions;

  const factory EtebaseFetchOptionsBase.revision({
    /// Limit the amount of items returned.
    int? limit,

    /// The current iterator to start from (when iterating lists).
    String? iterator,

    /// How much data to prefetch.
    EtebasePrefetchOption? prefetch,
  }) = EtebaseRevisionFetchOptions;

  const EtebaseFetchOptionsBase._();
}
