// coverage:ignore-file
/// @docImport 'fetch_options.dart';
/// @docImport 'item.dart';
library;

/// Dictates how much data to prefetch when passed to [FetchOptionsBase].
enum PrefetchOption {
  /// Automatically decide based on the size of the data fetched.
  ///
  /// Usually, this will download the item and the content, but if the item gets
  /// too big, the server may decide to only send chunks without content. You
  /// can use [Item.isMissingContent] to check if content was downloaded.
  auto,

  /// Attempt to fetch a more lightweight (medium) amount of data.
  ///
  /// Fetches items and their list of chunks, but not the content itself.
  medium,
}
