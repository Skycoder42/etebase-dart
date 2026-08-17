// ignore_for_file: invalid_annotation_target

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/collection_access_level.dart';
import '../../api/models/signed_invitation.dart';
import '../codec/byte_array_converter.dart';

part 'signed_invitation_base.freezed.dart';
part 'signed_invitation_base.g.dart';

@Freezed(fromJson: true, toJson: false)
@internal
sealed class SignedInvitationBase with _$SignedInvitationBase {
  @JsonSerializable(createToJson: true)
  @msgPackBytes
  const factory write({
    required String uid,
    required int version,
    required String username,
    required String collection,
    required CollectionAccessLevel accessLevel,
    required Uint8List signedEncryptionKey,
  }) = SignedInvitationWrite;

  @JsonSerializable(createToJson: true)
  @msgPackBytes
  @Implements<SignedInvitation>()
  const factory read({
    required String uid,
    required int version,
    required String username,
    required String collection,
    required CollectionAccessLevel accessLevel,
    required Uint8List signedEncryptionKey,
    String? fromUsername,
    @JsonKey(name: 'fromPubkey') required Uint8List fromPubKey,
  }) = SignedInvitationRead;

  const new _();

  Map<String, dynamic> toJson() => switch (this) {
    final SignedInvitationWrite w => _$SignedInvitationWriteToJson(w),
    final SignedInvitationRead r => _$SignedInvitationReadToJson(r),
  }..remove('runtimeType');
}
