// coverage:ignore-file

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../codec/byte_array_converter.dart';

part 'signed_invitation_content.freezed.dart';
part 'signed_invitation_content.g.dart';

@freezed
@internal
sealed class SignedInvitationContent with _$SignedInvitationContent {
  @msgPackBytes
  const factory({
    required Uint8List encryptionKey,
    required String collectionType,
  }) = _SignedInvitationContent;

  factory fromJson(Map<String, dynamic> json) =>
      _$SignedInvitationContentFromJson(json);
}
