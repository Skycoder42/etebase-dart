// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_prefetch_option.dart';

part 'fetch_options.freezed.dart';
part 'fetch_options.g.dart';

@freezed
sealed class _FetchOptionsImpl with _$FetchOptionsImpl {
  @JsonSerializable(includeIfNull: false)
  const factory _FetchOptionsImpl({
    int? limit,
    String? iterator,
    String? stoken,
    EtebasePrefetchOption? prefetch,
    bool? withCollection,
  }) = __FetchOptionsImpl;

  // ignore: unused_element
  factory _FetchOptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$FetchOptionsImplFromJson(json);

  const _FetchOptionsImpl._();

  Map<String, dynamic> toQuery({bool stringify = false}) {
    final map = toJson();
    if (map case {'limit': <= 0}) {
      map.remove('limit');
    }
    if (map case {'prefetch': final String value}) {
      map.remove('prefetch');
      map[value] = '';
    }
    return stringify
        ? map.map((k, dynamic v) => MapEntry(k, v.toString()))
        : map;
  }
}

@internal
extension EtebaseFetchOptionsX on EtebaseFetchOptionsBase? {
  Map<String, dynamic> toQuery() => switch (this) {
        null => const {},
        final EtebaseListFetchOptions o => _FetchOptionsImpl(
            limit: o.limit,
          ).toQuery(),
        final EtebaseFetchOptions o => _FetchOptionsImpl(
            limit: o.limit,
            stoken: o.stoken,
            prefetch: o.prefetch,
          ).toQuery(),
        final EtebaseItemFetchOptions o => _FetchOptionsImpl(
            limit: o.limit,
            stoken: o.stoken,
            prefetch: o.prefetch,
            withCollection: o.withCollection,
          ).toQuery(),
        final EtebaseIteratorFetchOptions o => _FetchOptionsImpl(
            limit: o.limit,
            iterator: o.iterator,
          ).toQuery(),
        final EtebaseRevisionFetchOptions o => _FetchOptionsImpl(
            limit: o.limit,
            iterator: o.iterator,
            prefetch: o.prefetch,
          ).toQuery(),
      };
}
