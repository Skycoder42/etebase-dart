import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/fetch_options.dart';
import '../../api/models/prefetch_option.dart';

part 'http_fetch_options.freezed.dart';

@internal
@freezed
sealed class HttpFetchOptions with _$HttpFetchOptions {
  const factory HttpFetchOptions({
    int? limit,
    String? iterator,
    String? stoken,
    PrefetchOption? prefetch,
    bool? withCollection,
  }) = _HttpFetchOptions;
}

@internal
extension HttpFetchOptionsX on FetchOptionsBase {
  HttpFetchOptions asHttpFetchOptions() => switch (this) {
    final FetchOptions o => HttpFetchOptions(
      limit: o.limit,
      stoken: o.stoken,
      prefetch: o.prefetch,
    ),
    final ItemFetchOptions o => HttpFetchOptions(
      limit: o.limit,
      stoken: o.stoken,
      prefetch: o.prefetch,
      withCollection: o.withCollection,
    ),
    final IteratorFetchOptions o => HttpFetchOptions(
      limit: o.limit,
      iterator: o.iterator,
    ),
    final RevisionFetchOptions o => HttpFetchOptions(
      limit: o.limit,
      iterator: o.iterator,
      prefetch: o.prefetch,
    ),
  };
}
