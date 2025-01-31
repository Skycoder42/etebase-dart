import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/etebase_user.dart';
import '../codec/byte_array_converter.dart';

part 'signup_request.freezed.dart';
part 'signup_request.g.dart';

@internal
@freezed
sealed class SignupRequest with _$SignupRequest {
  @msgPackBytes
  const factory SignupRequest({
    required EtebaseUser user,
    required Uint8List salt,
    required Uint8List loginPubkey,
    required Uint8List pubkey,
    required Uint8List encryptedContent,
  }) = _SignupRequest;

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);
}
