import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../impl/codec/msg_pack_converters.dart';
import 'etebase_signed_invitation.dart';

part 'etebase_user_profile.freezed.dart';
part 'etebase_user_profile.g.dart';

/// The dart binding of the EtebaseUserProfile rust class
@freezed
class EtebaseUserProfile with _$EtebaseUserProfile {
  /// Constructor
  @msgPackBytes
  const factory EtebaseUserProfile({
    /// The user's identity public key
    ///
    /// This is used for identifying the user and safely sending them data (such
    /// as [EtebaseSignedInvitation]).
    required Uint8List pubkey,
  }) = _EtebaseUserProfile;

  /// @nodoc
  @internal
  factory EtebaseUserProfile.fromJson(Map<String, dynamic> json) =>
      _$EtebaseUserProfileFromJson(json);
}
