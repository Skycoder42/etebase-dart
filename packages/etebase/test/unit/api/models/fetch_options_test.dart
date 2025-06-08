import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/models/fetch_options.dart';
import 'package:etebase/src/api/models/prefetch_option.dart';
import 'package:test/test.dart';

void main() {
  group('FetchOptionsX', () {
    testData(
      'asItemOptions converts normal to item options',
      [
        (const FetchOptions(), const ItemFetchOptions()),
        (
          const FetchOptions(
            limit: 12,
            prefetch: PrefetchOption.auto,
            stoken: 'test-token',
          ),
          const ItemFetchOptions(
            limit: 12,
            prefetch: PrefetchOption.auto,
            stoken: 'test-token',
          ),
        ),
      ],
      (fixture) {
        expect(fixture.$1.asItemOptions(), fixture.$2);
      },
    );
  });
}
