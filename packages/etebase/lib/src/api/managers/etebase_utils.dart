import 'dart:typed_data';

import '../../impl/managers/client.dart';
import '../../impl/managers/utils.dart';
import 'etebase_client.dart';

/// The dart binding of the EtebaseUtils rust class
sealed class EtebaseUtils {
  EtebaseUtils._();

  /// Return a buffer filled with cryptographically random bytes
  ///
  /// @param[out] buf the output byte buffer
  /// @param size the size of the returned buffer
  static Uint8List randombytes(
    EtebaseClient client,
    int size,
  ) =>
      Utils.randombytes(client as Client, size);

  /// Return a pretty formatted fingerprint of the content
  ///
  /// For example:
  /// ```
  /// 45680   71497   88570   93128
  /// 19189   84243   25687   20837
  /// 47924   46071   54113   18789
  /// ```
  ///
  /// @param content the content to create a fingerprint for
  /// @param content_size the size of the content buffer
  /// @param[out] buf the output byte buffer
  static String prettyFingerprint(
    EtebaseClient client,
    Uint8List content,
  ) =>
      Utils.prettyFingerprint(client as Client, content);
}
