// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@internal
@freezed
sealed class LoginResponse with _$LoginResponse {
  const factory LoginResponse({required String token, required User user}) =
      _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
