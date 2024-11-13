import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/etebase_collection_access_level.dart';
import '../codec/msg_pack_converters.dart';

part 'signed_invitation.freezed.dart';
part 'signed_invitation.g.dart';

@freezed
@internal
sealed class SignedInvitation with _$SignedInvitation {
  @msgPackBytes
  const factory SignedInvitation({
    required String uid,
    required int version,
    required String username,
    required String collection,
    required EtebaseCollectionAccessLevel accessLevel,
    required Uint8List signedEncryptionKey,
  }) = _SignedInvitation;

  factory SignedInvitation.fromJson(Map<String, dynamic> json) =>
      _$SignedInvitationFromJson(json);
}
