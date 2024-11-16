import 'dart:typed_data';

import '../../impl/managers/client.dart';
import '../../impl/managers/utils.dart';
import 'etebase_client.dart';

/// A collection of useful utility functions.
sealed class EtebaseUtils {
  EtebaseUtils._();

  /// Return a buffer of [size] (in bytes) filled with cryptographically random
  /// bytes.
  static Uint8List randombytes(
    EtebaseClient client,
    int size,
  ) =>
      Utils.randombytes(client as Client, size);

  /// Return a pretty formatted fingerprint of the [content].
  ///
  /// For example:
  /// ```plain
  /// 45680   71497   88570   93128
  /// 19189   84243   25687   20837
  /// 47924   46071   54113   18789
  /// ```
  static String prettyFingerprint(
    EtebaseClient client,
    Uint8List content,
  ) =>
      Utils.prettyFingerprint(client as Client, content);
}
