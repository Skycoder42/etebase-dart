import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/models/etebase_fetch_options.dart';
import 'package:etebase/src/api/models/etebase_prefetch_option.dart';
import 'package:etebase/src/impl/models/fetch_options.dart';
import 'package:test/test.dart';

void main() {
  group('EtebaseFetchOptionsX', () {
    testData(
      'correctly maps etebase fetch options to fetch options',
      const [
        (EtebaseFetchOptions(), FetchOptions()),
        (
          EtebaseFetchOptions(
            limit: 10,
            stoken: 'stoken',
            prefetch: EtebasePrefetchOption.auto,
          ),
          FetchOptions(
            limit: 10,
            stoken: 'stoken',
            prefetch: EtebasePrefetchOption.auto,
          ),
        ),
        (EtebaseItemFetchOptions(), FetchOptions()),
        (
          EtebaseItemFetchOptions(
            limit: 10,
            stoken: 'stoken',
            prefetch: EtebasePrefetchOption.medium,
            withCollection: true,
          ),
          FetchOptions(
            limit: 10,
            stoken: 'stoken',
            prefetch: EtebasePrefetchOption.medium,
            withCollection: true,
          ),
        ),
        (EtebaseIteratorFetchOptions(), FetchOptions()),
        (
          EtebaseIteratorFetchOptions(limit: 10, iterator: 'iterator'),
          FetchOptions(limit: 10, iterator: 'iterator'),
        ),
        (EtebaseRevisionFetchOptions(), FetchOptions()),
        (
          EtebaseRevisionFetchOptions(
            limit: 10,
            iterator: 'iterator',
            prefetch: EtebasePrefetchOption.auto,
          ),
          FetchOptions(
            limit: 10,
            iterator: 'iterator',
            prefetch: EtebasePrefetchOption.auto,
          ),
        ),
      ],
      (fixture) {
        expect(fixture.$1.asFetchOptions(), fixture.$2);
      },
    );
  });
}
