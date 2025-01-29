import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/impl/codec/date_time_millis_converter.dart';
import 'package:test/test.dart';

void main() {
  group('$DateTimeMillisConverter', () {
    testData(
      'converts data from and to milliseconds since 1970',
      [
        (DateTime.utc(0), -62167219200000),
        (DateTime.utc(1970), 0),
        (DateTime.utc(1970, 1, 1, 0, 0, 0, 1), 1),
        (DateTime.utc(1969, 12, 31, 23, 59, 59, 999), -1),
        (DateTime.utc(2023, 6, 29, 12, 44, 12), 1688042652000),
      ],
      (fixture) {
        expect(dateTimeMillis.toJson(fixture.$1), fixture.$2);
        expect(dateTimeMillis.fromJson(fixture.$2), fixture.$1);
      },
    );
  });
}
