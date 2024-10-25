import 'package:freezed_annotation/freezed_annotation.dart';

import 'etebase_prefetch_option.dart';

part 'etebase_fetch_options.freezed.dart';

/// The dart binding of the EtebaseFetchOptions rust class
@freezed
sealed class EtebaseFetchOptions with _$EtebaseFetchOptions {
  /// Return a new fetch options object
  ///
  /// Should be destroyed with `etebase_fetch_options_destroy`
  const factory EtebaseFetchOptions({
    /// The sync token to fetch with
    ///
    /// @param this_ the object handle
    /// @param stoken the sync token to set
    String? stoken,

    /// The current iterator to start from (when iterating lists)
    ///
    /// @param this_ the object handle
    /// @param iterator the iterator to start from
    String? iterator,

    /// Toggle fetching the collection's item
    ///
    /// @param this_ the object handle
    /// @param with_collection set whether to fetch the collection's item
    bool? withCollection,

    /// How much data to prefetech
    ///
    /// @param this_ the object handle
    /// @param prefetch the prefetch option to set
    EtebasePrefetchOption? prefetch,

    /// Limit the amount of items returned
    ///
    /// @param this_ the object handle
    /// @param limit the limit to set
    int? limit,
  }) = _EtebaseFetchOptions;
}
