import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'crypto_utils.dart';

@internal
class CryptoMac {
  final GenericHashConsumer consumer;

  CryptoMac(SodiumSumo sodium, {SecureKey? key, int length = 32})
      : consumer = sodium.crypto.genericHash.createConsumer(
          outLen: length,
          key: key,
        );

  void updateWithLenPrefix(Uint8List messageChunk) {
    consumer
      ..add(CryptoUtils.uint32ToUint8List(messageChunk.length))
      ..add(messageChunk);
  }

  void update(Uint8List messageChunk) {
    consumer.add(messageChunk);
  }

  Future<Uint8List> finalize() => consumer.close();
}
