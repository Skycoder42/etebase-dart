// coverage:ignore-file

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../impl/codec/byte_array_converter.dart';
import 'signed_invitation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// A user's public profile.
@freezed
sealed class UserProfile with _$UserProfile {
  /// Default Constructor.
  @msgPackBytes
  const factory({
    /// The user's identity public key.
    ///
    /// This is used for identifying the user and safely sending them data (such
    /// as [SignedInvitation]s).
    required Uint8List pubkey,
  }) = _UserProfile;

  /// @nodoc
  @internal
  factory fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}
