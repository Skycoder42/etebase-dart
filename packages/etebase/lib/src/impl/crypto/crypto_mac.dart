import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/exceptions/crypto_failure.dart';
import '../../api/managers/crypto_executor.dart';
import 'crypto_utils.dart';

@internal
class CryptoMac {
  final GenericHashConsumer consumer;

  CryptoMac(CryptoExecutor executor, {SecureKey? key, int length = 32})
      : consumer = executor.execSync(
          (sodium) => sodium.crypto.genericHash.createConsumer(
            outLen: length,
            key: key,
          ),
        );

  void updateWithLenPrefix(Uint8List messageChunk) {
    consumer
      ..add(CryptoUtils.uint32ToUint8List(messageChunk.length))
      ..add(messageChunk);
  }

  void update(Uint8List messageChunk) {
    consumer.add(messageChunk);
  }

  Future<Uint8List> finalize() =>
      CryptoFailure.wrap<Future<Uint8List>, Uint8List>(consumer.close);
}
