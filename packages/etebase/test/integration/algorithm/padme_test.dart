import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/crypto/executors/sync_crypto_executor.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

import '../util/library_loader.dart';

void main() {
  late CryptoService sut;

  setUpAll(() async {
    final sodium = await SodiumSumoInit.init(getLibsodium);
    final executor = SyncCryptoExecutor(sodium);
    sut = CryptoService(executor);
  });

  testData(
    'can pad/unpad random data of any size',
    [
      for (var i = 0; i < 25; ++i) [(1 << i) - 1, (1 << i), (1 << i) + 1],
    ],
    dataToString: (e) => '[${e.first.bitLength}:${e.last.bitLength}]',
    (fixture) async {
      for (final size in fixture) {
        final data = sut.randomBytes(size);
        final padded = await sut.bufferPad(data);
        expect(padded.length, greaterThanOrEqualTo(1024));
        final unpadded = await sut.bufferUnpad(padded);
        expect(unpadded, data);
      }
    },
  );
}
