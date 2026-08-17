// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

import 'login_response_user.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@internal
@freezed
sealed class LoginResponse with _$LoginResponse {
  const factory({required String token, required LoginResponseUser user}) =
      _LoginResponse;

  factory fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}
