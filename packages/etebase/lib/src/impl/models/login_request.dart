import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../codec/msg_pack_converters.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

@internal
@freezed
sealed class LoginRequest with _$LoginRequest {
  @msgPackBytes
  const factory LoginRequest({
    required Uint8List response,
    required Uint8List signature,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
