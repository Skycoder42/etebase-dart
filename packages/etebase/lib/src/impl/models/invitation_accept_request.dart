import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../codec/byte_array_converter.dart';

part 'invitation_accept_request.freezed.dart';
part 'invitation_accept_request.g.dart';

@internal
@freezed
sealed class InvitationAcceptRequest with _$InvitationAcceptRequest {
  @msgPackBytes
  const factory InvitationAcceptRequest({
    required Uint8List collectionType,
    required Uint8List encryptionKey,
  }) = _InvitationAcceptRequest;

  factory InvitationAcceptRequest.fromJson(Map<String, dynamic> json) =>
      _$InvitationAcceptRequestFromJson(json);
}
