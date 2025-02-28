import 'package:dart_test_tools/test.dart';
// ignore: no_self_package_imports because the generated file is allowed
import 'package:etebase/gen/package_metadata.dart';
import 'package:etebase/src/impl/online_managers/platform/user_agent_stub.dart';
import 'package:test/test.dart';

void main() {
  group('$UserAgent', () {
    const packageValue = 'package:$package/$version';

    test('build throws unimplemented error', () {
      expect(() => UserAgent.build('test'), throwsUnimplementedError);
    });

    testData(
      'constructs user agent from values',
      [
        ('basic-client', <String>[], null, 'basic-client ($packageValue)'),
        (
          'detailed-client',
          ['value-1', 'value-2'],
          'suffix',
          'detailed-client ($packageValue; value-1; value-2) suffix',
        ),
      ],
      (fixture) {
        final result = UserAgent.buildFromValues(
          fixture.$1,
          values: fixture.$2,
          suffix: fixture.$3,
        );

        expect(result, fixture.$4);
      },
    );
  });
}
