@TestOn('browser')
library;

import 'package:etebase/gen/package_metadata.dart';
import 'package:etebase/src/impl/online_managers/platform/user_agent_web.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  group('$UserAgent (web)', () {
    test('build creates user agent from browser user agent', () {
      final result = UserAgent.build('test-client');

      expect(
        result,
        'test-client (package:$package/$version) ${window.navigator.userAgent}',
      );
    });
  });
}
