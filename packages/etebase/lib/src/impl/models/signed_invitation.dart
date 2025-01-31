// ignore_for_file: invalid_annotation_target

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/etebase_collection_access_level.dart';
import '../../api/models/etebase_signed_invitation.dart';
import '../codec/byte_array_converter.dart';

part 'signed_invitation.freezed.dart';
part 'signed_invitation.g.dart';

@Freezed(fromJson: true, toJson: false)
@internal
sealed class SignedInvitation with _$SignedInvitation {
  @JsonSerializable(createToJson: true)
  @msgPackBytes
  const factory SignedInvitation.write({
    required String uid,
    required int version,
    required String username,
    required String collection,
    required EtebaseCollectionAccessLevel accessLevel,
    required Uint8List signedEncryptionKey,
  }) = SignedInvitationWrite;

  @JsonSerializable(createToJson: true)
  @msgPackBytes
  @Implements<EtebaseSignedInvitation>()
  const factory SignedInvitation.read({
    required String uid,
    required int version,
    required String username,
    required String collection,
    required EtebaseCollectionAccessLevel accessLevel,
    required Uint8List signedEncryptionKey,
    String? fromUsername,
    @JsonKey(name: 'fromPubkey') required Uint8List fromPubKey,
  }) = SignedInvitationRead;

  const SignedInvitation._();

  Map<String, dynamic> toJson() => switch (this) {
        final SignedInvitationWrite w =>
          _$$SignedInvitationWriteImplToJson(w as _$SignedInvitationWriteImpl),
        final SignedInvitationRead r =>
          _$$SignedInvitationReadImplToJson(r as _$SignedInvitationReadImpl),
      }
        ..remove('runtimeType');
}
