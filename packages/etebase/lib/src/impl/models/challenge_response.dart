// coverage:ignore-file

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../codec/byte_array_converter.dart';

part 'challenge_response.freezed.dart';
part 'challenge_response.g.dart';

@internal
@Freezed(unionKey: 'action')
sealed class ChallengeResponse with _$ChallengeResponse {
  @msgPackBytes
  const factory login({
    required String username,
    required Uint8List challenge,
    required String host,
  }) = _LoginChallengeResponse;

  @msgPackBytes
  const factory changePassword({
    required String username,
    required Uint8List challenge,
    required String host,
    required Uint8List loginPubkey,
    required Uint8List encryptedContent,
  }) = _ChangePasswordChallengeResponse;

  factory fromJson(Map<String, dynamic> json) =>
      _$ChallengeResponseFromJson(json);
}
