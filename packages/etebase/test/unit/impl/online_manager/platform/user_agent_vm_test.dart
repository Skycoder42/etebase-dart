@TestOn('dart-vm')
library;

import 'dart:io';

import 'package:etebase/gen/package_metadata.dart';
import 'package:etebase/src/impl/online_managers/platform/user_agent_vm.dart';
import 'package:test/test.dart';

void main() {
  group('$UserAgent (vm)', () {
    test('build creates user agent from dart vm information', () {
      final result = UserAgent.build('test-client');

      expect(
        result,
        'test-client (package:$package/$version; Dart/${Platform.version}; ${Platform.operatingSystem}; ${Platform.operatingSystemVersion})',
      );
    });
  });
}
