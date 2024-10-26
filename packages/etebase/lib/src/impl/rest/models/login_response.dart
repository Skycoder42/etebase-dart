import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../converters/msg_pack_converters.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@internal
@freezed
sealed class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String token,
    required LoginResponseUser user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@internal
@freezed
sealed class LoginResponseUser with _$LoginResponseUser {
  @msgPackBytes
  const factory LoginResponseUser({
    required Uint8List pubkey,
    required Uint8List encryptedContent,
  }) = _LoginResponseUser;

  factory LoginResponseUser.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseUserFromJson(json);
}
