import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/models/fetch_options.dart';
import 'package:etebase/src/api/models/prefetch_option.dart';
import 'package:etebase/src/impl/models/http_fetch_options.dart';
import 'package:test/test.dart';

void main() {
  group('HttpFetchOptionsX', () {
    testData(
      'correctly maps etebase fetch options to fetch options',
      const [
        (FetchOptions(), HttpFetchOptions()),
        (
          FetchOptions(
            limit: 10,
            stoken: 'stoken',
            prefetch: PrefetchOption.auto,
          ),
          HttpFetchOptions(
            limit: 10,
            stoken: 'stoken',
            prefetch: PrefetchOption.auto,
          ),
        ),
        (ItemFetchOptions(), HttpFetchOptions()),
        (
          ItemFetchOptions(
            limit: 10,
            stoken: 'stoken',
            prefetch: PrefetchOption.medium,
            withCollection: true,
          ),
          HttpFetchOptions(
            limit: 10,
            stoken: 'stoken',
            prefetch: PrefetchOption.medium,
            withCollection: true,
          ),
        ),
        (IteratorFetchOptions(), HttpFetchOptions()),
        (
          IteratorFetchOptions(limit: 10, iterator: 'iterator'),
          HttpFetchOptions(limit: 10, iterator: 'iterator'),
        ),
        (RevisionFetchOptions(), HttpFetchOptions()),
        (
          RevisionFetchOptions(
            limit: 10,
            iterator: 'iterator',
            prefetch: PrefetchOption.auto,
          ),
          HttpFetchOptions(
            limit: 10,
            iterator: 'iterator',
            prefetch: PrefetchOption.auto,
          ),
        ),
      ],
      (fixture) {
        expect(fixture.$1.asHttpFetchOptions(), fixture.$2);
      },
    );
  });
}
