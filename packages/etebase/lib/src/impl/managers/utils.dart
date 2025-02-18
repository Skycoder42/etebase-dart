import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import 'client.dart';

@internal
sealed class Utils {
  Utils._();

  static Uint8List randombytes(Client client, int size) =>
      client.crypto.randomBytes(size);

  static SecureKey randomKey(Client client, int size) =>
      client.crypto.secureRandom(size);

  static String prettyFingerprint(Client client, Uint8List content) =>
      client.crypto.prettyFingerprint(content);
}
