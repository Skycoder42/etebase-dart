import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/models/etebase_fetch_options.dart';
import 'package:etebase/src/api/models/etebase_prefetch_option.dart';
import 'package:test/test.dart';

void main() {
  group('EtebaseFetchOptionsX', () {
    testData(
      'asItemOptions converts normal to item options',
      [
        (const EtebaseFetchOptions(), const EtebaseItemFetchOptions()),
        (
          const EtebaseFetchOptions(
            limit: 12,
            prefetch: EtebasePrefetchOption.auto,
            stoken: 'test-token',
          ),
          const EtebaseItemFetchOptions(
            limit: 12,
            prefetch: EtebasePrefetchOption.auto,
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
