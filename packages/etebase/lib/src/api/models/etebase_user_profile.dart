import 'dart:typed_data';

import 'etebase_signed_invitation.dart';

/// The dart binding of the EtebaseUserProfile rust class
abstract class EtebaseUserProfile {
  /// The user's identity public key
  ///
  /// This is used for identifying the user and safely sending them data (such
  /// as [EtebaseSignedInvitation]).
  Uint8List get pubkey;
}
