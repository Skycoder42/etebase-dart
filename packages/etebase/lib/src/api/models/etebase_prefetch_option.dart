// coverage:ignore-file

/// Dictates how much data to prefetch when passed to `EtebaseFetchOptions`.
enum EtebasePrefetchOption {
  /// Automatically decide based on the size of the data fetched.
  optionAuto,

  /// Attempt to fetch a more lightweight (medium) amount of data.
  optionMedium,
}
