// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';

void main() {
  late final EtebaseClient sut;

  setUp(() async {
    sut = await createClient();
  });

  tearDown(() async {
    await sut.dispose();
  });

  test('etebaseGetDefaultServerUrl returns correct server URL', () async {
    expect(sut.checkEtebaseServer(), completion(isTrue));
  });
}
