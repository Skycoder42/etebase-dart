import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../rest/converters/msg_pack_converters.dart';

part 'signed_invitation_content.freezed.dart';
part 'signed_invitation_content.g.dart';

@freezed
@internal
class SignedInvitationContent with _$SignedInvitationContent {
  @msgPackBytes
  const factory SignedInvitationContent({
    required Uint8List encryptionKey,
    required String collectionType,
  }) = _SignedInvitationContent;

  factory SignedInvitationContent.fromJson(Map<String, dynamic> json) =>
      _$SignedInvitationContentFromJson(json);
}
