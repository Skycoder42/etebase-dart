// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';

void main() {
  setUpAll(() async {
    await Etebase.ensureInitialized(loadLibEtebase);
  });

  test('etebaseGetDefaultServerUrl returns correct server URL', () async {
    final result = await etebaseGetDefaultServerUrl();
    expect(result, Uri.https('api.etebase.com', '/'));
  });
}
