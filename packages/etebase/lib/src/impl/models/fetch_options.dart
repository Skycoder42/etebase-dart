// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_prefetch_option.dart';

part 'fetch_options.freezed.dart';

@internal
@freezed
sealed class FetchOptions with _$FetchOptions {
  const factory FetchOptions({
    int? limit,
    String? iterator,
    String? stoken,
    EtebasePrefetchOption? prefetch,
    bool? withCollection,
  }) = _FetchOptions;
}

@internal
extension EtebaseFetchOptionsX on EtebaseFetchOptionsBase {
  FetchOptions asFetchOptions() => switch (this) {
        final EtebaseListFetchOptions o => FetchOptions(
            limit: o.limit,
          ),
        final EtebaseFetchOptions o => FetchOptions(
            limit: o.limit,
            stoken: o.stoken,
            prefetch: o.prefetch,
          ),
        final EtebaseItemFetchOptions o => FetchOptions(
            limit: o.limit,
            stoken: o.stoken,
            prefetch: o.prefetch,
            withCollection: o.withCollection,
          ),
        final EtebaseIteratorFetchOptions o => FetchOptions(
            limit: o.limit,
            iterator: o.iterator,
          ),
        final EtebaseRevisionFetchOptions o => FetchOptions(
            limit: o.limit,
            iterator: o.iterator,
            prefetch: o.prefetch,
          ),
      };
}
