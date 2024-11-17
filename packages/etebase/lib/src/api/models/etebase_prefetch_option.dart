// coverage:ignore-file

import 'etebase_fetch_options.dart';

/// Dictates how much data to prefetch when passed to [EtebaseFetchOptionsBase].
enum EtebasePrefetchOption {
  /// Automatically decide based on the size of the data fetched.
  auto,

  /// Attempt to fetch a more lightweight (medium) amount of data.
  medium,
}
