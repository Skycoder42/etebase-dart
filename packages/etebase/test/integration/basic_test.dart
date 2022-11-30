// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'util/library_loader.dart';
import 'util/server_controller.dart';

void main() {
  setUpAll(() async {
    await ServerController().start();

    await Etebase.ensureInitialized(loadLibEtebase);
  });

  test('Check server is reachable', () async {
    await Future<void>.delayed(const Duration(seconds: 5));
    fail('nothing');
  });
}
