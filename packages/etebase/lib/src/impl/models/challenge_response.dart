import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../rest/converters/msg_pack_converters.dart';

part 'challenge_response.freezed.dart';
part 'challenge_response.g.dart';

@internal
@Freezed(unionKey: 'action')
sealed class ChallengeResponse with _$ChallengeResponse {
  @msgPackBytes
  const factory ChallengeResponse.login({
    required String username,
    required Uint8List challenge,
    required String host,
  }) = _LoginChallengeResponse;

  @msgPackBytes
  const factory ChallengeResponse.changePassword({
    required String username,
    required Uint8List challenge,
    required String host,
    required Uint8List loginPubkey,
    required Uint8List encryptedContent,
  }) = _ChangePasswordChallengeResponse;

  factory ChallengeResponse.fromJson(Map<String, dynamic> json) =>
      _$ChallengeResponseFromJson(json);
}
