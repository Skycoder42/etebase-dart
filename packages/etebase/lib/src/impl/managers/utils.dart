import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'client.dart';

@internal
sealed class Utils {
  Utils._();

  static Uint8List randombytes(
    Client client,
    int size,
  ) =>
      client.crypto.randomBytes(size);

  static String prettyFingerprint(
    Client client,
    Uint8List content,
  ) =>
      client.crypto.prettyFingerprint(content);
}
