// coverage:ignore-file

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../codec/byte_array_converter.dart';

part 'login_response_user.freezed.dart';
part 'login_response_user.g.dart';

@internal
@Freezed(copyWith: true)
sealed class LoginResponseUser with _$LoginResponseUser {
  @msgPackBytes
  const factory LoginResponseUser({
    required String username,
    required String email,
    required Uint8List pubkey,
    required Uint8List encryptedContent,
  }) = _LoginResponseUser;

  factory LoginResponseUser.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseUserFromJson(json);
}
