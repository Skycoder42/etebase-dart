// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

import 'prefetch_option.dart';

part 'fetch_options.freezed.dart';

/// Configuration options for data fetching.
@Freezed(copyWith: true)
sealed class FetchOptionsBase with _$FetchOptionsBase {
  const factory({
    /// Limit the amount of items returned.
    int? limit,

    /// The sync token to fetch with.
    String? stoken,

    /// How much data to prefetch.
    PrefetchOption? prefetch,
  }) = FetchOptions;

  const factory item({
    /// Limit the amount of items returned.
    int? limit,

    /// The sync token to fetch with.
    String? stoken,

    /// How much data to prefetch.
    PrefetchOption? prefetch,

    /// Toggle fetching the collection's items.
    bool? withCollection,
  }) = ItemFetchOptions;

  const factory iterator({
    /// Limit the amount of items returned.
    int? limit,

    /// The current iterator to start from (when iterating lists).
    String? iterator,
  }) = IteratorFetchOptions;

  const factory revision({
    /// Limit the amount of items returned.
    int? limit,

    /// The current iterator to start from (when iterating lists).
    String? iterator,

    /// How much data to prefetch.
    PrefetchOption? prefetch,
  }) = RevisionFetchOptions;

  const new _();
}

@internal
extension FetchOptionsX on FetchOptions {
  ItemFetchOptions asItemOptions() =>
      ItemFetchOptions(limit: limit, stoken: stoken, prefetch: prefetch);
}
