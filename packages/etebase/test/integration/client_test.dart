import 'dart:io';
import 'dart:typed_data';

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';

void main() {
  late final Client sut;

  setUpAll(() async {
    sut = await createClient(useDefaultServer: !kIsWeb && Platform.isWindows);
  });

  tearDownAll(() async {
    await sut.dispose();
  });

  test('etebaseGetDefaultServerUrl returns correct server URL', () {
    expect(sut.checkEtebaseServer(), completion(isTrue));
  });

  group('utils', () {
    test('can generate random data and key', () {
      final r1 = sut.randombytes(42);
      final r2 = sut.randomKey(42);

      expect(r1, hasLength(42));
      expect(r2, hasLength(42));
      expect(r1, isNot(Uint8List(42)));
      expect(r2.extractBytes(), isNot(Uint8List(42)));
      expect(r2.extractBytes(), isNot(r1));
    });

    test('produces readable fingerprint', () {
      final data = Uint8List.fromList(List.filled(24, 24));

      final fingerprint = sut.prettyFingerprint(data);
      expect(fingerprint, '''
31673   91441   90258   74554
78663   92652   90971   70634
10478   78386   01763   47743''');
    });
  });
}
